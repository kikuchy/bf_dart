import 'package:kernel/kernel.dart';

class Compiler {
  static final intTypeRef =
      CanonicalName.root().getChild('dart:core').getChild('int').getReference();
  static final intType = InterfaceType.byReference(
    intTypeRef,
    Nullability.legacy,
    [],
  );
  static final stringTypeRef = CanonicalName.root()
      .getChild('dart:core')
      .getChild('String')
      .getReference();
  static final stringType = InterfaceType.byReference(
    stringTypeRef,
    Nullability.legacy,
    [],
  );
  static final listTypeRef = CanonicalName.root()
      .getChild('dart:core')
      .getChild('List')
      .getReference();

  static InterfaceType listType(DartType typeParameter) =>
      InterfaceType.byReference(
          listTypeRef, Nullability.legacy, [typeParameter]);

  final String sourceFileAbsolutePath;
  final Library _library;

  Compiler(this.sourceFileAbsolutePath)
      : _library = Library(
          Uri.file(sourceFileAbsolutePath),
          fileUri: Uri.file(sourceFileAbsolutePath),
        );

  void _writeDelectives() {
    _library.addDependency(
      LibraryDependency.import(Library(Uri.parse('dart:io'))),
    );
  }

  List<Procedure> _writeRuntime() {
    return [
      _makeGetCharProcedure(),
      _makePutCharProcedure(),
    ]..forEach(_library.addProcedure);
  }

  Procedure _makeGetCharProcedure() {
    final lineVariableDecl = VariableDeclaration(
      'line',
      type: stringType,
      isFinal: true,
      initializer: MethodInvocation(
        StaticGet.byReference(CanonicalName.root()
            .getChild('dart:io')
            .getChild('@getters')
            .getChild('stdin')
            .getReference()),
        Name('readLineSync'),
        Arguments([]),
      ),
    );
    final codeVariableDecl = VariableDeclaration(
      'code',
      type: intType,
      isFinal: true,
      initializer: MethodInvocation(
        VariableGet(lineVariableDecl),
        Name('codeUnitAt'),
        Arguments([IntLiteral(0)]),
      ),
    );
    return Procedure(
      Name('getChar'),
      ProcedureKind.Method,
      FunctionNode(
        Block([
          lineVariableDecl,
          codeVariableDecl,
          ReturnStatement(VariableGet(codeVariableDecl)),
        ]),
        returnType: intType,
      ),
      isStatic: true,
    );
  }

  Procedure _makePutCharProcedure() {
    final charCodeParamDecl = VariableDeclaration(
      'charCode',
      type: intType,
    );
    return Procedure(
      Name('putChar'),
      ProcedureKind.Method,
      FunctionNode(
        Block([
          ExpressionStatement(
            MethodInvocation(
              StaticGet.byReference(CanonicalName.root()
                  .getChild('dart:io')
                  .getChild('@getters')
                  .getChild('stdout')
                  .getReference()),
              Name('write'),
              Arguments([
                StaticInvocation.byReference(
                  CanonicalName.root()
                      .getChild('dart:core')
                      .getChild('String')
                      .getChild('@factories')
                      .getChild('fromCharCode')
                      .getReference(),
                  Arguments([VariableGet(charCodeParamDecl)]),
                )
              ]),
            ),
          )
        ]),
        positionalParameters: [charCodeParamDecl],
        returnType: VoidType(),
      ),
      isStatic: true,
    );
  }

  Procedure _makeMain(
      String source, Procedure getCharProc, Procedure putCharProc) {
    final code = <Statement>[];
    _parseSource(source, 0, code, getCharProc, putCharProc);
    return Procedure(
      Name('main'),
      ProcedureKind.Method,
      FunctionNode(
        Block([
          memoryDeclaration,
          pointerDeclaration,
          ...code,
        ]),
        returnType: VoidType(),
      ),
      isStatic: true,
    );
  }

  int _parseSource(String source, int startFrom, List<Statement> parentBlock,
      Procedure getCharProc, Procedure putCharProc) {
    for (var counter = startFrom; counter < source.length; counter++) {
      switch (source[counter]) {
        case '>':
          parentBlock.add(
            _makePointerInc(),
          );
          break;
        case '<':
          parentBlock.add(
            _makePointerDec(),
          );
          break;
        case '+':
          parentBlock.add(
            _makeValueInc(),
          );
          break;
        case '-':
          parentBlock.add(
            _makeValueDec(),
          );
          break;
        case '.':
          parentBlock.add(
            _makePutChar(putCharProc),
          );
          break;
        case ',':
          parentBlock.add(
            _makeGetChar(getCharProc),
          );
          break;
        case '[':
          final whileExpressions = <Statement>[];
          counter = _parseSource(
              source, counter + 1, whileExpressions, getCharProc, putCharProc);
          parentBlock.add(
            _makeWhileBlock(whileExpressions),
          );
          break;
        case ']':
          return counter;
      }
    }
    return -1;
  }

  final memoryDeclaration = VariableDeclaration(
    'memory',
    isFinal: true,
    type: listType(intType),
    initializer: StaticInvocation.byReference(
      CanonicalName.root()
          .getChild('dart:core')
          .getChild('_List')
          .getChild('@factories')
          .getChild('filled')
          .getReference(),
      Arguments([IntLiteral(2048), IntLiteral(0)]),
    ),
  );

  final pointerDeclaration = VariableDeclaration(
    'pointer',
    isFinal: true,
    type: intType,
    initializer: IntLiteral(0),
  );

  Statement _makePointerInc() {
    return ExpressionStatement(
      VariableSet(
        pointerDeclaration,
        MethodInvocation(
          VariableGet(pointerDeclaration),
          Name('+'),
          Arguments([IntLiteral(1)]),
        ),
      ),
    );
  }

  Statement _makePointerDec() {
    return ExpressionStatement(
      VariableSet(
        pointerDeclaration,
        MethodInvocation(
          VariableGet(pointerDeclaration),
          Name('-'),
          Arguments([IntLiteral(1)]),
        ),
      ),
    );
  }

  Statement _makeValueInc() {
    final tempMemory =
        VariableDeclaration(null, initializer: VariableGet(memoryDeclaration));
    final tempPointer =
        VariableDeclaration(null, initializer: VariableGet(pointerDeclaration));
    return ExpressionStatement(
      Let(
        tempMemory,
        Let(
          tempPointer,
          MethodInvocation(
            VariableGet(tempMemory),
            Name('[]='),
            Arguments([
              VariableGet(tempPointer),
              MethodInvocation(
                MethodInvocation(
                  VariableGet(tempMemory),
                  Name('[]'),
                  Arguments([VariableGet(tempPointer)]),
                ),
                Name('+'),
                Arguments([IntLiteral(1)]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Statement _makeValueDec() {
    final tempMemory =
        VariableDeclaration(null, initializer: VariableGet(memoryDeclaration));
    final tempPointer =
        VariableDeclaration(null, initializer: VariableGet(pointerDeclaration));
    return ExpressionStatement(
      Let(
        tempMemory,
        Let(
          tempPointer,
          MethodInvocation(
            VariableGet(tempMemory),
            Name('[]='),
            Arguments([
              VariableGet(tempPointer),
              MethodInvocation(
                MethodInvocation(
                  VariableGet(tempMemory),
                  Name('[]'),
                  Arguments([VariableGet(tempPointer)]),
                ),
                Name('-'),
                Arguments([IntLiteral(1)]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Statement _makePutChar(Procedure putCharProc) {
    return ExpressionStatement(
      StaticInvocation.byReference(
        putCharProc.reference,
        Arguments([
          MethodInvocation(
            VariableGet(memoryDeclaration),
            Name('[]'),
            Arguments([VariableGet(pointerDeclaration)]),
          ),
        ]),
      ),
    );
  }

  Statement _makeGetChar(Procedure getCharProc) {
    return ExpressionStatement(
      MethodInvocation(
        VariableGet(memoryDeclaration),
        Name('[]='),
        Arguments([
          VariableGet(pointerDeclaration),
          StaticInvocation.byReference(getCharProc.reference, Arguments([])),
        ]),
      ),
    );
  }

  Statement _makeWhileBlock(List<Statement> statements) {
    return WhileStatement(
        Not(
          MethodInvocation(
            MethodInvocation(
              VariableGet(memoryDeclaration),
              Name('[]'),
              Arguments([VariableGet(pointerDeclaration)]),
            ),
            Name('=='),
            Arguments([IntLiteral(0)]),
          ),
        ),
        Block([
          ...statements,
        ]));
  }

  Future<void> compile(String source, String distFilePath) async {
    _writeDelectives();
    final ps = _writeRuntime();
    final getCharProc = ps.first;
    final putCharProc = ps.last;
    final mainProcedure = _makeMain(source, getCharProc, putCharProc);
    _library.addProcedure(mainProcedure);

    final component = Component(
      nameRoot: CanonicalName.root(),
      libraries: [_library],
    )..setMainMethodAndMode(
        mainProcedure.reference,
        true,
        NonNullableByDefaultCompiledMode.Disabled,
      );
    await writeComponentToBinary(component, distFilePath);
  }
}
