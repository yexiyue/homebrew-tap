class Talechime < Formula
  desc "Local speech synthesis, continuous listening and JSON Lines worker"
  homepage "https://github.com/yexiyue/talechime"
  version "0.6.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/yexiyue/talechime/releases/download/talechime-v0.6.1/talechime-aarch64-apple-darwin.tar.xz"
    sha256 "79b4da928128d04a3fb1af9b83c95181c8f9b44ee011d0dae1d9a7a0c7851746"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/yexiyue/talechime/releases/download/talechime-v0.6.1/talechime-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "21959bdfd053806a3d88f6caf00ce8f5508d0f424abd019b08b54bda2204ad70"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "talechime"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "talechime"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
