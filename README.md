# devstudio-ai-gateway

Homebrew tap and release assets for `devstudio-ai-gateway` — a Rust-based
AI gateway, eventual successor to
[`devstudio-proxy`](https://github.com/devstudio-live/devstudio-proxy).

The Rust source is private and lives at
[`devstudio-live/devstudio-ai-gateway-internal`](https://github.com/devstudio-live/devstudio-ai-gateway-internal).
Only the Homebrew formula and signed release binaries are kept here.

## Install via Homebrew

```sh
brew install devstudio-live/devstudio-ai-gateway/devstudio-ai-gateway
```

Or, equivalently:

```sh
brew tap devstudio-live/devstudio-ai-gateway
brew install devstudio-ai-gateway
```

### Upgrade to the latest version

```sh
brew update
brew upgrade devstudio-ai-gateway
```

If the upgrade does not pick up the latest tag (e.g. the formula is cached), force-reinstall:

```sh
brew reinstall devstudio-ai-gateway
```

To force Homebrew to re-fetch the tap and pull the latest formula:

```sh
brew update --force
brew upgrade devstudio-ai-gateway
```

### Uninstall and reinstall to get the latest

If you're having trouble getting the latest version, uninstall completely and reinstall:

```sh
brew uninstall devstudio-ai-gateway
brew untap devstudio-live/devstudio-ai-gateway
brew tap devstudio-live/devstudio-ai-gateway
brew install devstudio-ai-gateway
```

## Usage

```sh
devstudio-ai-gateway                          # listens on 127.0.0.1:7700
devstudio-ai-gateway --port 8080              # custom port
devstudio-ai-gateway --listen 0.0.0.0:7700    # bind a non-loopback address
devstudio-ai-gateway --no-tls                 # disable the TLS byte-sniffing path
devstudio-ai-gateway --version                # print version
devstudio-ai-gateway --help                   # print usage
```

By default the listener byte-sniffs the first byte of every connection
(`0x16` → TLS handshake) and presents an `rcgen`-generated localhost
certificate. Pass `--no-tls` to serve plain HTTP only.

### Quick check

```sh
devstudio-ai-gateway --version
devstudio-ai-gateway &
curl -s http://localhost:7700/health   # → "ok"
kill %1
```

## Configuration file

When installed via Homebrew, settings can be persisted in the config
file so they survive service restarts. Edit the file for your platform:

- **Apple Silicon:** `/opt/homebrew/etc/devstudio-ai-gateway.conf`
- **Intel Mac:** `/usr/local/etc/devstudio-ai-gateway.conf`
- **Linuxbrew:** `/home/linuxbrew/.linuxbrew/etc/devstudio-ai-gateway.conf`

```
# Port to listen on (default: 7700).
PORT=7700

# Full bind address. Wins over PORT when set. Use 0.0.0.0:7700 to
# accept non-loopback connections.
# LISTEN=127.0.0.1:7700

# Disable the TLS byte-sniffing path (serve plain HTTP only).
NO_TLS=false

# Forward-proxy request logging.
LOG=false

# Log request headers (useful for debugging gateway routing).
VERBOSE=false

# Fall back to a static MCP runtime if the upstream MCP refresh fails.
MCP_FALLBACK=false

# MCP runtime refresh interval (e.g. 30s, 5m, 1h).
MCP_REFRESH=30m
```

After editing, restart the service to apply changes:

```sh
brew services restart devstudio-ai-gateway
```

Settings can also be set via environment variables (`DEVGATEWAY_PORT`,
`DEVGATEWAY_LISTEN`, `DEVGATEWAY_NO_TLS`, `DEVGATEWAY_LOG`,
`DEVGATEWAY_VERBOSE`, `DEVGATEWAY_MCP_FALLBACK`,
`DEVGATEWAY_MCP_REFRESH`). Priority order: config file < env vars < CLI
flags.

## Run as a background service (auto-starts on login)

```sh
brew services start devstudio-ai-gateway     # start + enable on login
brew services stop devstudio-ai-gateway      # stop + disable
brew services restart devstudio-ai-gateway   # apply config changes
brew services list                           # status
```

Service stdout/stderr is written to:

- **Apple Silicon:** `/opt/homebrew/var/log/devstudio-ai-gateway.log`
- **Intel Mac:** `/usr/local/var/log/devstudio-ai-gateway.log`

## Health check

Once running, the gateway exposes a liveness endpoint:

```sh
curl -s http://localhost:7700/health   # → "ok"
```

## Manual download

GitHub Releases at
<https://github.com/devstudio-live/devstudio-ai-gateway/releases> ship six
binaries per tag — macOS arm64/amd64, Linux arm64/amd64, Windows
amd64/arm64 — plus `checksums.txt`. Homebrew uses the four non-Windows
builds; Windows users download the `.exe` directly from the Releases page.

Verify the checksum after download:

```sh
shasum -a 256 -c checksums.txt
```

Then make the binary executable and move it onto your `PATH`:

```sh
chmod +x devstudio-ai-gateway-darwin-arm64
mv devstudio-ai-gateway-darwin-arm64 ~/.local/bin/devstudio-ai-gateway
```

## License

[MIT](LICENSE).
