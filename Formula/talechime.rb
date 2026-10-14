class Talechime < Formula
  desc "Local speech synthesis, continuous listening and JSON Lines worker"
  homepage "https://github.com/yexiyue/talechime"
  version "0.4.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/yexiyue/talechime/releases/download/talechime-v0.4.1/talechime-aarch64-apple-darwin.tar.xz"
    sha256 "fbfea723d01ee041e874d0f00141acda684db33f5c8a56ad185da500a6b257e8"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/yexiyue/talechime/releases/download/talechime-v0.4.1/talechime-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "87a120b265ec1d3024826c5d6da1c1485c806a8dca4e3a9cfcf6e2c829ecc8a4"
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
