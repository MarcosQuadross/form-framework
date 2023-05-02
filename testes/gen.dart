import 'dart:io';
import 'dart:mirrors';
import 'model.dart';
import 'package:sqlite3/sqlite3.dart';

List<dynamic> getObjects(String input) {
  var libraryName = input.split('.')[0];
  var libraryUriString = 'package:$libraryName/$input';
  var libraryUri = Uri.parse(libraryUriString);
  var libraryMirror =
      currentMirrorSystem().findLibrary(libraryUri as Symbol);

  var objects = <dynamic>[];
  for (var declaration in libraryMirror.declarations.values) {
    if (declaration is VariableMirror ||
        declaration is MethodMirror ||
        declaration is ClassMirror) {
      var fieldName = MirrorSystem.getName(declaration.simpleName);
      objects.add(libraryMirror.getField(Symbol(fieldName)).reflectee);
    }
  }
  return objects;
}

List<String> getAttributes(dynamic instance) {
  var instanceMirror = reflect(instance);
  var start = instanceMirror.type.instanceMembers.keys.toList().indexOf(#__proto__);
  var attrs = instanceMirror.type.instanceMembers.keys.toList().sublist(start + 1);
  return attrs.map((Symbol s) => MirrorSystem.getName(s)).toList();
}

dynamic getModule(String moduleName) {
  var libName = Symbol(moduleName);
  var libMirror = currentMirrorSystem().findLibrary(libName);
  var myVariableSymbol = Symbol('myVariable');
  var myVariableMirror = libMirror.getField(myVariableSymbol);
  return myVariableMirror.reflectee;
}

String toTitleCase(String str) {
  return str.toLowerCase().split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
}

void genForm(List<Type> objs) {
  String dataFrase = '''
    <label for="VAR_NAME">SHOW_NAME:</label>
    <input type="text" id="VAR_NAME" name="VAR_NAME"><br><br>''';
  String dataTexto = '''
    <label for="VAR_NAME">SHOW_NAME:</label><br>
    <textarea id="VAR_NAME" name="VAR_NAME" rows="4" cols="50"></textarea><br><br>''';
  String dataData = '''
    <label for="VAR_NAME">SHOW_NAME:</label>
    <input type="date" id="VAR_NAME" name="VAR_NAME"><br><br>''';

  Map<Type, String> dataHtml = {
    Frase: dataFrase,
    Texto: dataTexto,
    Data: dataData,
  };

  for (Type type in objs) {
    var classMirror = reflectClass(type);
    var instanceMirror = classMirror.newInstance(Symbol(''), []);String content = '<form method="POST" action="/processar_formulario">';
    List<String> attrs = getAttributes(instanceMirror);
    for (String attr in attrs) {
      var obj = reflect(instanceMirror).getField(Symbol(attr)).reflectee;
      var field = dataHtml[obj.runtimeType]!;
      field = field.replaceAll('VAR_NAME', attr);
      if (obj.verboso != null) {
        field = field.replaceAll('SHOW_NAME', toTitleCase(obj.verboso!));
      } else {
        var label = attr.replaceAll('_', ' ');
        field = field.replaceAll('SHOW_NAME', toTitleCase(label));
      }
      content += field;
    }
    content += '\n\t<input type="submit" value="Enviar">\n</form>';
    String filename = '${type.toString().toLowerCase()}.html';
    new File(filename).writeAsStringSync(content);
  }
}

void createConnDb(List objs) {
  final dataSql = {
    Frase: 'VARCHAR(255)',
    Texto: 'TEXT',
    Data: 'DATE',
  };

  String content = '';

  for (var inst in objs) {
    content += 'import \'dart:io\';\n';
    content += 'import \'package:sqlite3/sqlite3.dart\';\n';
    content += 'import \'package:shelf/shelf.dart\';\n';
    content += 'import \'package:shelf_router/shelf_router.dart\';\n';
    content += 'import \'package:shelf_static/shelf_static.dart\';\n';
    content += 'import \'package:mustache_template/mustache.dart\';\n';
    content += 'import \'package:convert/convert.dart\';\n\n';

    content += 'void main(List<String> args) async {\n';
    content += '  final app = Router();\n\n';

    content += '  app.mount(\'/static/\', createStaticHandler(\'static\', defaultDocument: \'index.html\'));\n\n';

    content += '  app.get(\'/\', (Request request) {\n';
    content += '    return Response.ok(renderForm(\'${inst.toString().toLowerCase()}.html\', attrs));\n';
    content += '  });\n\n';

    content += '  app.post(\'/processar_formulario\', (Request request) async {\n';
    content += '    final body = await request.readAsString();\n';
    content += '    final params = Uri(query: body).queryParameters;\n';
    content += "    final db = sqlite3.open('formularios.db');\n";
    content += "    final cols = '${getAttributes(inst()).join(' , ').replaceAll("'", "\\'")}, timestamp';\n";
    content += "    final values = List.filled(getAttributes(inst()).length + 1, '?');\n\n";

    content += '    db.execute(\'\'\'\n';
    content += '      CREATE TABLE IF NOT EXISTS ${inst.toString().toLowerCase()}(\n';
    content += '        id INTEGER PRIMARY KEY AUTOINCREMENT,\n';
    content += '        ${getAttributes(inst()).map((attr) => '$attr ${dataSql[typeOf(inst(), attr)]}').join(',\n        ')}\n';
    content += '        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP\n';
    content += '      )\n';
    content += '    \'\'\');\n\n';

    content += '    final stmt = db.prepare(\'\'\'\n';
    content += ' INSERT INTO ${inst.toString().toLowerCase()} ($cols)\n';
    content += ' VALUES (${values.join(\', \')})\n';
    content += ' \'\');\n\n';

    content += '    getAttributes(inst()).asMap().forEach((i, attr) {\n';
    content += '      stmt.bind(i + 1, params[attr]);\n';
    content += '    });\n\n';

    content += '    stmt.execute();\n\n';
    content += '    return Response.ok(renderMustache(\'${inst.toString().toLowerCase()}_sucesso.html\', {\n';
    content += '      \'titulo\': \'Formulário processado com sucesso!\',\n';
    content += '      \'mensagem\': \'Obrigado por preencher o formulário!\'\n';
    content += '    }));\n';
    content += '  });\n\n';

    content += '  final port = int.parse(Platform.environment[\'PORT\'] ?? \'8080\');\n';
    content += '  final server = await serve(app, InternetAddress.anyIPv4, port);\n';
    content += '  print(\'Servidor rodando na porta: \${server.port}\');\n';
    content += '}\n';
}
}


void main() {
  final input = Platform.script.path;
  final objs = getObjects(input);
  genForm(objs);
  createConnDb(objs);
}
