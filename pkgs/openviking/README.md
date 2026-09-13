# openviking

Package NixOS tùy chỉnh cho [OpenViking](https://openviking.dev) — context database server với long-term memory cho AI agents.

## Cài đặt

```nix
# system-packages.nix
pkgs.openviking
```

## Cấu trúc

```
pkgs/openviking/
├── default.nix       # Overlay: inject custom deps vào python3Packages
├── package.nix       # buildPythonPackage (wheel, manylinux)
└── deps/
    ├── openviking-sdk.nix
    ├── volcengine.nix
    ├── volcengine-python-sdk.nix
    ├── tree-sitter-language-pack.nix
    └── opentelemetry-instrumentation-asyncio.nix
```

## Kỹ thuật

- **Format**: wheel (`cp310-abi3-manylinux_2_31_x86_64`)
- **autoPatchelfHook**: patchelf libc/libstdc++ automatically trên NixOS
- **pythonRemoveDeps**: bỏ 10 tree-sitter-language-* deps (không cần, dùng `tree-sitter-language-pack` bundled)
- **pythonRelaxDeps**: mở version lock cho `urllib3`, `cryptography`, `pathspec`, `opentelemetry-instrumentation-asyncio` để tương thích versions trong nixpkgs

## Sử dụng

Server chạy dưới systemd user service:

```bash
# Khởi động server
systemctl --user enable --now openviking-server

# CLI test
openviking-cli health
```

MCP endpoint: `http://127.0.0.1:1933/mcp` — được cấu hình trong `modules/home/opencode.nix`.
