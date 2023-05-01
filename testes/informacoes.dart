// import 'dart:io';
// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart' as io;
// import 'package:shelf_router/shelf_router.dart';

// var formHtml = '''
//     <label for="VAR_NAME">SHOW_NAME:</label>
//     <input type="text" id="VAR_NAME" name="VAR_NAME"><br><br>
//     <label for="VAR_NAME">SHOW_NAME:</label><br>
//     <textarea id="VAR_NAME" name="VAR_NAME" rows="4" cols="50"></textarea><br><br>
//     <label for="VAR_NAME">SHOW_NAME:</label>
//     <input type="date" id="VAR_NAME" name="VAR_NAME"><br><br>''';

// var app = Router()
//   ..get('/form', (Request request) {
//     // Mostra o formulário para o usuário preencher
//     return Response.ok(formHtml, headers: {'Content-Type': 'text/html'});
//   })
//   ..post('/form', (Request request) async {
//     // Processa o formulário enviado pelo usuário
//     var nome = await request.readAsString();
//     return Response.ok('Olá, $nome!');
//   });

// void main() async {
//   var server = await io.serve(app, InternetAddress.anyIPv4, 8080);
//   print('Servidor rodando em ${server.address}:${server.port}');

//   // Espera por um comando para parar o servidor
//   ProcessSignal.sigint.watch().listen((signal) async {
//     print('Encerrando o servidor...');
//     await server.close();
//     exit(0); // encerra o programa
//   });
// }

import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

var formHtml = '''
    <form method="post">
        <label for="nome">Digite</label>
        <input type="text" id="nome" name="nome">
        <input type="submit" value="Enviar">
    </form>
''';

var app = Router()
  ..get('/form', (Request request) {
    // Mostra o formulário para o usuário preencher
    return Response.ok(formHtml, headers: {'Content-Type': 'text/html'});
  })
  ..post('/form', (Request request) async {
    // Processa o formulário enviado pelo usuário
    var nome = await request.readAsString();
    return Response.ok('Olá, $nome!');
  });

void main() async {
  var server = await io.serve(app, InternetAddress.anyIPv4, 8080);
  print('Servidor rodando em ${server.address}:${server.port}');
}
