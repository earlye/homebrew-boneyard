class CppNetlib < Formula
  desc "C++ libraries for high level network programming"
  homepage "http://cpp-netlib.org"
  url "https://github.com/cpp-netlib/cpp-netlib/archive/cpp-netlib-0.11.2-final.tar.gz"
  version "0.11.2"
  sha256 "176822a2a18190345cd35a8f10eaed02206bba9255dcbbdcd9e69d8fe1786e77"
  revision 1

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "asio"

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  needs :cxx11

  def install
    ENV.cxx11

    # NB: Do not build examples or tests as they require submodules.
    system "cmake", "-DCPP-NETLIB_BUILD_TESTS=OFF", "-DCPP-NETLIB_BUILD_EXAMPLES=OFF", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <boost/network/protocol/http/client.hpp>
      int main(int argc, char *argv[]) {
        namespace http = boost::network::http;
        http::client::options options;
        http::client client(options);
        http::client::request request("");
        return 0;
      }
    EOS
    flags = [
      "-std=c++11",
      "-stdlib=libc++",
      "-I#{include}",
      "-I#{Formula["asio"].include}",
      "-I#{Formula["boost"].include}",
      "-L#{lib}",
      "-L#{Formula["boost"].lib}",
      "-lssl",
      "-lcrypto",
      "-lboost_system-mt",
      "-lcppnetlib-uri",
      "-lcppnetlib-client-connections",
      "-lcppnetlib-server-parsers",
    ] + ENV.cflags.split
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    system "./test"
  end
end
