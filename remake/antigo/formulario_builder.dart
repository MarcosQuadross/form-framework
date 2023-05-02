import 'entrada.dart';
import 'model.dart';
import 'dart:io';
import 'dart:mirrors';
import 'package:reflectable/reflectable.dart';

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

class FormularioBuilder {
  List<Formulario> campos;
  Function(String) callback;

  FormularioBuilder({required this.campos, required this.callback});

  void addCampo(Formulario campo) {
    campos.add(campo);
  }

  void build() {
    String html = '';
    for (var campo in campos) {

      var nome = reflect(campo).getField(Symbol('nome')).reflectee;
      var id = reflect(campo).getField(Symbol('id')).reflectee;
      var verboso = reflect(campo).getField(Symbol('verboso')).reflectee;

      if (campo is Texto) {
        html += '<label for="${nome}">${verboso}:</label><br><input type="text" id="${id}" /> <br>';
      } else if (campo is Data) {
        html += '<label for="${nome}">${verboso}:</label><br><input type="date" id="${id}" /> <br>';
      } else if (campo is Frase) {
        html += '<label for="${nome}">${verboso}:</label><br><textarea id="${id}"></textarea> <br>';
      }
    }
    html += '<button type="submit">Enviar</button> <br>';

    // Chamamos a função de callback com o HTML gerado
    callback(html);
  }
}

void main(List<String> arguments) async {
  // Recupera o primeiro argumento
  var input = arguments[0];

  final objs = getObjects(input);

  FormularioBuilder form = FormularioBuilder(
    campos: objs.cast<Formulario>(),
    callback: (html) {
      print(html);
    },
  );
  
  form.build();
}



/*
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 5678);
  print('Listening on ${server.address}:${server.port}');

  await for (var request in server) {
    if (request.method == 'GET') {
      final formularioBuilder = FormularioBuilder((html) {
        request.response
          ..headers.contentType = ContentType.html
          ..write(html);
        request.response.close();
      });

      /*formularioBuilder.addCampo(Texto(id: 1, nome: 'Nome', verboso: 'Digite seu nome'));
      formularioBuilder.addCampo(Texto(id: 2, nome: 'Sobrenome', verboso: 'Digite seu sobrenome'));
      formularioBuilder.addCampo(Data(id: 3, nome: DateTime.now(), verboso: 'Data de nascimento'));
      formularioBuilder.addCampo(Frase(id: 4, nome: 'Historia', verboso: 'Digite sua história'));*/
      formularioBuilder.build();
    } else {
      request.response.statusCode = HttpStatus.methodNotAllowed;
      await request.response.close();
    }
  }
}*/
