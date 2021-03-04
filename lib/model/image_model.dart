import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModel {
  String id;
  String pooja;
  String user;
  String url;
  List like;

  ImageModel({this.id, this.pooja, this.user, this.url, this.like});

  ImageModel.fromJson(QueryDocumentSnapshot<Object> json) {
    id = json['id'] as String;
    pooja = json['pooja'] as String;
    user = json['user'] as String;
    url = json['url'] as String;
    like = json['like'] as List;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pooja': pooja,
      'user': user,
      'url': url,
      'like': like,
    };
  }
}
