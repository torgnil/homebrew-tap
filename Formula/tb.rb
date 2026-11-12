class Tb < Formula
  desc "Self-hosted LLVM-based programming language"
  homepage "https://github.com/torgnil/tb"
  url "https://github.com/torgnil/tb/releases/download/v0.3.0/tb-0.3.0-macos-arm64.zip"
  sha256 "953b9c3e3b0102c981dcd7ca79ec42333dc255b2c94f6f010d67473999c57522"
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
