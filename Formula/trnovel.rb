class Trnovel < Formula
  desc "Terminal reader for novel"
  homepage "https://yexiyue.github.io/TRNovel"
  version "0.10.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.10.3/trnovel-aarch64-apple-darwin.tar.xz"
      sha256 "752c88dd897c254db55c1f33ce64f41f1f99a6b182fb1400ed1cfb3b8cdbf7b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.10.3/trnovel-x86_64-apple-darwin.tar.xz"
      sha256 "ee2fc7ef2170298199fc5c44baa62d053abb454df888b131ab3c15f4c8c72991"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.10.3/trnovel-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "568ca15cee0583ef8647eb7d2f29cbda41e3319339b3e1a9c6e454edb661f8a6"
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
