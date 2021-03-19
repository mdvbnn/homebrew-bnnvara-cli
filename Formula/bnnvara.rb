class Bnnvara < Formula
  desc "BNNVARA Cli Tool"
  homepage "https://github.com/mdvbnn/homebrew-bnnvara-cli"
  version "0.1"

  sha256 "b4e7f2fd577487cb179f368558a91e819923a18da7c0967373a7b53510cdef38"
  url "https://bnnvara-bottle.m-dv.nl/cli.zip", :using => :curl

  depends_on "wget" => [:build]
  depends_on 'squashfs' => [:build]

  bottle do
    root_url "https://bnnvara-bottle.m-dv.nl"
    sha256 "01011d0aee92562028a744ce2ded9c32a009096a24b38a7e75f726c76add761e" => :big_sur
    sha256 "76c8ade7bee9a2cec6129b73e1503670e5823204d1d360f862c3a4cb272f326d" => :catalina
  end

  def install
    system 'wget https://github.com/pmq20/ruby-packer/releases/download/darwin-x64/rubyc'
    system 'chmod +x rubyc'
    system './rubyc -o ./bnnvara bin/bnnvara'
    bin.install "bnnvara"
  end
end
