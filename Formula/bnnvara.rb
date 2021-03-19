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
    sha256 "1d551151c7a993814c04e70dd4862eaa0d0cbc3287f010ecb0bffb05a26c5a5d" => :big_sur
    sha256 "40c711e11da2d5b829435e87de5339d6f5f23a50a50ce712d5a232d36ac5fd57" => :catalina
  end

  def install
    system 'wget https://github.com/pmq20/ruby-packer/releases/download/darwin-x64/rubyc'
    system 'chmod +x rubyc'
    system './rubyc -o ./bnnvara bin/bnnvara'
    bin.install "bnnvara"
  end
end
