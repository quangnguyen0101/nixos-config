---
tags: [nixos, docs, moc]
---

# Tools — Map of Content

> [!info] Obsidian
> Vault này chính là repo `~/nixos-config` — mở nó trong **Obsidian** để dùng wikilink `[[...]]`, graph view và backlinks. GitHub vẫn render được phần lớn (chỉ wikilink hiện dạng text thường).

## 🧠 AI stack (8 MCP servers)

| MCP | Note | Nền tảng |
|-----|------|----------|
| [[arxiv]] | Tìm/đọc paper + xuất BibTeX | `uvx arxiv-mcp-server[pdf]` |
| [[context7]] | Tra docs/code thư viện | remote MCP Context7 |
| [[docker]] | Docker/compose + DB containers | `npx @hypnosis/docker-mcp-server` |
| [[github]] | Repos/issues/PRs/code search | remote, PAT `~/.config/opencode/github.token` |
| [[jupyter]] | Notebook + kernel data science | JupyterLab `127.0.0.1:8888` |
| [[openviking]] | Context database long-term memory | server `127.0.0.1:1933` |
| [[ouroboros]] | Agent OS — interview→seed→execute | `uvx ouroboros-ai[mcp]` |
| [[postgres]] | SQL data science | container `postgres-ds` `127.0.0.1:5432` |

## 🛠️ Tool nhỏ gắn system

| Tool | Note | Lệnh dùng |
|------|------|-----------|
| [[autoskills]] | Gắn skill AI vào project | `autoskills` (trong project) |
| [[keep-awake]] | Giữ máy awake khi đóng lid | `keep-awake` |
| [[brt]] | Độ sáng màn hình | `brt` |
| [[rmpc]] | Nghe nhạc (MPD client) | `rmpc` |

## Tổng quan

- [[USAGE]] — cheatsheet hằng ngày
- [[INVENTORY]] — trạng thái bật/tắt từng module