class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/imageworks/OpenColorIO/archive/v1.1.1.tar.gz"
  sha256 "c9b5b9def907e1dafb29e37336b702fff22cc6306d445a13b1621b8a754c14c8"
  revision 1
  head "https://github.com/imageworks/OpenColorIO.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "little-cms2"
  depends_on "python@2"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_VERBOSE_MAKEFILE=OFF
    ]

    pyver = Language::Python.major_minor_version "python2"
    pyprefix = Formula["python@2"].opt_frameworks/"Python.framework/Versions/#{pyver}"

    ENV["PYTHONPATH"] = lib/"python#{pyver}/site-packages"

    args << "-DPYTHON_EXECUTABLE='#{pyprefix}/bin/python2'"
    args << "-DPYTHON_LIBRARY='#{pyprefix}/lib/libpython#{pyver}.dylib'"
    args << "-DPYTHON_INCLUDE_DIR='#{pyprefix}/include/python#{pyver}'"

    mkdir "macbuild" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      OpenColorIO requires several environment variables to be set.
      You can source the following script in your shell-startup to do that:
        #{HOMEBREW_PREFIX}/share/ocio/setup_ocio.sh

      Alternatively the documentation describes what env-variables need set:
        https://opencolorio.org/installation.html#environment-variables

      You will require a config for OCIO to be useful. Sample configuration files
      and reference images can be found at:
        https://opencolorio.org/downloads.html
    EOS
  end

  test do
    assert_match "validate", shell_output("#{bin}/ociocheck --help", 1)
    output = <<~EOS
      from __future__ import print_function
      import PyOpenColorIO
      # print(dir(PyOpenColorIO))
    EOS
    assert_match "", pipe_output("python", output, 0)

  end
end
