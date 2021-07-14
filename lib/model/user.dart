class UserModel {
  String id;
  String uid;
  String name;
  UserModel({this.id, this.uid, this.name});
  UserModel.fromJson(json) {
    this.id = json['id'];
    this.uid = json['uid'];
    this.name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'uid': this.uid,
      'name': this.name,
    };
  }
}
