--[[--
Repository Manager for Updates Manager
Handles GitHub API interactions and repository scanning
]]--

local logger = require("logger")
local json = require("json")

-- Local variable to store injected Utils (for subprocess compatibility)
local injected_Utils = nil

-- Utils will be injected before use, or loaded here if not in subprocess
local function getUtils()
    if injected_Utils then
        return injected_Utils
    end
    local ok, utils = pcall(require, "utils")
    if ok and utils then
        return utils
    end
    error("Utils module not available")
end

local RepositoryManager = {}

-- Function to inject Utils (called from main.lua before subprocess)
function RepositoryManager.setUtils(Utils)
    injected_Utils = Utils
end

-- Get GitHub API URL for raw file
function RepositoryManager.getRawFileUrl(owner, repo, branch, path)
    local base_url = string.format("https://raw.githubusercontent.com/%s/%s/%s/", owner, repo, branch)
    if path and path ~= "" then
        return base_url .. path .. "/"
    end
    return base_url
end

-- Get GitHub API URL for repository contents
function RepositoryManager.getContentsUrl(owner, repo, branch, path)
    local api_url = string.format("https://api.github.com/repos/%s/%s/contents/", owner, repo)
    if path and path ~= "" then
        api_url = api_url .. path
    end
    if branch then
        api_url = api_url .. "?ref=" .. branch
    end
    return api_url
end

-- Get list of files in repository directory
function RepositoryManager.getRepositoryFiles(owner, repo, branch, path)
    local Utils = getUtils()
    local url = RepositoryManager.getContentsUrl(owner, repo, branch, path)
    
    local content, code = Utils.httpGet(url, {
        ["Accept"] = "application/vnd.github.v3+json",
    })
    
    if not content or code ~= 200 then
        logger.warn("UpdatesManager: Failed to get repository contents:", url, code)
        return nil
    end
    
    local files = Utils.parseJSON(content)
    if not files or type(files) ~= "table" then
        logger.warn("UpdatesManager: Invalid repository contents response")
        return nil
    end
    
    -- Filter only .lua files
    local lua_files = {}
    for _, item in ipairs(files) do
        if item.type == "file" and item.name:match("%.lua$") then
            table.insert(lua_files, {
                name = item.name,
                path = item.path,
                sha = item.sha,
                size = item.size,
                download_url = item.download_url,
            })
        end
    end
    
    return lua_files
end

-- Get file content from repository
function RepositoryManager.getFileContent(owner, repo, branch, file_path)
    local Utils = getUtils()
    local url = RepositoryManager.getRawFileUrl(owner, repo, branch, "") .. file_path
    
    local content, code = Utils.httpGet(url)
    
    if not content or code ~= 200 then
        logger.warn("UpdatesManager: Failed to get file content:", url, code)
        return nil
    end
    
    return content
end

-- Get file SHA (for change detection)
function RepositoryManager.getFileSHA(owner, repo, branch, file_path)
    -- Extract directory and filename
    local dir = file_path:match("^(.*)/")
    local filename = file_path:match("([^/]+)$")
    
    local files = RepositoryManager.getRepositoryFiles(owner, repo, branch, dir)
    if not files then
        return nil
    end
    
    for _, file in ipairs(files) do
        if file.name == filename then
            return file.sha
        end
    end
    
    return nil
end

-- Check if file has changed by comparing SHA
function RepositoryManager.hasFileChanged(owner, repo, branch, file_path, old_sha)
    local new_sha = RepositoryManager.getFileSHA(owner, repo, branch, file_path)
    if not new_sha then
        return false -- File doesn't exist in repo
    end
    
    if not old_sha then
        return true -- No old SHA, consider it changed (new file)
    end
    
    return new_sha ~= old_sha
end

-- Get repository info (description, etc.) from README or other metadata
function RepositoryManager.getRepositoryInfo(owner, repo)
    local Utils = getUtils()
    -- Try to get README
    local readme_url = string.format("https://api.github.com/repos/%s/%s/readme", owner, repo)
    local content, code = Utils.httpGet(readme_url, {
        ["Accept"] = "application/vnd.github.v3+json",
    })
    
    if content and code == 200 then
        local data = Utils.parseJSON(content)
        if data and data.content then
            -- Decode base64 content if needed
            -- For now, just return that we have info
            return {
                has_readme = true,
                description = data.description or "",
            }
        end
    end
    
    return {
        has_readme = false,
        description = "",
    }
end

-- Scan repository for patches and return list with metadata
function RepositoryManager.scanRepositoryForPatches(repo_config)
    local owner = repo_config.owner
    local repo = repo_config.repo
    local branch = repo_config.branch or "main"
    local path = repo_config.path or ""
    
    logger.info("UpdatesManager: Scanning repository:", owner .. "/" .. repo, "path:", path)
    
    local files = RepositoryManager.getRepositoryFiles(owner, repo, branch, path)
    if not files then
        return {}
    end
    
    local patches = {}
    for _, file in ipairs(files) do
        -- Skip disabled patches
        if not file.name:match("%.disabled$") then
            table.insert(patches, {
                name = file.name,
                path = file.path,
                sha = file.sha,
                size = file.size,
                download_url = file.download_url,
                repo_owner = owner,
                repo_name = repo,
                repo_path = path,
                repo_branch = branch,
                repo_url = string.format("https://github.com/%s/%s", owner, repo),
            })
        end
    end
    
    logger.info("UpdatesManager: Found", #patches, "patches in repository")
    return patches
end

-- Download patch file from repository
function RepositoryManager.downloadPatch(patch_info, local_path)
    local Utils = getUtils()
    local url = patch_info.download_url
    if not url then
        -- Construct URL if not provided
        url = RepositoryManager.getRawFileUrl(
            patch_info.repo_owner,
            patch_info.repo_name,
            patch_info.repo_branch,
            patch_info.repo_path
        ) .. patch_info.name
    end
    
    return Utils.downloadFile(url, local_path)
end

return RepositoryManager

