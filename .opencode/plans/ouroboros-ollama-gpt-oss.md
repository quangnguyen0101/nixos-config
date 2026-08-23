# Kế hoạch: dsh-ouroboros + Ollama cloud gpt-oss

## Mục tiêu
Gắn lại bundle `dsh-ouroboros` dùng LLM backend `litellm` trỏ tới Ollama local
(model cloud `gpt-oss:120b-cloud` đã có sẵn trên máy, miễn phí qua ollama.com).
Không cần API key nào.

## Bối cảnh máy
- GPU MX150 2GB + RAM 16GB → không chạy được model local cỡ gpt-oss:20b (~13GB)
- Ollama v0.30.7 đang chạy (user service), API localhost:11434
- Model sẵn có: `gpt-oss:120b-cloud` (0 GB local, chạy trên ollama.com, cần signin)
- litellm adapter của ouroboros gọi `ollama/<model>` qua localhost:11434,
  api_key=None được chấp nhận; config đọc từ ~/.ouroboros/config.yaml (HOME
  tự đi qua scrub env của dsh → không cần override cordis.patch.yml)

## Các bước thực thi (Nix)

1. `modules/home/dsh-profile/package.json`
   - dependencies: thêm `"dsh-ouroboros": "github:Q00/ouroboros#62d87a599770c38e89656f53fe4049373f6be4fe&path:integrations/dsh-plugin"`
   - bundles: thêm `"dsh-ouroboros"` (sau `"dsh-kimino-theme"`)

2. `modules/home/dsh-plugins.nix`
   - Thêm lại:
     ```nix
     # Runtime cho bundle dsh-ouroboros (MCP server chạy qua uvx).
     home.packages = with pkgs; [ uv python312 ];
     ```

3. Regen lockfile:
   ```
   cd modules/home/dsh-profile && nix shell nixpkgs#pnpm -c pnpm install --lockfile-only
   ```
   (20 mục minimumReleaseAgeExclude trong pnpm-workspace.yaml giữ nguyên)

4. Eval check:
   ```
   nix eval .#nixosConfigurations.nixos-btw.config.system.build.toplevel.drvPath
   ```

## Post-rebuild (thủ công, một lần)

1. Đăng nhập ollama.com để dùng model `-cloud`:
   ```
   ollama signin
   ```
2. Ghi `~/.ouroboros/config.yaml` (tôi sẽ cung cấp nội dung đầy đủ khi đến bước này):
   ```yaml
   llm:
     backend: litellm
     qa_model: ollama/gpt-oss:120b-cloud
     dependency_analysis_model: ollama/gpt-oss:120b-cloud
     ontology_analysis_model: ollama/gpt-oss:120b-cloud
     context_compression_model: ollama/gpt-oss:120b-cloud
   clarification:
     default_model: ollama/gpt-oss:120b-cloud
   execution:
     default_model: ollama/gpt-oss:120b-cloud
   evaluation:
     semantic_model: ollama/gpt-oss:120b-cloud
   consensus:
     models: [ollama/gpt-oss:120b-cloud]
     advocate_model: ollama/gpt-oss:120b-cloud
     devil_model: ollama/gpt-oss:120b-cloud
     judge_model: ollama/gpt-oss:120b-cloud
   llm_profiles:
     fast:      { providers: { litellm: { model: ollama/gpt-oss:120b-cloud } } }
     standard:  { providers: { litellm: { model: ollama/gpt-oss:120b-cloud } } }
     deep:      { providers: { litellm: { model: ollama/gpt-oss:120b-cloud } } }
     frontier:  { providers: { litellm: { model: ollama/gpt-oss:120b-cloud } } }
   ```
3. Restart `dsh web`, thử trong chat: `ooo interview: thử nghiệm`

## Lưu ý / giới hạn
- `ooo auto` (bước execute code) cần runtime CLI executable (codex/claude-cli/
  opencode…) — máy chưa có. Interview/Seed/QA chạy bình thường.
- Model `-cloud` = prompt gửi lên server ollama.com; chịu rate-limit free tier.
- Nếu ouroboros bắt buộc api_key khác rỗng với provider lạ: đặt placeholder
  trong `~/.ouroboros/credentials.yaml` (`providers.ollama.api_key: "ollama"`).
