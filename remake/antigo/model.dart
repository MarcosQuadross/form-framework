import 'package:reflectable/reflectable.dart';

class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, declarationsCapability, metadataCapability);
}

const reflector = Reflector();


class Formulario {
  int id;
  
  Formulario({required this.id});

  Map<String, dynamic> toMap() {
    return {'id': id};
  }
}

@Reflector()
class Texto extends Formulario {
  String nome;
  String verboso;

  Texto({required int id, required this.nome, required this.verboso}) : super(id: id);

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'verboso': verboso};
  }
}

@Reflector()
class Frase extends Formulario {
  String nome;
  String verboso;

  Frase({required int id, required this.nome, required this.verboso}) : super(id: id);

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'verboso': verboso};
  }
}

@Reflector()
class Data extends Formulario {
  DateTime nome;
  String verboso;
  
  Data({required int id, required this.nome, required this.verboso}) : super(id: id);

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome.toIso8601String(), 'verboso': verboso};
  }
}
