# clip2path

[English](README.md) | [繁體中文](README.zh-TW.md)

> Press `Ctrl + Alt + V` → the clipboard image is saved as a PNG file, and its **file path is typed at your cursor**. Your clipboard stays untouched — the image can still be pasted normally.

Perfect for CLI tools and AI coding agents (Claude Code, Codex, Gemini CLI...) that accept image **paths** but not pasted images: take a screenshot, press the hotkey in your terminal, and the path appears right where you need it.

## How it works

```
┌──────────────┐   Ctrl+Alt+V   ┌─────────────────────────┐
│  Screenshot   │ ─────────────▶ │ %TEMP%\clipboard_*.png  │
│ in clipboard  │                └─────────────────────────┘
└──────────────┘                             │
       │                                     ▼
       │  clipboard untouched,   path typed at your cursor:
       └─ image still pastable   C:\Users\you\AppData\Local\Temp\clipboard_20260611_081721.png
```

- **AutoHotkey v2** registers the global hotkey and types the path with `SendText` (no clipboard involved).
- **PowerShell** reads the clipboard image and saves it as PNG.
- A shortcut in your **Startup folder** makes it survive reboots.

## Requirements

- Windows 10 / 11
- [AutoHotkey v2](https://www.autohotkey.com/) — installed automatically via `winget` if missing

## Install (one line)

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/j7-dev/clip2path/main/install.ps1 | iex
```

That's it. The hotkey works immediately and after every reboot.

<details>
<summary>What the installer does</summary>

1. Installs AutoHotkey v2 via `winget` if not present
2. Copies `clip2path.ahk` + `save-clipboard-image.ps1` to `%LOCALAPPDATA%\clip2path`
3. Creates a shortcut in your Startup folder (auto-start on boot)
4. Starts the hotkey listener right away

No admin rights required. Nothing is written outside your user profile.

</details>

## Usage

1. Copy any image to the clipboard (e.g. `Win + Shift + S` screenshot, or right-click → Copy Image)
2. Place your cursor in any text field (terminal, editor, chat box...)
3. Press `Ctrl + Alt + V`
4. The PNG path is typed at your cursor; a toast notification confirms the save

If the clipboard has no image, you get a notification instead — nothing is typed.

## Customization

Edit `%LOCALAPPDATA%\clip2path\clip2path.ahk`, then double-click it to reload:

| What | How |
|---|---|
| Hotkey | Change `^!v::` (e.g. `^!+v::` = Ctrl+Alt+Shift+V) |
| Save folder | Replace `A_Temp` with any folder path |

> **Note:** `Ctrl + Alt + V` overrides "Paste Special" in Microsoft Office apps. Change the hotkey if you rely on it.

## Uninstall (one line)

```powershell
irm https://raw.githubusercontent.com/j7-dev/clip2path/main/uninstall.ps1 | iex
```

Removes the startup shortcut, installed files, and stops the listener. AutoHotkey itself is kept (remove with `winget uninstall AutoHotkey.AutoHotkey` if you no longer need it).

## License

[MIT](LICENSE)
