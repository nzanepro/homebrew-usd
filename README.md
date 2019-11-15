# homebrew-usd

This Homebrew tap allows you to install usd (and various packages that depend on it) on macOS Sierra and newer. You can install it like this:

    brew tap nzanepro/usd
    brew tap-pin nzanepro/usd
    brew install usd

    or

    brew install nzanepro/usd/usd

Feel free to submit an issue or pull request if you run into any problems or have any suggestions for improvements to the packages.

This brew tap is dependent on https://github.com/cartr/homebrew-qt4 for qt@4 pyside@1.2 and pyside-tools@1.2

**Please note:** Qt4 is unsupported by its creators, so there are likely security/usability problems with it that will never be resolved. If you can, please consider migrating your projects to Qt5.
