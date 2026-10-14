class Trnovel < Formula
  desc "Terminal reader for novel"
  homepage "https://yexiyue.github.io/TRNovel"
  version "0.18.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.18.2/trnovel-aarch64-apple-darwin.tar.xz"
      sha256 "2db97398613d1328b508611dffd5623c1121bed122f1a8df4ae63b010bd49d3a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.18.2/trnovel-x86_64-apple-darwin.tar.xz"
      sha256 "ee9f6043ee728c5f0b5f340f24312b4d32c7c0c2660df75126449e4101a1ceca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.18.2/trnovel-aarch64-unknown-linux-musl.tar.xz"
      sha256 "a15570037715fd4dd3d7377ea5d90bb43213cdc36dc24bc8dd35236295c29824"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.18.2/trnovel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "56ec0f961457e13e1d1c5cc61767d07e3e88e6e374ccac9b31f30e7346e6f6a3"
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
