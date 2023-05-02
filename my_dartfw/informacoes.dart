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

  final conn = sqlite3.open('dados.db');

  final nome = formData['Nome'];
  final sobrenome = formData['Sobrenome'];
  final nascimento = formData['Nascimento'];
  final morte = formData['Morte'];
  final historia = formData['Historia'];

  print(formData);

  conn.execute('CREATE TABLE IF NOT EXISTS formulario '
      '(id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'nome TEXT, '
      'sobrenome TEXT, '
      'historia VARCHAR(255), '
      'nascimento DATE, '
      'morte DATE NULL);');

  conn.execute(
      'INSERT INTO formulario (nome, sobrenome, nascimento, morte, historia) VALUES (?, ?, ?, ?, ?)',
      [nome, sobrenome, nascimento, morte, historia]);

  conn.dispose();

  return Response.ok('Dados salvos com sucesso!',
      headers: {'Content-Type': 'text/plain'});
}

Future<void> main() async {
  app.get('/', _formulario);
  app.post('/', _processarFormulario);

  var server = await shelf_io.serve(app, InternetAddress.anyIPv4, 8080);
  print('Servidor rodando em ${server.address}:${server.port}');
}
