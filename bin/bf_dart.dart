import 'dart:io';

import 'package:bf_dart/bf_dart.dart' as bf_dart;

void usage () {
  print('''
usage: bf_dart <source file>
''');
}

void main(List<String> arguments) async {
  if (arguments.length != 1) {
    usage();
    return;
  }
  final sourceFilePath = arguments[0];
  final sourceFile = File(sourceFilePath);
  final runtime = bf_dart.Runtime();
  runtime.exec(await sourceFile.readAsString());
}
