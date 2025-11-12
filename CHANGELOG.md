# Changelog

## [1.0.0] - 2025-11-12

### Added

#### Core Features
- **Multi-Repository Patch Updates**: Automatically check for updates to installed patches from multiple GitHub repositories simultaneously
- **Multi-Repository Plugin Updates**: Check for plugin updates from multiple GitHub repositories
- **Selective Updates**: Choose which patches/plugins to update with checkboxes
- **Smart Caching**: Repository data is cached to reduce API calls and improve performance
- **Rate Limit Handling**: Automatically handles GitHub API rate limits with intelligent retry logic
- **Progress Display**: Real-time progress updates during update checks and installations
- **Safe Installation**: Backs up existing patches and plugins before updating (`.old` files)
- **MD5 Verification**: Validates patch integrity using MD5 checksums

#### Patch Management
- **Patch Descriptions**: 
  - Automatic extraction from `updates.json` files in repositories
  - Fallback to parsing comments from patch files
  - Local editing and customization of descriptions
  - Preview in update lists and detailed view
- **Patch Information**: View detailed information about patches including:
  - Author and repository
  - Description (from multiple sources)
  - File size and MD5 hash
  - Repository URL
- **Ignore List**: Ability to ignore specific patches from update checks via `updatesmanager_ignored_patches.txt`
- **Patch Details**: Long-press on patches to view detailed information

#### Plugin Management
- **Plugin Version Comparison**: Automatic semantic version comparison for plugins
- **Plugin Information**: View detailed information about plugins including:
  - Version (installed vs. available)
  - Release notes
  - Repository URL
- **Default Plugin Filtering**: Default KOReader plugins are automatically hidden from the installed plugins list
- **Plugin Details**: Long-press on plugins to view detailed information

#### User Interface
- **Menu Structure**: Organized into Patches, Plugins, and Settings sections
- **Force Refresh**: Option to bypass cache and fetch fresh data
- **Update Results**: Detailed display of successful and failed updates
- **Installed Patches List**: View all installed patches with descriptions
- **Installed Plugins List**: View all installed plugins with versions
- **Edit Descriptions**: Ability to edit patch descriptions locally
- **Progress Monitoring**: File-based progress communication for non-blocking operations

#### Configuration
- **Default Repositories**: Pre-configured list of popular patch and plugin repositories
- **Custom Repository Support**: Add custom repositories via configuration file
- **Repository Settings Menu**: View configuration file location and repository counts
- **Configuration File**: `KOReader/settings/updatesmanager_config.json`

#### Technical Features
- **Network Management**: Automatic Wi-Fi connection handling
- **Error Handling**: Graceful handling of network errors and API limits
- **Subprocess Support**: Uses `Trapper:dismissableRunInSubprocess` for non-blocking operations
- **Fallback Mode**: Handles blocking mode gracefully with UI updates
- **File Locations**:
  - Configuration: `KOReader/settings/updatesmanager_config.json`
  - Cache: `KOReader/settings/updatesmanager_cache/`
  - Local Descriptions: `KOReader/settings/updatesmanager_patch_descriptions.json`
  - Ignored Patches: `KOReader/settings/updatesmanager_ignored_patches.txt`

### Default Repositories

<details>
<summary><strong>Patch Repositories (8)</strong></summary>

- joshuacant/KOReader.patches
- angelsangita/Koreader-Patches
- SeriousHornet/KOReader.patches
- sebdelsol/KOReader.patches
- zenixlabs/koreader-frankenpatches-public
- omer-faruq/koreader-user-patches
- loeffner/KOReader.patches (collection and project-title subfolders)
- advokatb/KOReader-Patches

</details>

<details>
<summary><strong>Plugin Repositories (22)</strong></summary>

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

### Notes

- Based on `2-update-patches.lua` by sebdelsol
- Inspired by the KOReader patch and plugin ecosystem
- This is the initial release - the system is complex and requires thorough testing

