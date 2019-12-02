class Usd < Formula
  include Language::Python::Virtualenv
  desc "Universal Scene Description"
  homepage "http://www.openusd.org"
  url "https://github.com/PixarAnimationStudios/USD/archive/v19.11.tar.gz"
  sha256 "84f3bb123f7950b277aace096d678c8876737add0ed0b6ccb77cabb4f32dbcb0"

  depends_on "cmake"
  depends_on "python@2"
  depends_on "nzanepro/qt4/qt@4"
  depends_on "nzanepro/qt4/pyside@1.2"
  depends_on "nzanepro/qt4/pyside-tools@1.2"

  depends_on "boost"
  depends_on "boost-python@2"
  depends_on "nzanepro/usd/openimageio"
  depends_on "nzanepro/usd/opencolorio"
  depends_on "nzanepro/usd/materialx"

  depends_on "tbb"
  depends_on "glew"
  depends_on "openexr"
  depends_on "ptex"
  depends_on "opensubdiv"
  depends_on "draco"
  depends_on "brewsci/science/alembic"
  depends_on "hdf5"

  resource "PyOpenGL" do
    url "https://files.pythonhosted.org/packages/9c/1d/4544708aaa89f26c97cc09450bb333a23724a320923e74d73e028b3560f9/PyOpenGL-3.1.0.tar.gz"
    sha256 "9b47c5c3a094fa518ca88aeed35ae75834d53e4285512c61879f67a48c94ddaf"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7b/db/1d037ccd626d05a7a47a1b81ea73775614af83c2b3e53d86a0bb41d8d799/Jinja2-2.10.3.tar.gz"
    sha256 "9fe95f19286cfefaa917656583d020be14e7859c6b0252588391e47db34527de"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install resources

    args = std_cmake_args + %w[
      -DPXR_ENABLE_PYTHON_SUPPORT=ON
      -DPXR_ENABLE_PTEX_SUPPORT=ON
      -DPXR_ENABLE_HDF5_SUPPORT=ON
      -DBUILD_SHARED_LIBS=ON
      -DPXR_BUILD_IMAGING=ON
      -DPXR_BUILD_USDVIEW=ON
      -DPXR_BUILD_MATERIALX_PLUGIN=ON
      -DPXR_BUILD_ALEMBIC_PLUGIN=ON
      -DPXR_BUILD_DRACO_PLUGIN=ON
      -DPXR_BUILD_OPENIMAGEIO_PLUGIN=ON
      -DPXR_BUILD_OPENCOLORIO_PLUGIN=ON
    ]

    # CMake picks up the system's python dylib, even if we have a brewed one.
    pyver = Language::Python.major_minor_version "python2"
    pyprefix = Formula["python@2"].opt_frameworks/"Python.framework/Versions/#{pyver}"

    ENV["PYTHONPATH"]="#{libexec}/lib/python#{pyver}/site-packages"

    args << "-DPYTHON_EXECUTABLE='#{pyprefix}/bin/python2'"
    args << "-DPYTHON_LIBRARY='#{pyprefix}/lib/libpython#{pyver}.dylib'"
    args << "-DPYTHON_INCLUDE_DIR='#{pyprefix}/include/python#{pyver}'"

    args << "-DMATERIALX_STDLIB_DIR=#{Formula["materialx"].opt_prefix}/lib"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    site_packages = "lib/python#{pyver}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}'); site.addsitedir('#{lib}/python')\n"
    (prefix/site_packages/"homebrew-usd.pth").write pth_contents
  end

  test do
    system "#{HOMEBREW_PREFIX}/bin/python", "#{prefix}/share/usd/tutorials/helloWorld/helloWorld.py"
    assert_predicate testpath/"HelloWorld.usda", :exist?
  end
end
