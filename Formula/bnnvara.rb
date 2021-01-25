class Bnnvara < Formula
  desc "BNNVARA Cli Tool"
  homepage "https://bitbucket.org/mdvbnn/homebrew-bnnvara-cli"
  version "0.1"

  url "https://github.com/mdvbnn/homebrew-bnnvara-cli/archive/master.zip", :using => :curl

  depends_on "wget"

  def install
    system 'wget', 'https://github.com/pmq20/ruby-packer/releases/download/darwin-x64/rubyc'
    system './rubyc -o ./bnnvara bin/bnnvara'
    bin.install "bnnvara"

    # bin.install "bin/bnnvara"
  end
end
