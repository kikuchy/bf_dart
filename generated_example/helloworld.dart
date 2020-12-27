import 'dart:io';

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

void main() {
  final tape = _Tape();
  var pointer = 0;

  pointer++;
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  while(tape.getValue(pointer) != 0) {
    pointer--;
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    pointer++;
    tape.decValue(pointer);
  }
  pointer--;
  putChar(tape.getValue(pointer));
  pointer++;
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  while(tape.getValue(pointer) != 0) {
    pointer--;
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    pointer++;
    tape.decValue(pointer);
  }
  pointer--;
  tape.incValue(pointer);
  putChar(tape.getValue(pointer));
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  putChar(tape.getValue(pointer));
  putChar(tape.getValue(pointer));
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  putChar(tape.getValue(pointer));
  while(tape.getValue(pointer) != 0) {
    tape.decValue(pointer);
  }
  pointer++;
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  while(tape.getValue(pointer) != 0) {
    pointer--;
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    pointer++;
    tape.decValue(pointer);
  }
  pointer--;
  putChar(tape.getValue(pointer));
  pointer++;
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  while(tape.getValue(pointer) != 0) {
    pointer--;
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    pointer++;
    tape.decValue(pointer);
  }
  pointer--;
  putChar(tape.getValue(pointer));
  pointer++;
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  while(tape.getValue(pointer) != 0) {
    pointer--;
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    pointer++;
    tape.decValue(pointer);
  }
  pointer--;
  putChar(tape.getValue(pointer));
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  putChar(tape.getValue(pointer));
  tape.decValue(pointer);
  tape.decValue(pointer);
  tape.decValue(pointer);
  tape.decValue(pointer);
  tape.decValue(pointer);
  tape.decValue(pointer);
  putChar(tape.getValue(pointer));
  tape.decValue(pointer);
  tape.decValue(pointer);
  tape.decValue(pointer);
  tape.decValue(pointer);
  tape.decValue(pointer);
  tape.decValue(pointer);
  tape.decValue(pointer);
  tape.decValue(pointer);
  putChar(tape.getValue(pointer));
  while(tape.getValue(pointer) != 0) {
    tape.decValue(pointer);
  }
  pointer++;
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  while(tape.getValue(pointer) != 0) {
    pointer--;
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    tape.incValue(pointer);
    pointer++;
    tape.decValue(pointer);
  }
  pointer--;
  tape.incValue(pointer);
  putChar(tape.getValue(pointer));
  while(tape.getValue(pointer) != 0) {
    tape.decValue(pointer);
  }
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  tape.incValue(pointer);
  putChar(tape.getValue(pointer));
}
