class Trnovel < Formula
  desc "Terminal reader for novel"
  homepage "https://yexiyue.github.io/TRNovel"
  version "0.17.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.17.0/trnovel-aarch64-apple-darwin.tar.xz"
      sha256 "03fe9f0d706c6bb00bd970e8238fc6d543938eb68c7425c632170ec77222648e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.17.0/trnovel-x86_64-apple-darwin.tar.xz"
      sha256 "61de65146f22d0d7a79306a9630e7b6740c5aaabdce0b361d43e1476fc07a1f2"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/yexiyue/TRNovel/releases/download/trnovel-v0.17.0/trnovel-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "604b98ebeb7461f0083a0901397218c0418a97be71a19772bfab81e97369389a"
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
