export 'model.dart';


class Formulario {
  int id;

  Formulario({required this.id});

  Map<String, dynamic> toMap() {
    return {'id': id};
  }
}

class Frase extends Formulario {
  String frase;

  Frase({required int id, required this.frase}) : super(id: id);

  Map<String, dynamic> toMap() {
    return {'id': id, 'frase': frase};
  }
}

class Texto extends Formulario {
  String texto;

  Texto({required int id, required this.texto}) : super(id: id);

  Map<String, dynamic> toMap() {
    return {'id': id, 'texto': texto};
  }
}

class Data extends Formulario {
  DateTime data;

  Data({required int id, required this.data}) : super(id: id);

  Map<String, dynamic> toMap() {
    return {'id': id, 'data': data.toIso8601String()};
  }
}
