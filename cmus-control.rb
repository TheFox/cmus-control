
class CmusControl < Formula
  desc "Control cmus with Media Keys << > >> under OS X"
  # homepage "https://github.com/TheFox/cmus-control"
  homepage "https://blog.fox21.at/2015/11/20/control-cmus-with-media-keys.html"
  # url "https://github.com/TheFox/cmus-control/archive/v1.0.0.tar.gz"
  url "https://dev.fox21.at/cmus_control/releases/cmus-control-v1.0.0.tar.gz"
  sha256 "c7d620b17876366cfd2c9dcb889b0a084588b9ad504c68d28fd047880614b05f"

  depends_on "cmake" => :build

  def install
    system "env", "TARGET=#{MacOS.version}"
    system "make", "tmp/at.fox21.cmuscontrold.plist"
    system "make", "build/release/target_#{MacOS.version}"
    bin.install "build/release/target_#{MacOS.version}"
  end

  test do
    system "which", "-a", "cmuscontrold"
  end
end
