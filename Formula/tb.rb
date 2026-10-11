class Tb < Formula
  desc "Self-hosted LLVM-based programming language"
  homepage "https://github.com/torgnil/tb"
  url "https://github.com/torgnil/tb/releases/download/v0.2.0/tb-0.2.0-macos-arm64.zip"
  sha256 "ba54c4c4f03ca4c08ed2a648532a98b13f911d6810f550df8274c6793190cd6b"
  license "Apache-2.0"

  depends_on :macos
  depends_on arch: :arm64

  def install
    # Keep the original distribution layout intact.
    libexec.install Dir["*"]

    # Make both commands available on PATH.
    bin.write_exec_script libexec/"tb"
    bin.write_exec_script libexec/"tb-build"
  end

  test do
    system bin/"tb", "--version"
  end
end
