// import 'dart:convert';
// import 'dart:io';

// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart' as shelf_io;
// import 'package:shelf_router/shelf_router.dart';
// import 'package:sqlite3/sqlite3.dart';

// final app = Router();

// Response _formulario(Request request) {
//   return Response.ok(File('informacoes.html').readAsStringSync(),
//       headers: {'Content-Type': 'text/html'});
// }

// Future<Response> _processarFormulario(Request request) async {
//   final bodyBytes = await request.read().toList();
//   final body = utf8.decode(bodyBytes.expand((x) => x).toList());
//   final formData = Uri.splitQueryString(body);

//   final conn = sqlite3.open('formularios.db');

//   final nome = formData['nome'];
//   final nome = formData['nome'];
//   final nascimento = formData['nascimento'];

//   conn.execute('CREATE TABLE IF NOT EXISTS informacoes '
//       '(id INTEGER PRIMARY KEY AUTOINCREMENT, '
//       'nome TEXT, '
//       'nome VARCHAR(255), '
//       'nascimento DATE);');
//   conn.execute(
//       'INSERT INTO informacoes (nome, nome, nascimento) VALUES (?, ?, ?)',
//       [nome, nome, nascimento]);

//   conn.dispose();

//   return Response.ok('Dados salvos com sucesso!',
//       headers: {'Content-Type': 'text/plain'});
// }

// Future<void> main() async {
//   app.get('/', _formulario);
//   app.post('/processar_formulario', _processarFormulario);

//   final handler =
//       Pipeline().addMiddleware(logRequests()).addHandler(app.handler);

//   final server = await shelf_io.serve(handler, 'localhost', 8080);
//   print('Server listening on localhost:${server.port}');
// }

import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';

final app = Router();

Response _formulario(Request request) {
  return Response.ok(File('formulario.html').readAsStringSync(),
      headers: {'Content-Type': 'text/html'});
}

Future<Response> _processarFormulario(Request request) async {
  final bodyBytes = await request.read().toList();
  final body = utf8.decode(bodyBytes.expand((x) => x).toList());
  final formData = Uri.splitQueryString(body);

  final conn = sqlite3.open('formularios.db');

  final nome = formData['nome'];
  final sobrenome = formData['sobrenome'];
  final nascimento = formData['nascimento'];
  final morte = formData['morte'];
  final historia = formData['historia'];

  conn.execute('CREATE TABLE IF NOT EXISTS informacoes '
      '(id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'nome TEXT, '
      'sobrenome TEXT, '
      'historia VARCHAR(255), '
      'nascimento DATE),'
      'morte DATE);');
  conn.execute(
      'INSERT INTO informacoes (nome, sobrenome, nascimento, morte, historia) VALUES (?, ?, ?)',
      [nome, sobrenome, nascimento, morte, historia]);

  conn.dispose();

  return Response.ok('Dados salvos com sucesso!',
      headers: {'Content-Type': 'text/plain'});
}

Future<void> main() async {
  app.get('/', _formulario);
  app.post('/processar_formulario', _processarFormulario);

  // final handler =
  //     Pipeline().addMiddleware(logRequests()).addHandler(app.handler);

  var server = await shelf_io.serve(app, InternetAddress.anyIPv4, 8080);
  print('Servidor rodando em ${server.address}:${server.port}');
}
