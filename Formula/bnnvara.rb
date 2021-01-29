class Bnnvara < Formula
  desc "BNNVARA Cli Tool"
  homepage "https://bitbucket.org/mdvbnn/homebrew-bnnvara-cli"
  version "0.1"

  url "https://github.com/mdvbnn/homebrew-bnnvara-cli/archive/master.zip", :using => :curl

  depends_on "wget"
  depends_on 'squashfs'

  bottle do
    root_url "https://bnnvara-bottle.m-dv.nl"
    sha256 "85594c69ccbe1956f89d0d5cf2700ad0fd40d52f7b62e21870ecc43e6ac67893" => :catalina
  end

  def install
    system 'wget https://github.com/pmq20/ruby-packer/releases/download/darwin-x64/rubyc'
    system 'chmod +x rubyc'
    system './rubyc -o ./bnnvara bin/bnnvara'
    bin.install "bnnvara"

    # bin.install "bin/bnnvara"
  end
end
