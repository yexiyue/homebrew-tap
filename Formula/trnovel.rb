class Trnovel < Formula
  desc "Terminal reader for novel"
  homepage "https://yexiyue.github.io/TRNovel"
  version "0.18.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.18.1/trnovel-aarch64-apple-darwin.tar.xz"
    sha256 "e3a9a849e1c41102604f0f583ae02453f01a3dd40f9015ccdaf31672b89f2223"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.18.1/trnovel-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "fb774b1ae7a88859ad91578ccd82c7776b7d769b8a317c4f3c36836cc6c2dc8e"
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
