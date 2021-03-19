class Bnnvara < Formula
  desc "BNNVARA Cli Tool"
  homepage "https://bitbucket.org/mdvbnn/homebrew-bnnvara-cli"
  version "0.1"

  sha256 "c9e5bf62bce5503aaf4fc253211f8dbfaa4b74ff04b3ffc3d75b790bb15ea1e6"
  url "https://github.com/mdvbnn/homebrew-bnnvara-cli/blob/master/cli.zip", :using => :curl

  depends_on "wget" => [:build]
  depends_on 'squashfs' => [:build]

  bottle do
    root_url "https://bnnvara-bottle.m-dv.nl"
    sha256 "15ad346dbf6cdfa362edf9953370b21a8631d26cc43fa2792de184672076d564" => :catalina
  end

  def install
    system 'wget https://github.com/pmq20/ruby-packer/releases/download/darwin-x64/rubyc'
    system 'chmod +x rubyc'
    system './rubyc -o ./bnnvara bin/bnnvara'
    bin.install "bnnvara"
  end
end
