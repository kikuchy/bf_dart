import 'dart:io';

import 'package:bf_dart/transpiler.dart';

void usage () {
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
  final sourceFile = File(sourceFilePath);
  final transpiler = Transpiler();
  final dartCode = transpiler.transpile(await sourceFile.readAsString());
  final destFilePath = arguments[1];
  final destFile = File(destFilePath);
  await destFile.writeAsString(dartCode);
}