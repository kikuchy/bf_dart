class Transpiler {
  final StringBuffer _result = StringBuffer();
  int _indentLevel = 1;

  void _writeDelectives() {
    _result.writeln('import \'dart:io\';');
    _result.writeln();
  }

  void _writeRuntime() {
    _result.writeln('''
class _Tape {
  final List<int> _memory = [0];

  void incValue(int at) {
    setValue(at, getValue(at) + 1);
  }

  void decValue(int at) {
    setValue(at, getValue(at) - 1);
  }

  void setValue(int at, int value) {
    _ensureMemoryAllocated(at);
    _memory[at] = value;
  }

  int getValue(int at) {
    _ensureMemoryAllocated(at);
    return _memory[at] ?? 0;
  }

  void _ensureMemoryAllocated(int lastIndex) {
    if (_memory.length <= lastIndex) {
      _memory.length = lastIndex + 1;
    }
  }
}

void putChar(int charCode) {
  stdout.write(String.fromCharCode(charCode));
} 

int getChar() {
  final line = stdin.readLineSync();
  final code = line.codeUnitAt(0);
  return code;
}
''');
  }

  void _writeMain(String source) {
    _result.writeln('''
void main() {
  final tape = _Tape();
  var pointer = 0;
''');

    for (var counter = 0; counter < source.length; counter++) {
      switch (source[counter]) {
        case '>':
          _writePointerInc();
          break;
        case '<':
          _writePointerDec();
          break;
        case '+':
          _writeValueInc();
          break;
        case '-':
          _writeValueDec();
          break;
        case '.':
          _writePutChar();
          break;
        case ',':
          _writeGetChar();
          break;
        case '[':
          _writeWhileBegin();
          _indentLevel++;
          break;
        case ']':
          _indentLevel--;
          _writeWhileEng();
          break;
      }
    }
    _result.writeln('}');
  }

  void _writePointerInc() {
    _result.writeln(_indent('pointer++;'));
  }

  void _writePointerDec() {
    _result.writeln(_indent('pointer--;'));
  }

  void _writeValueInc() {
    _result.writeln(_indent('tape.incValue(pointer);'));
  }

  void _writeValueDec() {
    _result.writeln(_indent('tape.decValue(pointer);'));
  }

  void _writePutChar() {
    _result.writeln(_indent('putChar(tape.getValue(pointer));'));
  }

  void _writeGetChar() {
    _result.writeln(_indent('tape.setValue(pointer, getChar());'));
  }

  void _writeWhileBegin() {
    _result.writeln(_indent('while(tape.getValue(pointer) != 0) {'));
  }

  void _writeWhileEng() {
    _result.writeln(_indent('}'));
  }

  String _indent(String line) => '${'  ' * _indentLevel}$line';

  String transpile(String source) {
    _writeDelectives();
    _writeRuntime();
    _writeMain(source);

    return _result.toString();
  }
}
