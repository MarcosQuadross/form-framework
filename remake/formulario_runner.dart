/*import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';

var arquivo_index = File("index.html");
final formHtml = arquivo_index.readAsStringSync();
var app = Router()
  ..get('/form', (Request request) {
    // Mostra o formulário para o usuário preencher
    return Response.ok(formHtml, headers: {'Content-Type': 'text/html'});
  })
  ..post('/form', (Request request) async {
    // Processa o formulário enviado pelo usuário
    var body = await request.readAsString();
    var params = Uri.splitQueryString(body);

    var database = sqlite3.open('formulario.db');
    database.execute('CREATE TABLE IF NOT EXISTS formulario (id INTEGER PRIMARY KEY, nome TEXT, data TEXT, frase TEXT)');
    database.execute('INSERT INTO formulario (nome, data, frase) VALUES (?, ?, ?)',
      [params['nome'], params['data'], params['frase']]);
    
    return Response.ok('Olá, ${params['nome']}!');
  });

void main() async {
  var server = await io.serve(app, InternetAddress.anyIPv4, 1234);
  print('Servidor rodando em ${server.address}:${server.port}');
}
*/
import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

var arquivo_index = File("index.html");
final formHtml = arquivo_index.readAsStringSync();

final database = sqlite3.open('banco1.db');

var app = Router()
  ..get('/form', (Request request) {
    // Mostra o formulário para o usuário preencher
    return Response.ok(formHtml, headers: {'Content-Type': 'text/html'});
  })
  /*..post('/criar-tabela', (Request request) async {
    // Extrai os dados enviados pelo formulário
    var body = await request.readAsString();
    var formData = Uri.splitQueryString(body);
    var tableName = formData['table_name'];
    var columns = formData['columns']?.split(',').map((e) => e.trim()).toList();

    // Cria uma tabela no banco de dados com base nos dados do formulário
    var createTableSql = 'CREATE TABLE $tableName (${columns?.join(', ')});';
    database.execute(createTableSql);

    return Response.ok('Tabela $tableName criada com sucesso!');
  })
  ..post('/form', (Request request) async {
    // Extrai os dados enviados pelo formulário
    var body = await request.readAsString();
    var formData = Uri.splitQueryString(body);
    var tableName = formData['table_name'];
    var columns = formData['columns']?.split(',').map((e) => e.trim()).toList();

    // Cria uma tabela no banco de dados com base nos dados do formulário
    var createTableSql = 'CREATE TABLE $tableName (${columns?.join(', ')});';
    database.execute(createTableSql);

    var nome = formData['campo_nome'];
    var data = formData['campo_data'];
    var frase = formData['campo_mensagem'];

    // Insere os dados na tabela do banco de dados
    database.execute('INSERT INTO formulario (nome, data, frase) VALUES (?, ?, ?)',
      [nome, data, frase]);
    return Response.ok('Tabela $tableName criada com sucesso!');
  })*/;

void main() async {
  var server = await io.serve(app, InternetAddress.anyIPv4, 1234);
  print('Servidor rodando em ${server.address}:${server.port}');
}
