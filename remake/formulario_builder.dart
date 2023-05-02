import 'dart:io';

import 'campo.dart';
import 'texto.dart';
import 'data.dart';
import 'frase.dart';

class FormularioBuilder {
  List<Campo> campos;
  Function(String) callback;

  FormularioBuilder(this.callback) : campos = [];

  void addCampo(Campo campo) {
    campos.add(campo);
  }

  void build() {
    String html = '<!DOCTYPE html><html><head><title>Formulário</title></head><body><form method="post">';

    for (var campo in campos) {
      if (campo is Texto) {
        html +=
            '<label for="${campo.nome}">${campo.verboso}:</label><br><input type="text" name="${campo.nome}" id="${campo.id}" /> <br>';
      } else if (campo is Data) {
        html +=
            '<label for="${campo.nome}">${campo.verboso}:</label><br><input type="date" name="${campo.nome}" id="${campo.id}" /> <br>';
      } else if (campo is Frase) {
        html +=
            '<label for="${campo.nome}">${campo.verboso}:</label><br><textarea name="${campo.nome}" id="${campo.id}"></textarea> <br>';
      }
    }

    html += '<button type="submit">Enviar</button> <br></form></body></html>';

    // Abre o arquivo para escrita
    var file = File("index.html");
    var sink = file.openWrite();

    // Escreve o HTML no arquivo
    sink.write(html);

    // Fecha o arquivo
    sink.close();
    
    // Chamamos a função de callback com o HTML gerado
    callback(html);
  }
}
