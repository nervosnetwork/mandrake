# mandrake

[![Mandrake CI](https://github.com/nervosnetwork/mandrake/workflows/Mandrake%20CI/badge.svg)](https://github.com/nervosnetwork/mandrake/actions?query=workflow%3A%22Mandrake+CI%22)

The Animagus GUI.

## Requirements

Mandrake is a Flutter app. Follow the [Flutter SDK](https://flutter.dev/docs/get-started/install) installation instructions to set up.

Mandrake run as web app, or macOS desktop app (experimental). It requires different [Flutter channels](https://github.com/flutter/flutter/wiki/Flutter-build-release-channels) to run, respectively:

### web:

```shell
flutter channel dev
flutter upgrade
flutter config --enable-web
```

### macOS desktop:

*Warning: macOS desktop support is experimental. We are only aiming to support web for the initial release*

```shell
flutter channel dev
flutter upgrade
flutter config --enable-macos-desktop
```

Refer to [Desktop support for Flutter](https://flutter.dev/desktop) for more information.
