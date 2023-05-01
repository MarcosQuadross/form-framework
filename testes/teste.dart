import 'dart:ffi' as ffi;
import 'package:sqlite3/sqlite3.dart';

void main() {
  // Abre uma conexão com o banco de dados SQLite
  final db = sqlite3.open('example.db');

  // Cria uma tabela de usuários com duas colunas: id e nome
  db.execute('''  
    CREATE TABLE IF NOT EXISTS users(
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL
    );
  ''');

  // Insere alguns usuários na tabela
  final names = ['Alice', 'Bob', 'Charlie'];
  for (final name in names) {
    db.execute('INSERT INTO users (name) VALUES (?)', [name]);
  }

  // Lê os usuários da tabela e exibe seus nomes
  final result = db.select('SELECT * FROM users');
  for (final row in result) {
    final id = row['id'];
    final name = row['name'];
    print('User $id: $name');
  }

  // Fecha a conexão com o banco de dados
  db.dispose();
}
