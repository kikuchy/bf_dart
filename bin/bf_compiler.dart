import 'dart:io';

import 'package:bf_dart/compiler.dart';

void usage() {
  print('''
usage: bf_transpile <source file> <destination file>
''');
}

void main(List<String> arguments) async {
  if (arguments.length != 2) {
    usage();
    return;
  }

  final sourceFilePath = arguments[0];
  final destFilePath = arguments[1];
  final sourceFile = File(sourceFilePath);
  final compiler = Compiler(sourceFile.absolute.path);
  await compiler.compile(await sourceFile.readAsString(), destFilePath);
}
