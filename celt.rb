class Celt < Formula
  homepage "http://www.celt-codec.org/"
  url "http://downloads.xiph.org/releases/celt/celt-0.11.3.tar.gz"
  sha256 "7e64815d4a8a009d0280ecd235ebd917da3abdcfd8f7d0812218c085f9480836"

  depends_on "libogg" => :optional

  fails_with :llvm do
    build 2335
    cause "'make check' fails"
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end
end
