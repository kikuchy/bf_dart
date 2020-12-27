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

class Runtime {
  final _Tape _tape = _Tape();
  int _pointer = 0;
  int _counter = 0;
  int _depth = 0;

  void exec(String source) {
    for (_counter = 0; _counter < source.length; _counter++) {
      switch (source[_counter]) {
        case '>':
          _pointer++;
          break;
        case '<':
          _pointer--;
          break;
        case '+':
          _tape.incValue(_pointer);
          break;
        case '-':
          _tape.decValue(_pointer);
          break;
        case '.':
          stdout.write(String.fromCharCode(_tape.getValue(_pointer)));
          break;
        case ',':
          final line = stdin.readLineSync();
          final code = line.codeUnitAt(0);
          _tape.setValue(_pointer, code);
          break;
        case '[':
          if (_tape.getValue(_pointer) == 0) {
            _counter++;
            while (_depth > 0 || source[_counter] != ']') {
              if (source[_counter] == '[') {
                _depth++;
              } else if (source[_counter] == ']') {
                _depth--;
              }
              _counter++;
            }
          }
          break;
        case ']':
          _counter--;
          while (_depth > 0 || source[_counter] != '[') {
            _counter--;
            if (source[_counter] == ']') {
              _depth++;
            } else if (source[_counter] == '[') {
              _depth--;
            }
          }
          _counter--;
          break;
      }
    }
  }
}
