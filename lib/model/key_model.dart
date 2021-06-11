class KeyModel {
  final String name;
  final String key;

  KeyModel(this.key, this.name);

  factory KeyModel.fromMap(Map<String, dynamic> map) {
    return KeyModel(
      map['key'],
      map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'name': name,
    };
  }
}
