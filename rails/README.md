# README

server
```
make build run
```

client
```
rdbg -A --port 12345
b app/controllers/sample_controller.rb 3


nvim app/controllers/sample_controller.rb
# :lua require'dap'.toggle_breakpoint()
# :lua require'dap'.continue()
```

```
curl http://localhost:3000/sample
```
