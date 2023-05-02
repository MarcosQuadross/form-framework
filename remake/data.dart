import 'campo.dart';

class Data implements Campo {
  DateTime data;
  String verboso;
  int id;
  String nome;
  Data(this.data, this.verboso, this.id, this.nome);
}
