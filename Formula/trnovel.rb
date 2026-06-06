class Trnovel < Formula
  desc "Terminal reader for novel"
  homepage "https://yexiyue.github.io/TRNovel"
  version "0.10.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.10.4/trnovel-aarch64-apple-darwin.tar.xz"
      sha256 "09c62e11c8e7fd6953a14a150d6d278ca5cdf9afe9803f402141d04e2e0e6ac8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.10.4/trnovel-x86_64-apple-darwin.tar.xz"
      sha256 "4127d7c115c041053ff734bacafd8ffdeebac7c0ffb65e992a035448db4a915c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.10.4/trnovel-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9424ed399370759f80d327fdf1312bd18d9c580c6cbfc60d256f4d38efbb9a61"
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
