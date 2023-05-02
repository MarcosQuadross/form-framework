import 'reflexao.dart';
import 'models.dart';

class Campos {
  Texto nome = Texto('Nome', 'Digite seu nome', 1);
  Texto sobrenome = Texto('Sobrenome', 'Digite seu sobrenome', 2);
  Data nascimento = Data('Data', DateTime.now(), 'Data de nascimento', 3);
  Data morte = Data('Data', DateTime.now(), 'Data de falecimento', 3);
  Frase historia = Frase('Historia', 'Digite sua história', 4);
}

void main() {
  Campos campos = Campos();
  gerar_form(campos);
  gerar_tabela(campos);
}
