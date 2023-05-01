export 'product.dart';

class Product {
  int _id;
  String _name;
  double _price;
  String _description;

  Product(this._id, this._name, this._price, this._description);

  int get id => _id;
  set id(int id) => _id = id;

  String get name => _name;
  set name(String name) => _name = name;

  double get price => _price;
  set price(double price) => _price = price;

  String get description => _description;
  set description(String description) => _description = description;

  void describe() {
    print("Id: $_id");
    print("Nome: $_name");
    print("Preço: $price");
    print("Descrição: $description");
  }
}
