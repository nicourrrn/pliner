run:
    flutter run
build:
    flutter build apk --release && ripdrag ./build/app/outputs/flutter-apk/app-release.apk
install:
    flutter build apk --release && adb install -r ./build/app/outputs/flutter-apk/app-release.apk
