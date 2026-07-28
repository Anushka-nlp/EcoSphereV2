import 'package:hooks/hooks.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    // No optional C++ FFI decoder compilation needed for EchoSphere
  });
}
