class Trnovel < Formula
  desc "Terminal reader for novel"
  homepage "https://yexiyue.github.io/TRNovel"
  version "0.14.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.14.3/trnovel-aarch64-apple-darwin.tar.xz"
      sha256 "582bfce7ee61e78fc7bc233b61278dda29d9ad76bc59c87122f875fc74a84ae7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.14.3/trnovel-x86_64-apple-darwin.tar.xz"
      sha256 "8a6e9f255a4d478cfa62cefe0c39af0b7dbd255150b6b5414b270f795038e69e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.14.3/trnovel-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3c43c38b4b5cf324173d9e1f92e68214aa8eae4e5a787fe60af49b9f7a1c3f10"
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
