# mandrake

[![Mandrake CI](https://github.com/nervosnetwork/mandrake/workflows/Mandrake%20CI/badge.svg)](https://github.com/nervosnetwork/mandrake/actions?query=workflow%3A%22Mandrake+CI%22)

> Mandrake is still under active development and considered to be a work in progress.

The [Animagus](https://github.com/xxuejie/animagus) GUI.

## Requirements

Mandrake is a Flutter app. Follow the [Flutter SDK](https://flutter.dev/docs/get-started/install) installation instructions to set up.

Mandrake runs as web app or macOS desktop app (experimental). It requires different [Flutter channels](https://github.com/flutter/flutter/wiki/Flutter-build-release-channels) to run, respectively:

### web:

```shell
flutter channel dev
flutter upgrade
flutter config --enable-web
```

### macOS desktop:

*Warning: macOS desktop support is experimental. We are only aiming to support web for the initial release.*

```shell
flutter channel dev
flutter upgrade
flutter config --enable-macos-desktop
```

Refer to [Desktop support for Flutter](https://flutter.dev/desktop) for more information.

## Generate JSON serialization code

Several mode classes use [json_serializable](https://pub.dev/packages/json_serializable) to generate code. To re-generate, run:

```shell
flutter pub run build_runner build
```

Generated code files are named after `file`.g.dart, where `file` is the normal model file name.
