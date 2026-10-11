class Tb < Formula
  desc "Self-hosted LLVM-based programming language"
  homepage "https://github.com/torgnil/tb"
  url "https://github.com/torgnil/tb/releases/download/v0.2.1/tb-0.2.1-macos-arm64.zip"
  sha256 "42f2d1d66315ff344db7e132c1cda693b22dcdefb0d282e2a6283988d4c7bfe7"
  license "Apache-2.0"

  depends_on :macos
  depends_on arch: :arm64

  def install
    # Keep the original distribution layout intact.
    libexec.install Dir["*"]

    # Make both commands available on PATH.
    bin.write_exec_script libexec/"tb"
    bin.write_exec_script libexec/"tb-ir"
  end

  test do
    assert_equal "tb #{version}\n", shell_output("#{bin}/tb --version")
    assert_equal "tb #{version}\n", shell_output("#{bin}/tb-ir --version")

    (testpath/"hello.tb").write <<~EOS
      int main(string[] args) {
          print('hello world');
          return 0;
      }
    EOS

    system bin/"tb", "hello.tb", "-o", "hello"
    assert_equal "hello world\n", shell_output("./hello")

    system bin/"tb-ir", "hello.tb", "hello.ll"
    system ENV.cc, "hello.ll", "-o", "hello-ir"
    assert_equal "hello world\n", shell_output("./hello-ir")
  end
end
