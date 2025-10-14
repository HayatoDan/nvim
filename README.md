# my nvim
`NVIM v0.10.4`で動作確認


# For windows
Windowsでは`%USERPROFILE%\AppData\Local`に`nvim`ディレクトリを作って，そこに配置する．


# For vscode
VSCode-Neovimを使用する場合，
Ctrl+d, Ctrl+uの動作がおかしいので
keybindings.jsonに以下を記述する．
```
{
    "key": "ctrl+d",
    "command": "vscode-neovim.send",
    "args": "<C-d>",
    "when": "editorTextFocus && neovim.init"
},
{
    "key": "ctrl+u",
    "command": "vscode-neovim.send",
    "args": "<C-u>",
    "when": "editorTextFocus && neovim.init"
}

```