class Usd < Formula
  include Language::Python::Virtualenv
  desc "Universal Scene Description"
  homepage "http://www.openusd.org"
  url "https://github.com/PixarAnimationStudios/USD/archive/v19.11.tar.gz"
  sha256 "84f3bb123f7950b277aace096d678c8876737add0ed0b6ccb77cabb4f32dbcb0"

  depends_on "cmake"
  depends_on "python@2"
  depends_on "cartr/qt4/qt@4"
  depends_on "cartr/qt4/pyside@1.2"
  depends_on "cartr/qt4/pyside-tools@1.2"

  resource "PyOpenGL" do
    url "https://files.pythonhosted.org/packages/9c/1d/4544708aaa89f26c97cc09450bb333a23724a320923e74d73e028b3560f9/PyOpenGL-3.1.0.tar.gz"
    sha256 "9b47c5c3a094fa518ca88aeed35ae75834d53e4285512c61879f67a48c94ddaf"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7b/db/1d037ccd626d05a7a47a1b81ea73775614af83c2b3e53d86a0bb41d8d799/Jinja2-2.10.3.tar.gz"
    sha256 "9fe95f19286cfefaa917656583d020be14e7859c6b0252588391e47db34527de"
  end

  def install
    xy = Language::Python::major_minor_version "python2"
    venv = virtualenv_create(libexec)
    venv.pip_install resources

    ENV["PYTHONPATH"]="#{libexec}/lib/python#{xy}/site-packages"
    system "python", "build_scripts/build_usd.py", "--materialx", "#{prefix}"

    site_packages = "lib/python#{xy}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}'); site.addsitedir('#{lib}/python')\n"
    (prefix/site_packages/"homebrew-usd.pth").write pth_contents
  end

  test do
    system "#{HOMEBREW_PREFIX}/bin/python", "#{prefix}/share/usd/tutorials/helloWorld/helloWorld.py"
    assert_predicate testpath/"HelloWorld.usda", :exist?
  end
end
