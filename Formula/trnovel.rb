class Trnovel < Formula
  desc "Terminal reader for novel"
  homepage "https://yexiyue.github.io/TRNovel"
  version "0.18.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.18.3/trnovel-aarch64-apple-darwin.tar.xz"
      sha256 "4cdf71453616536a248808270f99adb22412cca319dfa92079569414fe7a88b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.18.3/trnovel-x86_64-apple-darwin.tar.xz"
      sha256 "7c5a54400b6f2b6b04d5f51df105388b2c464f79bce8f7d9814a6416e8a69866"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.18.3/trnovel-aarch64-unknown-linux-musl.tar.xz"
      sha256 "8f3650bf78e89ca2ba1c1d1d01ff6002dfd541cd931c7b295c1b6dbcf48f6b9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.18.3/trnovel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9512bf518bd493cc8ec421cf405ae7f860339497fd41a5c3274174da3c65d188"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
      bin.install "trn", "trnovel"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "trn", "trnovel"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "trn", "trnovel"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "trn", "trnovel"
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
