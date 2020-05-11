Protocol Buffers Definitions
============================

Files under this folder are generated code from [animagus](https://github.com/xxuejie/animagus). Do not modify.

## How to generate

Assuming all these dependencies are installed:

* [Protocol Buffers](https://github.com/protocolbuffers/protobuf)
* [Dart Protocol Buffer plugin](https://github.com/dart-lang/protobuf)

Run this inside the animagus source root folder:

```shell
protoc -Iprotos protos/ast.proto --dart_out=[/path/to/this/folder]
protoc -Iprotos protos/generic.proto --dart_out=[/path/to/this/folder]
```