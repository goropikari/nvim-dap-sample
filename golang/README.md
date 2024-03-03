devcontainer で立ち上げる

```bash
# terminal 1
make build run
```

```bash
# terminal 2
nvim main.go

:DapToggleBreakpoint " 適当なところに breakpoint を置く
:DapContinue " 7: Attach Remote Dap server を選ぶ

" vscode のターミナルだと多分アイコンが文字化けする
:lua require("dapui").open()
```

```bash
# terminal 3
curl http://localhost:8080
```
