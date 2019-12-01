class Materialx < Formula
  desc "MaterialX is an open standard for transfer of rich material and look-development content between applications and renderers."
  homepage "http://www.materialx.org/"
  url "https://github.com/nzanepro/MaterialX/releases/download/v1.36.4-including-submodules/MaterialX-1.36.4-including-submodules.tar.gz"
  sha256 "4d444474f9298998475720cc0087ab5c141aaa4ebcc53278529303dcba964641"

  depends_on "cmake" => :build
  depends_on "python@2"
  depends_on "nzanepro/usd/openimageio"

  def install
    pyver = Language::Python.major_minor_version "python2"

    system "cmake",
           "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}",
           "-DMATERIALX_BUILD_PYTHON=ON",
           "-DMATERIALX_BUILD_VIEWER=ON",
           "-DMATERIALX_PYTHON_VERSION=2.7",
           "-DMATERIALX_PYTHON_EXECUTABLE=#{HOMEBREW_PREFIX}/bin/python2.7",
           "."
    system "make", "install"

    site_packages = "lib/python#{pyver}/site-packages"
    pth_contents = "import site; site.addsitedir('#{prefix}/python')\n"
    (prefix/site_packages/"homebrew-materialx.pth").write pth_contents
    system "install_name_tool", "-add_rpath", "#{prefix}/python/MaterialX", "#{prefix}/python/MaterialX/PyMaterialXFormat.so"
  end

  test do
    output = <<~EOS
      from __future__ import print_function
      import MaterialX
      # print(dir(MaterialX))
    EOS
    assert_match "", pipe_output("python", output, 0)
  end
end
