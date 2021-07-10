import 'package:cloud_firestore/cloud_firestore.dart';

class Pooja {
  String name;
  String by;
  Timestamp on;

  Pooja(this.name, this.by, this.on);

  Pooja.fromJson(json) {
    this.name = json['name'];
    this.by = json['by'];
    this.on = json['on'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'by': this.by,
      'on': this.on,
    };
  }
}
