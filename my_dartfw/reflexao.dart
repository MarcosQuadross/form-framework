import 'dart:io';
import 'models.dart';
import 'dart:mirrors';
export 'reflexao.dart';
import 'package:sqlite3/sqlite3.dart';

String gerar_form(dynamic campos) {
  String html =
      '<!DOCTYPE html><html><head><title>Formulário</title></head><body><form method="POST">';

  InstanceMirror instanceMirror = reflect(campos);
  ClassMirror classMirror = instanceMirror.type;

  for (var fieldName in classMirror.instanceMembers.keys) {
    var field = classMirror.declarations[fieldName];
    if (field is VariableMirror) {
      MirrorSystem.getName(field.simpleName);
      var fieldType = field.type.reflectedType;

      if (fieldType == Texto) {
        var texto =
            instanceMirror.getField(field.simpleName).reflectee as Texto;
        html +=
            '<label for="${texto.nome}">${texto.verboso}:</label><br><input type="text" name="${texto.nome}" id="${texto.id}" /> <br>';
      } else if (fieldType == Data) {
        var data = instanceMirror.getField(field.simpleName).reflectee as Data;
        html +=
            '<label for="${data.nome}">${data.verboso}:</label><br><input type="date" name="${data.nome}" id="${data.id}" /> <br>';
      } else if (fieldType == Frase) {
        var frase =
            instanceMirror.getField(field.simpleName).reflectee as Frase;
        html +=
            '<label for="${frase.nome}">${frase.verboso}:</label><br><textarea name="${frase.nome}" id="${frase.id}"></textarea> <br>';
      }
    }
  }

  html += '<button type="submit">Enviar</button> <br></form></body></html>';

  // escreve o conteúdo do formulário no arquivo
  File('formulario.html').writeAsString(html);

  return html;
}

String gerar_tabela(dynamic campos) {
  var file = File('dados.db');
  if (!file.existsSync()) {
    file.createSync();
  }
  var db = sqlite3.open('dados.db');

  InstanceMirror instanceMirror = reflect(campos);
  ClassMirror classMirror = instanceMirror.type;

  Set<String> camposAdicionados = {};

  String tabela = '';

  String criarNomeModificado(String nomeOriginal) {
    int contador =
        camposAdicionados.where((campo) => campo == nomeOriginal).length;
    camposAdicionados.add(nomeOriginal);
    return contador > 0 ? "$nomeOriginal$contador" : nomeOriginal;
  }

  for (var fieldName in classMirror.instanceMembers.keys) {
    var field = classMirror.declarations[fieldName];
    if (field is VariableMirror) {
      String name = MirrorSystem.getName(field.simpleName);
      var fieldType = field.type.reflectedType;

      String nomeModificado = criarNomeModificado(name);

      if (fieldType == Texto) {
        instanceMirror.getField(field.simpleName).reflectee as Texto;
        tabela += '$nomeModificado TEXT,';
      } else if (fieldType == Data) {
        instanceMirror.getField(field.simpleName).reflectee as Data;
        tabela += '$nomeModificado DATE,';
      } else if (fieldType == Frase) {
        instanceMirror.getField(field.simpleName).reflectee as Frase;
        tabela += '$nomeModificado TEXT,';
      }
    }
  }

  tabela = tabela.substring(0, tabela.length - 1); // remove a vírgula final

  db.execute('DROP TABLE IF EXISTS formulario ');
  db.execute('CREATE TABLE IF NOT EXISTS formulario ($tabela)');

  return tabela;
}
