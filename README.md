# Text Viewer

Text Viewer is a small native macOS app for reading plain-text files such as `.txt`, `.log`, configuration files, source code, and structured text.

It is intentionally read-only: open a file and get a fast, selectable, searchable monospaced view. There is no Markdown rendering, editing, browser engine, Quick Look extension, analytics, updater, or network dependency.

## Supported files

Text Viewer registers as an alternate viewer for common text extensions, including:

`.txt`, `.log`, `.out`, `.conf`, `.cfg`, `.ini`, `.env`, `.csv`, `.tsv`, `.json`, `.xml`, `.yaml`, `.yml`, `.toml`, `.md`, `.markdown`, `.swift`, `.py`, `.js`, `.ts`, `.css`, `.html`, `.sh`, `.zsh`, and `.bash`.

Files can also be opened from the app with `⌘O` or by passing them to the app from Finder or the command line.

## Requirements

- macOS 15 or later
- Xcode 27 or later

## Build

```sh
xcodebuild -project TextViewer.xcodeproj -scheme TextViewer -configuration Debug -derivedDataPath build build CODE_SIGNING_ALLOWED=NO
```

The built app is placed under `build/Build/Products/Debug/Text Viewer.app`.

## Origin

The initial project structure was based on [pluk-inc/markdown-preview](https://github.com/pluk-inc/markdown-preview). Text Viewer is a deliberately stripped-down derivative focused only on reading text files.

## License

MIT. See [LICENSE](LICENSE).
