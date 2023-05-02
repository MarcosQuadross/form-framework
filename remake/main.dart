import 'formulario_builder.dart';
import 'texto.dart';
import 'data.dart';
import 'frase.dart';
import 'package:reflectable/reflectable.dart';
import 'dart:mirrors';

class Campos {
  Texto nome = Texto('Nome', 'Digite seu nome',1);
  Texto sobrenome = Texto('Sobrenome', 'Digite seu sobrenome',2);
  Data nascimento = Data(DateTime.now(),'Data de nascimento', 3);
  Frase historia = Frase('Historia', 'Digite sua história', 4);
}

void reflectCampos(Campos campos) {
  InstanceMirror instanceMirror = reflect(campos) as InstanceMirror;
  ClassMirror classMirror = instanceMirror.type;

  for (var fieldName in classMirror.declarations.keys) {
    var field = classMirror.declarations[fieldName];

    if (field is VariableMirror) {
      var fieldValue = instanceMirror.getField(Symbol(fieldName)).reflectee;
      var fieldType = field.type.simpleName;

      if (fieldType == #Texto) {
        var texto = fieldValue as Texto;
        print('Texto: ${texto.nome}, ${texto.verboso}, ${texto.id}');
      } else if (fieldType == #Data) {
        var data = fieldValue as Data;
        print('Data: ${data.nome}, ${data.verboso}, ${data.id}');
      } else if (fieldType == #Frase) {
        var frase = fieldValue as Frase;
        print('Frase: ${frase.nome}, ${frase.verboso}, ${frase.id}');
      }
    }
  }
}

void main() {
  FormularioBuilder builder = FormularioBuilder((html) => print(html));

  builder.addCampo(Texto('nome', 'Nome', 'campo_nome'));
  builder.addCampo(Texto('sobrenome', 'Sobrenome', 'campo_sobrenome'));
  builder.addCampo(Data('data', 'Data de Nascimento', 'campo_data'));
  builder.addCampo(Frase('mensagem', 'Mensagem', 'campo_mensagem'));

  builder.build();

  
}
