# clip2path

[English](README.md) | [繁體中文](README.zh-TW.md)

> 按下 `Ctrl + Alt + V` → 剪貼簿圖片自動存成 PNG，並**在游標處瞬間（約 0.2 秒）輸出檔案路徑**。剪貼簿完全不受影響——圖片照樣可以正常貼上。

最適合搭配只吃圖片**路徑**、不吃直接貼圖的 CLI 工具與 AI coding agent（Claude Code、Codex、Gemini CLI⋯⋯）：截圖後在終端機按一下熱鍵，路徑直接出現在你需要的地方。

## 運作原理

```
┌──────────────┐   Ctrl+Alt+V   ┌─────────────────────────┐
│   剪貼簿中    │ ─────────────▶ │ %TEMP%\clipboard_*.png  │
│   的截圖      │                └─────────────────────────┘
└──────────────┘                             │
       │                                     ▼
       │  剪貼簿不動，          路徑直接出現在游標處：
       └─ 圖片照樣可貼上        C:\Users\you\AppData\Local\Temp\clipboard_20260611_081721.png
```

- **AutoHotkey v2** 註冊全域熱鍵，以 Unicode 直接輸入的方式輸出路徑——完全不經過剪貼簿、不被輸入法攔截，console、傳統文字框、Electron 程式全都穩定
- **PowerShell** 讀取剪貼簿圖片並存成 PNG
- **啟動資料夾**的捷徑讓它重開機後依然生效

## 系統需求

- Windows 10 / 11
- [AutoHotkey v2](https://www.autohotkey.com/) —— 沒裝的話會自動透過 `winget` 安裝

## 安裝（一行指令）

開啟 PowerShell 執行：

```powershell
irm https://raw.githubusercontent.com/j7-dev/clip2path/main/install.ps1 | iex
```

裝完立即生效，重開機也會自動啟動。

<details>
<summary>安裝腳本做了什麼</summary>

1. 若未安裝 AutoHotkey v2，透過 `winget` 自動安裝
2. 複製 `clip2path.ahk` + `save-clipboard-image.ps1` 到 `%LOCALAPPDATA%\clip2path`
3. 在啟動資料夾建立捷徑（開機自動啟動）
4. 立即啟動熱鍵監聽

不需要管理員權限，所有檔案都只寫在你的使用者目錄內。

</details>

## 使用方式

1. 複製任意圖片到剪貼簿（例如 `Win + Shift + S` 截圖，或右鍵 → 複製圖片）
2. 將游標放在任何文字輸入處（終端機、編輯器、聊天框⋯⋯）
3. 按下 `Ctrl + Alt + V`
4. PNG 路徑直接出現在游標處，右下角跳出通知確認儲存成功

剪貼簿裡沒有圖片時只會跳通知提醒，不會輸出任何文字。

## 自訂設定

編輯 `%LOCALAPPDATA%\clip2path\clip2path.ahk`，存檔後雙擊重新載入：

| 項目 | 改法 |
|---|---|
| 熱鍵 | 修改 `^!v::`（例如 `^!+v::` = Ctrl+Alt+Shift+V） |
| 儲存資料夾 | 把 `A_Temp` 換成任意資料夾路徑 |

> **注意：** `Ctrl + Alt + V` 會覆蓋 Microsoft Office 的「選擇性貼上」快捷鍵，常用該功能的話請改熱鍵。

## 移除（一行指令）

```powershell
irm https://raw.githubusercontent.com/j7-dev/clip2path/main/uninstall.ps1 | iex
```

會移除啟動捷徑、安裝檔案並停止監聽。AutoHotkey 本體會保留（不再需要的話可用 `winget uninstall AutoHotkey.AutoHotkey` 移除）。

## 授權

[MIT](LICENSE)
