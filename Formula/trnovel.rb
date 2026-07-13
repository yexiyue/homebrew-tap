class Trnovel < Formula
  desc "Terminal reader for novel"
  homepage "https://yexiyue.github.io/TRNovel"
  version "0.14.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.14.1/trnovel-aarch64-apple-darwin.tar.xz"
      sha256 "49f2c4eeb63f29eb7330c2b0cf70145971457e1e7983d770010d153e6b9d0628"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.14.1/trnovel-x86_64-apple-darwin.tar.xz"
      sha256 "1f18eb7d4c3e90031191a03a4164872c517dd0ba85abce7871877b9f66995570"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.14.1/trnovel-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ff247154275b779d0ddfdaa76aeff45bd081cac9de7ce7045dcdc7f1b70b09e8"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
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
    bin.install "trn", "trnovel" if OS.mac? && Hardware::CPU.arm?
    bin.install "trn", "trnovel" if OS.mac? && Hardware::CPU.intel?
    bin.install "trn", "trnovel" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
