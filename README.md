# Text Viewer

Text Viewer is a native macOS app for opening and reading plain-text files — logs, notes, configuration, source code, and structured text. Every file is shown literally as text: Markdown syntax is not rendered or interpreted. The app works offline and does not include analytics, crash reporting, or automatic updates.

## Features

- Open files from Finder, drag and drop, the Open dialog, or the command line.
- Browse a folder in the file navigator and move between recently opened files.
- Keep documents in tabs or separate windows; navigate backward and forward through file history.
- Search within a document with match highlighting and next/previous navigation.
- Read in a selectable monospaced view with adjustable fonts, line spacing, width, themes, and zoom.
- Inspect file location, size, modification time, and text statistics.
- Optionally edit and save a plain-text document, with configurable automatic saving.
- Keep windows on top, customize the toolbar, and use macOS sharing and clipboard actions.
- Print or export a document, including PDF.
- Preview supported text files in Finder Quick Look.
- Hand a file off to an installed text editor or supported AI app.
- Install the `text-viewer` / `tv` command-line launcher and open files or folders from a shell.
- Open files through the `text-viewer://file/<absolute-path>` URL scheme.

## Supported files

Common text and source extensions include `.txt`, `.text`, `.log`, `.out`, `.conf`, `.cfg`, `.ini`, `.env`, `.csv`, `.tsv`, `.json`, `.xml`, `.yaml`, `.yml`, `.toml`, `.md`, `.markdown`, `.swift`, `.py`, `.js`, `.ts`, `.css`, `.html`, `.sh`, `.zsh`, and `.bash`. Markdown files are displayed as their raw source.

## Requirements

- macOS 15 or later
- Xcode with the macOS SDK

## Build

```sh
xcodebuild -project TextViewer.xcodeproj -scheme TextViewer -configuration Debug -derivedDataPath build build CODE_SIGNING_ALLOWED=NO
```

The built app is placed under `build/Build/Products/Debug/Text Viewer.app`.

## Origin and license

The project is based on [pluk-inc/markdown-preview](https://github.com/pluk-inc/markdown-preview), with Markdown presentation features removed and general document-viewing features retained. It is distributed under the MIT license; see [LICENSE](LICENSE).
