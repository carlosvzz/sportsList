abstract class BaseModel {
  String _id;
  String get id => _id;

  set id(String id) {
    this._id = id;
  }

  BaseModel();

  Map<String, dynamic> toMap();
  fromMap(Map<String, dynamic> map);
  BaseModel createNew();
}
