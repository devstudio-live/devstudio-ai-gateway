# devstudio-ai-gateway

Homebrew tap and release assets for `devstudio-ai-gateway` — a Rust-based
AI gateway, eventual successor to
[`devstudio-proxy`](https://github.com/devstudio-live/devstudio-proxy).

The Rust source is private and lives at
[`devstudio-live/devstudio-ai-gateway-internal`](https://github.com/devstudio-live/devstudio-ai-gateway-internal).
Only the Homebrew formula and signed release binaries are kept here.

## Install

```
brew install devstudio-live/devstudio-ai-gateway/devstudio-ai-gateway
```

Or, equivalently:

```
brew tap devstudio-live/devstudio-ai-gateway
brew install devstudio-ai-gateway
```

## Quick check

```
devstudio-ai-gateway --version
devstudio-ai-gateway &
curl -s http://localhost:7700/health   # → "ok"
kill %1
```

## Manual download

GitHub Releases at
<https://github.com/devstudio-live/devstudio-ai-gateway/releases> ship six
binaries per tag — macOS arm64/amd64, Linux arm64/amd64, Windows
amd64/arm64 — plus `checksums.txt`. Homebrew uses the four non-Windows
builds; Windows users download the `.exe` directly from the Releases page.

## License

[MIT](LICENSE).
