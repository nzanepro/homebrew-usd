class Materialx < Formula
  desc "MaterialX is an open standard for transfer of rich material and look-development content between applications and renderers."
  homepage "http://www.materialx.org/"
  url "https://github.com/nzanepro/MaterialX/releases/download/v1.36.4-including-submodules/MaterialX-1.36.4-including-submodules.tar.gz"
  sha256 "4d444474f9298998475720cc0087ab5c141aaa4ebcc53278529303dcba964641"

  depends_on "cmake" => :build
  depends_on "python@2"
  depends_on "nzanepro/usd/openimageio"
  depends_on "nzanepro/usd/opencolorio"

  def install
    system "cmake",
           "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}",
           "-DMATERIALX_BUILD_PYTHON=ON",
           "-DMATERIALX_BUILD_VIEWER=ON",
           "-DMATERIALX_PYTHON_VERSION=2.7",
           "-DMATERIALX_PYTHON_EXECUTABLE=#{HOMEBREW_PREFIX}/bin/python2.7",
           "."
    system "make", "install"
  end

  test do
    system "true"
  end
end
