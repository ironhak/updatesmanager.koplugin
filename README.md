# Updates Manager Plugin for KOReader

Updates Manager is a plugin for KOReader that helps you manage updates for patches and plugins from multiple GitHub repositories.

<a id="features"></a>
## Features

### ✅ Implemented Features

- **Multi-Repository Updates**: Automatically check for updates from multiple GitHub repositories
- **Selective Updates**: Choose which patches/plugins to update with checkboxes
- **Smart Caching**: Repository data is cached to reduce API calls and improve performance
- **Rate Limit Handling**: Automatically handles GitHub API rate limits with intelligent retry logic
- **Progress Display**: Real-time progress updates during update checks
- **Safe Installation**: Backs up existing files before updating
- **MD5 Verification**: Validates file integrity using MD5 checksums
- **Patch Descriptions**: Automatic extraction from `updates.json`, fallback to comments, local editing
- **Plugin Version Management**: Automatic version comparison for plugins
- **Network Management**: Automatic Wi-Fi connection handling
- **Error Handling**: Graceful handling of network errors and API limits

### 🚧 Future Features

- **Repository Management UI**: Add/remove repositories through the plugin interface
- **Update Notifications**: Automatic background checks for updates

<a id="installation"></a>
## Installation

1. Download the latest release from the [Releases](https://github.com/YOUR_USERNAME/updatesmanager.koplugin/releases) page
2. Extract the `updatesmanager.koplugin` folder to your KOReader `plugins` directory
3. Restart KOReader

<a id="usage"></a>
## Usage

<a id="menu-structure"></a>
### Menu Structure

The plugin menu is organized into three main sections:

- **Patches**: Manage patch updates
  - Check for Updates
  - Force Refresh (ignore cache)
  - Installed Patches
- **Plugins**: Manage plugin updates
  - Check for Updates
  - Force Refresh
  - Installed Plugins
- **Settings**: Configuration options
  - Repository Settings
  - Clear Cache

<a id="force-refresh"></a>
### Force Refresh

**Force Refresh** bypasses the cache and fetches fresh data from all repositories. Use it when:
- You suspect the cache is outdated
- You want to check for updates immediately after a repository change
- You're experiencing issues with update detection

**Note**: Force Refresh will make more API calls and may take longer, especially with many repositories.

---

<a id="managing-patches"></a>
## 📝 Managing Patches

<a id="patches-for-users"></a>
### For Users

<a id="patch-warnings"></a>
#### Important Warnings

<details>
<summary><strong>⚠️ Your custom patch modifications will be overwritten!</strong></summary>

**When you update a patch, any local modifications you made to the patch file will be completely replaced with the version from the repository.**

- The plugin creates a backup (`.old` file) before updating
- If you've modified a patch, consider:
  - Creating your own repository with your modified version
  - Documenting your changes before updating
  - Restoring from the `.old` backup if needed
</details>

<a id="checking-patch-updates"></a>
#### Checking for Patch Updates

1. Open KOReader menu
2. Navigate to **Updates Manager** → **Patches** → **Check for Updates**
3. The plugin will scan all configured patch repositories for updates
4. Select which patches you want to update using checkboxes
5. Long-press on any patch to view detailed information
6. Click **Update Selected** to install updates

<a id="viewing-installed-patches"></a>
#### Viewing Installed Patches

1. Navigate to **Updates Manager** → **Patches** → **Installed Patches**
2. View list of all installed patches with description previews
3. Tap on a patch to see detailed information
4. Use **Edit Description** to customize the patch description

<a id="editing-patch-descriptions"></a>
#### Editing Patch Descriptions

1. View patch details (from update list or installed patches)
2. Click **Edit Description**
3. Enter or modify the description
4. Click **Save**

Descriptions are saved locally and take priority over repository descriptions.

<a id="ignoring-patch-updates"></a>
#### Ignoring Patch Updates

If you've modified a patch and don't want it to appear in the update list, you can add it to the ignore list.

**How to ignore a patch:**

1. Create or edit the file: `KOReader/settings/updatesmanager_ignored_patches.txt`
2. Add one patch name per line (without `.lua` extension)
3. Lines starting with `#` are treated as comments
4. Empty lines are ignored

**Example file:**

```
# Patches I've modified and don't want to update
2-custom-folder-fonts
2-percent-badge
# Another modified patch
my-custom-patch
```

**Notes:**
- Patch names should be without the `.lua` extension
- The file is read each time you check for updates
- Ignored patches will not appear in the update list
- You can still manually update ignored patches by removing them from the ignore list

<a id="patches-for-authors"></a>
### For Patch Authors

<a id="adding-patch-repository"></a>
#### Adding Your Patch Repository

1. **Create a GitHub repository** with your patches (e.g., `KOReader.patches`)
2. **Optionally create `updates.json`** (see below) for better metadata
3. **Add your repository** to the plugin configuration (see Repository Configuration)

**Want to add your repository to the default list?**

You can create a pull request to add your repository to the plugin's default repository list. This way, all users will have access to your patches without manual configuration.

1. Fork the Updates Manager plugin repository
2. Add your repository to `config.lua` in the `DEFAULT_PATCH_REPOS` table
3. Create a pull request with a description of your patches repository
4. Your PR will be reviewed and merged, making your patches available to all users

<a id="creating-updates-json"></a>
#### Creating `updates.json` for Your Repository

To provide patch descriptions and metadata, create an `updates.json` file in your repository root (or in the same folder as your patches if they're in a subfolder).

**File Location:**
- **Root of repository**: `updates.json`
- **Subfolder with patches**: `subfolder/updates.json`

**File Format:**

```json
{
  "patches": [
    {
      "name": "2-custom-folder-fonts",
      "filename": "2-custom-folder-fonts.lua",
      "description": "Allows customizing folder fonts in KOReader. You can set different fonts for different folders in the file manager.",
      "author": "your-username",
      "version": "1.0.0",
      "md5": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6"
    },
    {
      "name": "2-percent-badge",
      "filename": "2-percent-badge.lua",
      "description": "Shows reading progress percentage as a badge on the book cover",
      "author": "your-username",
      "version": "1.2.0",
      "md5": "b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7"
    }
  ]
}
```

**Fields:**
- **`name`** (required): Patch name without `.lua` extension
- **`filename`** (optional): Full filename with extension
- **`description`** (optional): Human-readable description
- **`author`** (optional): Author name or GitHub username
- **`version`** (optional): Version string
- **`md5`** (optional but recommended): MD5 hash of the patch file. If provided, the plugin will use it directly instead of computing on-the-fly, reducing API calls

<a id="automatic-generation-github-actions"></a>
#### Automatic Generation with GitHub Actions

You can use GitHub Actions to automatically generate `updates.json` with MD5 hashes. 

**For patch repositories:**
- Copy `.github/workflows/generate-patch-updates-json.yml` from this plugin repository to your patch repository
- Place it in `.github/workflows/generate-updates-json.yml` (or keep the original name)
- The workflow will automatically run on every push to main/master branch

**For plugin repositories:**
- Copy `.github/workflows/generate-plugin-updates-json.yml` from this plugin repository to your plugin repository
- Place it in `.github/workflows/generate-updates-json.yml` (or keep the original name)
- The workflow will automatically run when `_meta.lua` or other `.lua` files are changed

**Note:** Both workflow files are included in the Updates Manager plugin repository as templates/examples. You only need to copy the one that matches your repository type (patches or plugins).

**For patch repositories, the action will:**
- Scan all `.lua` files (excluding `.disabled` files)
- Calculate MD5 hashes for each patch
- Extract descriptions from patch file comments
- Generate `updates.json` with patches array on every push to main/master branch

**For plugin repositories, the action will:**
- Extract plugin metadata from `_meta.lua` (name, version, description)
- Fetch latest release information from GitHub API
- Generate `updates.json` with plugin metadata

**How MD5 is used (for patches):**
- If `updates.json` contains MD5 hashes, the plugin uses them directly (faster, fewer API calls)
- If `updates.json` is not available or doesn't contain MD5, the plugin computes MD5 on-the-fly

**Note:** For plugins, `updates.json` is optional. The plugin primarily uses GitHub Releases for version checking. The `updates.json` for plugins can provide additional metadata but is not required for updates to work.

<a id="fallback-to-comments"></a>
#### Fallback to Comments

If `updates.json` is not available, the plugin will automatically extract descriptions from comments at the beginning of patch files:

```lua
-- This patch allows customizing folder fonts
-- You can set different fonts for different folders
-- Supports both system and custom fonts

local ok, guard = pcall(require, "patches/guard")
-- ... rest of patch code
```

The plugin will:
- Extract comment lines (starting with `--`)
- Skip metadata comments (version checks, requirements, etc.)
- Skip decorative lines (========, ----, etc.)
- Stop at the first non-comment line

<a id="description-priority"></a>
#### Description Priority

Patch descriptions are loaded in the following priority order:

1. **Local user-edited descriptions** (highest priority)
   - Stored in `KOReader/settings/updatesmanager_patch_descriptions.json`
   - Can be edited through the plugin UI

2. **`updates.json` from repository**
   - Loaded from repository root or patch subfolder

3. **Comments in patch files** (lowest priority)
   - Parsed from comment lines at the beginning of patch files

---

<a id="managing-plugins"></a>
## 🔌 Managing Plugins

<a id="plugins-for-users"></a>
### For Users

<a id="checking-plugin-updates"></a>
#### Checking for Plugin Updates

1. Open KOReader menu
2. Navigate to **Updates Manager** → **Plugins** → **Check for Updates**
3. The plugin will check all configured plugin repositories for updates
4. Select which plugins you want to update using checkboxes
5. Long-press on any plugin to view detailed information (version, release notes)
6. Click **Update Selected** to install updates

<a id="viewing-installed-plugins"></a>
#### Viewing Installed Plugins

1. Navigate to **Updates Manager** → **Plugins** → **Installed Plugins**
2. View list of all installed plugins with versions
3. Tap on a plugin to see detailed information (version, description, path)

**Note**: Default KOReader plugins (like `archiveviewer`, `autodim`, etc.) are hidden from this list as they are updated with KOReader itself.

<a id="plugins-for-authors"></a>
### For Plugin Authors

<a id="version-management"></a>
#### Version Management

**How version checking works:**
- The plugin reads the `version` field from your plugin's `_meta.lua` file
- It compares this version with the latest GitHub Release tag
- If the release version is newer, an update is shown

**Important**: You must specify a version in `_meta.lua` for the plugin to work correctly!

<a id="adding-version-to-plugin"></a>
#### Adding Version to Your Plugin

Edit your plugin's `_meta.lua` file and add a `version` field:

```lua
return {
    name = "myplugin",
    fullname = "My Plugin",
    description = "Description of my plugin",
    version = "1.0.0",  -- ← Add this line!
}
```

**Version Format:**
- Use semantic versioning (e.g., `"1.0.0"`, `"1.2.3"`, `"2.0.0-beta.1"`)
- The plugin supports versions with or without `v` prefix (e.g., `"v1.0.0"` or `"1.0.0"`)
- Versions are compared using semantic versioning rules

**⚠️ Important Warning:**
- If your `_meta.lua` doesn't have a `version` field, the plugin will show `"unknown"` as the current version
- **The plugin will always show an update available** if the version is `"unknown"`, even if you're already on the latest release
- **Always add a version to your `_meta.lua`** to avoid false update notifications

<a id="creating-github-releases"></a>
#### Creating GitHub Releases

1. **Create a GitHub Release** in your plugin repository
2. **Use version tags** that match your `_meta.lua` version (e.g., `v1.0.0`, `1.0.0`)
3. **Attach a ZIP file** containing your plugin folder (e.g., `myplugin.koplugin.zip`)
4. The plugin will automatically detect and offer the update

**Release Requirements:**
- Release tag should match or be compatible with the version in `_meta.lua`
- Release must have at least one asset (ZIP file)
- ZIP file should contain the plugin folder (e.g., `myplugin.koplugin/`)

<a id="adding-plugin-repository"></a>
#### Adding Your Plugin Repository

1. **Create a GitHub repository** for your plugin (e.g., `myplugin.koplugin`)
2. **Add version to `_meta.lua`** (see above)
3. **Create GitHub Releases** with version tags
4. **Add your repository** to the plugin configuration (see Repository Configuration)

**Want to add your plugin to the default list?**

You can create a pull request to add your plugin to the plugin's default repository list. This way, all users will have access to your plugin updates without manual configuration.

1. Fork the Updates Manager plugin repository
2. Add your plugin repository to `config.lua` in the `DEFAULT_PLUGIN_REPOS` table
3. Create a pull request with a description of your plugin
4. Your PR will be reviewed and merged, making your plugin available to all users

---

<a id="repository-configuration"></a>
## ⚙️ Repository Configuration

<a id="configuration-file-location"></a>
### Configuration File Location

```
KOReader/settings/updatesmanager_config.json
```

<a id="example-configuration-patches"></a>
### Example Configuration for Patches

Patches are typically stored in a single repository with multiple patch files. One repository can contain many patches, optionally organized in subfolders.

```json
{
  "patches": [
    {
      "owner": "username",
      "repo": "KOReader.patches",
      "branch": "main",
      "path": "",
      "description": "User's patches collection"
    },
    {
      "owner": "username",
      "repo": "KOReader.patches",
      "branch": "main",
      "path": "subfolder",
      "description": "Patches in subfolder"
    },
    {
      "owner": "anotheruser",
      "repo": "my-patches",
      "branch": "main",
      "path": "collection",
      "description": "Another user's patches"
    }
  ]
}
```

<a id="example-configuration-plugins"></a>
### Example Configuration for Plugins

Plugins are typically in separate repositories. Each plugin is usually in its own repository, and the repository name often matches the plugin name.

```json
{
  "plugins": [
    {
      "owner": "username",
      "repo": "myplugin.koplugin",
      "description": "My custom plugin"
    }
  ]
}
```

<a id="complete-example-configuration"></a>
### Complete Example Configuration

You can combine both patches and plugins in a single configuration file:

```json
{
  "patches": [
    {
      "owner": "username",
      "repo": "KOReader.patches",
      "branch": "main",
      "path": "",
      "description": "User's patches collection"
    }
  ],
  "plugins": [
    {
      "owner": "username",
      "repo": "myplugin.koplugin",
      "description": "My custom plugin"
    }
  ]
}
```

<a id="repository-settings"></a>
### Repository Settings

The **Repository Settings** menu (available in **Updates Manager** → **Settings** → **Repository Settings**) shows:
- Location of the configuration file
- Number of custom patch repositories (if any)
- Number of custom plugin repositories (if any)
- Instructions for adding custom repositories

To add custom repositories, edit the configuration file manually. The plugin will merge custom repositories with the default list.

---

<a id="technical-details"></a>
## 🔧 Technical Details

<details>
<summary><strong>Click to expand technical details</strong></summary>

<a id="caching"></a>
### Caching

- Repository data is cached in `KOReader/settings/updatesmanager_cache/repository_cache.json`
- Plugin data is cached in `KOReader/settings/updatesmanager_cache/plugin_cache.json`
- Cache is valid until manually cleared or force refresh is used
- Cache includes metadata but not full file content (to save space)

<a id="rate-limiting"></a>
### Rate Limiting

- The plugin implements intelligent rate limiting to avoid GitHub API limits
- Small delays between API requests
- Automatic detection and handling of 403/429 errors
- Graceful degradation when rate limits are hit

<a id="file-locations"></a>
### File Locations

- **Configuration**: `KOReader/settings/updatesmanager_config.json`
- **Cache**: `KOReader/settings/updatesmanager_cache/`
- **Local Descriptions**: `KOReader/settings/updatesmanager_patch_descriptions.json`
- **Ignored Patches**: `KOReader/settings/updatesmanager_ignored_patches.txt`
- **Patches**: `KOReader/patches/`
- **Plugins**: `KOReader/plugins/`

<a id="supported-repositories"></a>
### Supported Repositories

The plugin includes support for the following patch repositories by default:

- joshuacant/KOReader.patches
- angelsangita/Koreader-Patches
- SeriousHornet/KOReader.patches
- sebdelsol/KOReader.patches
- zenixlabs/koreader-frankenpatches-public
- omer-faruq/koreader-user-patches
- loeffner/KOReader.patches (collection and project-title subfolders)
- advokatb/KOReader-Patches

And the following plugin repositories:

- loeffner/WeatherLockscreen
- advokatb/readingstreak.koplugin
- advokatb/updatesmanager.koplugin
- bozo22/imagebookmarks.koplugin
- roygbyte/weather.koplugin
- marinov752/emailtokoreader.koplugin
- omer-faruq/memobook.koplugin
- 0zd3m1r/koreader-booknotes-plugin
- omer-faruq/rssreader.koplugin
- 0zd3m1r/koreader-xray-plugin
- Billiam/crashlog.koplugin
- kodermike/airplanemode.koplugin
- kristianpennacchia/zzz-readermenuredesign.koplugin
- patelneeraj/filebrowserplus.koplugin
- omer-faruq/webbrowser.koplugin
- Billiam/hardcoverapp.koplugin
- omer-faruq/assistant.koplugin
- monk-blade/multiline-toc-koreader
- 0xmiki/telegramhighlights.koplugin
- Evgeniy-94/TelegramDownloader.koplugin
- joshuacant/ProjectTitle
- JoeBumm/Koreader-Menu-customizer

</details>

---

<a id="troubleshooting"></a>
## 🐛 Troubleshooting

<a id="updates-not-found"></a>
### Updates Not Found

- Check your internet connection
- Verify repository URLs in configuration
- Try "Force Refresh" to clear cache
- Check logs for API rate limit messages

<a id="description-not-showing"></a>
### Description Not Showing

- Ensure `updates.json` is in the correct location
- Check that patch file has comments at the beginning
- Try editing description locally through the plugin

<a id="plugin-freezes"></a>
### Plugin Freezes

- Check network connection
- Wait for rate limits to reset (usually 1 hour)
- Clear cache and try again
- Check logs for errors

<a id="plugin-always-shows-update"></a>
### Plugin Always Shows Update Available

- **Check if your plugin's `_meta.lua` has a `version` field**
- If version is missing or `"unknown"`, the plugin will always show updates
- Add a proper version to `_meta.lua` (see "For Plugin Authors" section)

---

<a id="contributing"></a>
## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues.

<a id="credits"></a>
## Credits

- Based on `2-update-patches.lua` by sebdelsol
- Inspired by the KOReader patch and plugin ecosystem