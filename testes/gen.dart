import 'package:args/args.dart';
import 'dart:mirrors';
import 'model.dart';

String get_objects(String input) {
  return "";
}

dynamic getModule(String moduleName) {
  var libName = Symbol(moduleName);
  var libMirror = currentMirrorSystem().findLibrary(libName);
  var myVariableSymbol = Symbol('myVariable');
  var myVariableMirror = libMirror.getField(myVariableSymbol);
  return myVariableMirror.reflectee;
}

void genForm(List<Type> objs) {
  final dataFrase = '''
    <label for="VAR_NAME">SHOW_NAME:</label>
    <input type="text" id="VAR_NAME" name="VAR_NAME"><br><br>''';

  final dataTexto = '''
    <label for="VAR_NAME">SHOW_NAME:</label><br>
    <textarea id="VAR_NAME" name="VAR_NAME" rows="4" cols="50"></textarea><br><br>''';

  final dataData = '''
    <label for="VAR_NAME">SHOW_NAME:</label>
    <input type="date" id="VAR_NAME" name="VAR_NAME"><br><br>''';

  final dataHtml = {
    Frase: dataFrase,
    Texto: dataTexto,
    Data: dataData,
  };

  for (var inst in objs) {
    final content = '<form method="POST" action="/processar_formulario">';
  }
}

void main() {
  var module = getModule('product.dart');
  var myClass = module.Product();
  myClass.name = "John";
  myClass.describe(); // Saída: "Hello, John!"
}
