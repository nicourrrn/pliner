# Maintainer: Твоє ім'я <твоя@пошта>
pkgname=pliner
pkgver=1.0.0
pkgrel=1
pkgdesc="Task and process manager built with Flutter"
arch=('x86_64')
url="https://github.com/твій-юзер/pliner"
license=('MIT')
depends=('flutter' 'glibc')
makedepends=('git' 'flutter' 'cmake' 'ninja')
source=("git+$url.git")
md5sums=('SKIP')

build() {
  cd "$srcdir/$pkgname"
  flutter pub get
  flutter build linux --release
}

package() {
  install -d "$pkgdir/usr/bin"
  install -Dm755 "$srcdir/$pkgname/build/linux/x64/release/bundle/pliner" "$pkgdir/usr/bin/pliner"

  install -d "$pkgdir/usr/share/applications"
  install -Dm644 "linux/pliner.desktop" "$pkgdir/usr/share/applications/pliner.desktop"

  install -d "$pkgdir/usr/share/icons/hicolor/256x256/apps"
  install -Dm644 "assets/icon/app_icon.png" "$pkgdir/usr/share/icons/hicolor/256x256/apps/pliner.png"
}
