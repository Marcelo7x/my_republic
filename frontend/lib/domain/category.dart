class Category {
  late final int _id;
  late final String _name;

  Category({required id, required name}) {
    _id = id;
    _name = name;
  }

  int get id => _id;
  String get name => _name;
}
