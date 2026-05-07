class DevstudioAiGateway < Formula
  desc "DevStudio AI gateway — successor to devstudio-proxy"
  homepage "https://github.com/devstudio-live/devstudio-ai-gateway"
  version "0.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/devstudio-live/devstudio-ai-gateway/releases/download/v#{version}/devstudio-ai-gateway-darwin-arm64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/devstudio-live/devstudio-ai-gateway/releases/download/v#{version}/devstudio-ai-gateway-darwin-amd64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/devstudio-live/devstudio-ai-gateway/releases/download/v#{version}/devstudio-ai-gateway-linux-arm64"
        sha256 "0000000000000000000000000000000000000000000000000000000000000000"
      end
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/devstudio-live/devstudio-ai-gateway/releases/download/v#{version}/devstudio-ai-gateway-linux-amd64"
        sha256 "0000000000000000000000000000000000000000000000000000000000000000"
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
