class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/Release-2.0.12.tar.gz"
  sha256 "930a142c9cabbbc3b249577083c97e9f0407cc8cbf933144f3a3ed0f3ec9cfe0"
  revision 1
  head "https://github.com/OpenImageIO/oiio.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "ilmbase"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "opencolorio"
  depends_on "openexr"
  depends_on "python@2"
  depends_on "webp"

  def install
    args = std_cmake_args + %w[
      -DCCACHE_FOUND=
      -DEMBEDPLUGINS=ON
      -DUSE_FIELD3D=OFF
      -DUSE_JPEGTURBO=OFF
      -DUSE_NUKE=OFF
      -DUSE_OPENCV=OFF
      -DUSE_OPENGL=OFF
      -DUSE_OPENJPEG=OFF
      -DUSE_PTEX=OFF
      -DUSE_QT=OFF
    ]

    # CMake picks up the system's python dylib, even if we have a brewed one.
    pyver = Language::Python.major_minor_version "python"
    pyprefix = Formula["python"].opt_frameworks/"Python.framework/Versions/#{pyver}"

    ENV["PYTHONPATH"] = lib/"python#{pyver}/site-packages"

    args << "-DPYTHON_EXECUTABLE=#{pyprefix}/bin/python"
    args << "-DPYTHON_LIBRARY=#{pyprefix}/lib/libpython#{pyver}.dylib"
    args << "-DPYTHON_INCLUDE_DIR=#{pyprefix}/include/python#{pyver}m"

    # CMake picks up boost-python instead of boost-python
    args << "-DBOOST_ROOT=#{Formula["boost"].opt_prefix}"
    args << "-DBoost_PYTHON_LIBRARIES=#{Formula["boost-python"].opt_lib}/libboost_python#{pyver.to_s.delete(".")}-mt.dylib"

    # This is strange, but must be set to make the hack above work
    args << "-DBoost_PYTHON_LIBRARY_DEBUG=''"
    args << "-DBoost_PYTHON_LIBRARY_RELEASE=''"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match "#{test_image} :    1 x    1, 3 channel, uint8 jpeg",
                 shell_output("#{bin}/oiiotool --info #{test_image} 2>&1")

    output = <<~EOS
      from __future__ import print_function
      import OpenImageIO
      print(OpenImageIO.VERSION_STRING)
    EOS
    assert_match version.to_s, pipe_output("python", output, 0)
  end
end
