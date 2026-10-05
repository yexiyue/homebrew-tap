class Trnovel < Formula
  desc "Terminal reader for novel"
  homepage "https://yexiyue.github.io/TRNovel"
  version "0.17.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.17.2/trnovel-aarch64-apple-darwin.tar.xz"
      sha256 "cfa2b1e19f80028c5174aff2551d319ae9a5ede7f4ae43cf76802c65eb1480af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.17.2/trnovel-x86_64-apple-darwin.tar.xz"
      sha256 "7c79b25cc0e01719d1c25a87526dd12b14e1c0e8c513e234890519009ef3f90b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.17.2/trnovel-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "a528ef0a30144d2fe7213c2b5909ef9ca4065f2693ab649e47724a973dd8a488"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "trn", "trnovel"
    end
    if OS.mac? && Hardware::CPU.intel?
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
