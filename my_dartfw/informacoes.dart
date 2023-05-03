import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';
import 'reflexao.dart';

// Cria uma instância do roteador do Shelf
final app = Router();

// Função que retorna uma resposta com o conteúdo do arquivo 'formulario.html'
Response _formulario(Request request) {
  return Response.ok(File('formulario.html').readAsStringSync(),
      headers: {'Content-Type': 'text/html'});
}

Future<Response> _processarFormulario(Request request) async {
  // Lê o corpo da requisição (o formulário submetido)
  final bodyBytes = await request.read().toList();
  // Decodifica o corpo da requisição (que está em bytes) para uma string UTF-8
  final body = utf8.decode(bodyBytes.expand((x) => x).toList());
  // Converte a string contendo o formulário em um mapa de dados
  final formData = Uri.splitQueryString(body);

  // Abre uma conexão com o banco de dados SQLite3
  final conn = sqlite3.open('dados.db');

  // Cria a tabela 'formulario' no banco de dados (se ela não existir)
  // String tabela = gerar_tabela(formData);
  // conn.execute('CREATE TABLE IF NOT EXISTS formulario ($tabela)');

  // Prepara a string com os nomes dos campos e valores a serem inseridos
  String campos = '';
  String valores = '';
  for (var campo in formData.keys) {
    campos += '$campo,';
    valores += '?,';
  }
  campos = campos.substring(0, campos.length - 1);
  valores = valores.substring(0, valores.length - 1);

  // Cria uma lista com os valores a serem inseridos na tabela
  List<dynamic> valoresInsercao = [];
  for (var valor in formData.values) {
    valoresInsercao.add(valor);
  }

  // Insere os dados do formulário na tabela 'formulario'
  conn.execute(
      'INSERT INTO Pessoa ($campos) VALUES ($valores)', valoresInsercao);

  // Fecha a conexão com o banco de dados
  conn.dispose();

  // Retorna uma resposta de sucesso indicando que os dados foram salvos
  return Response.ok('Dados salvos com sucesso!',
      headers: {'Content-Type': 'text/plain'});
}

// Função principal que configura o roteamento e inicia o servidor
Future<void> main() async {
  // Registra a função '_formulario' para lidar com requisições GET para '/'
  app.get('/form', _formulario);
  // Registra a função '_processarFormulario' para lidar com requisições POST para '/'
  app.post('/form', _processarFormulario);

  // Inicia o servidor na porta 8080
  var server = await shelf_io.serve(app, InternetAddress.anyIPv4, 8080);
  // Imprime no console a mensagem "Servidor rodando em <endereco>:<porta>"
  print('Servidor rodando em ${server.address}:${server.port}');
}
