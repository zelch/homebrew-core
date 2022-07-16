class SpdxSbomGenerator < Formula
  desc "Support CI generation of SBOMs via golang tooling"
  homepage "https://github.com/opensbom-generator/spdx-sbom-generator"
  url "https://github.com/opensbom-generator/spdx-sbom-generator/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "3811d652de0f27d3bfa7c025aa6815805ef347a35b46f9e2a5093cc6b26f7b08"
  license any_of: ["Apache-2.0", "CC-BY-4.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d33ca829ee21a0368595ccfd056fd71b42adf885c56e9817873d59f5fa654e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bcc70b1ee753b8dbfb6dfb570c252f9505cbc65dac76969226181d96d86e44ae"
    sha256 cellar: :any_skip_relocation, monterey:       "6e61f76ae9777f7a240ae8334b3aeff2ec2d2938fe0cf3731b1ef3bff93db3ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "681616b30e0ef85abdb4a0d67e192960aba39734e370eaf0a7be21ecc47258f0"
    sha256 cellar: :any_skip_relocation, catalina:       "8754edaf0d7acbefec80d9acfca5ef99261a040eeda5dd2af043b1d59a9c4228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "001de0fb0d5df3c4da25c403dd93e9826e1b4dcec4cb9aaf52892c1686dbe167"
  end

  depends_on "go" => [:build, :test]

  def install
    target = if Hardware::CPU.arm?
      "build-mac-arm64"
    elsif OS.mac?
      "build-mac"
    else
      "build"
    end

    system "make", target

    prefix.install "bin"
  end

  test do
    system "go", "mod", "init", "example.com/tester"

    assert_equal "panic: runtime error: index out of range [0] with length 0",
                 shell_output("#{bin}/spdx-sbom-generator 2>&1", 2).split("\n")[4]
  end
end
