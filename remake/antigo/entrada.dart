import 'model.dart';

class Campos {
  Texto nome = Texto(id: 1, nome: 'Nome', verboso: 'Digite seu nome');
  Texto sobrenome = Texto(id: 2, nome: 'Sobrenome', verboso: 'Digite seu sobrenome');
  Data nascimento = Data(id: 3, nome: DateTime.now(), verboso: 'Data de nascimento');
  Frase historia = Frase(id: 4, nome: 'Historia', verboso: 'Digite sua história');
}