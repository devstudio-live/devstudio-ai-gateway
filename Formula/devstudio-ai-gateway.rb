class DevstudioAiGateway < Formula
  desc "DevStudio AI gateway — successor to devstudio-proxy"
  homepage "https://github.com/devstudio-live/devstudio-ai-gateway"
  version "0.3.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/devstudio-live/devstudio-ai-gateway/releases/download/v#{version}/devstudio-ai-gateway-darwin-arm64"
      sha256 "4b2de5dbe4e3b43516f7f17ce32a115cd60e38af843a4c076a5ebe168000f72c"
    end
    on_intel do
      url "https://github.com/devstudio-live/devstudio-ai-gateway/releases/download/v#{version}/devstudio-ai-gateway-darwin-amd64"
      sha256 "76079f9cb8b8f5763a711de8b68131b775a656eb94c250fab710d5cd06f1d120"
    end
  end

  on_linux do
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/devstudio-live/devstudio-ai-gateway/releases/download/v#{version}/devstudio-ai-gateway-linux-arm64"
        sha256 "a13d008f690678a8761a893a2b9589305fda6a6d8c6f3a5e3aebf5101432389d"
      end
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/devstudio-live/devstudio-ai-gateway/releases/download/v#{version}/devstudio-ai-gateway-linux-amd64"
        sha256 "ce1fadb0fc37a576c43f43017e3ec4fc62d061b78949be56ccef603023b4c8a7"
      end
    end
  end

  def install
    bin.install Dir["devstudio-ai-gateway-*"].first => "devstudio-ai-gateway"
  end

  def post_install
    # The bare-bones binary does not yet read a config file. The stub below
    # establishes the location that future releases will consume so users who
    # edit it across upgrades won't be surprised when knobs land. Mirrors the
    # `unless conf_file.exist?` guard the devstudio-proxy formula uses.
    conf_file = etc/"devstudio-ai-gateway.conf"
    unless conf_file.exist?
      conf_file.write <<~EOS
        # devstudio-ai-gateway configuration
        # No tunables yet — bare-bones scaffolding. Future releases will
        # consume options from this file.

        # Port to listen on (default: 7700)
        PORT=7700
      EOS
    end
  end

  service do
    run [opt_bin/"devstudio-ai-gateway"]
    keep_alive true
    log_path       var/"log/devstudio-ai-gateway.log"
    error_log_path var/"log/devstudio-ai-gateway.log"
  end

  test do
    pid = fork { exec bin/"devstudio-ai-gateway" }
    sleep 1
    assert_match "ok", shell_output("curl -s http://localhost:7700/health")
  ensure
    Process.kill("TERM", pid)
  end
end
