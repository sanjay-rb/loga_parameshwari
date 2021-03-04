// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ContactModel {
  String name;
  String image;
  String role;
  String number;
  ContactModel({
    this.name,
    this.image,
    this.role,
    this.number,
  });

  ContactModel copyWith({
    String name,
    String image,
    String role,
    String number,
  }) {
    return ContactModel(
      name: name ?? this.name,
      image: image ?? this.image,
      role: role ?? this.role,
      number: number ?? this.number,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'image': image,
      'role': role,
      'number': number,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      name: map['name'] as String,
      image: map['image'] as String,
      role: map['role'] as String,
      number: map['number'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) =>
      ContactModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ContactModel(name: $name, image: $image, role: $role, number: $number)';
  }

  @override
  bool operator ==(covariant ContactModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.image == image &&
        other.role == role &&
        other.number == number;
  }

  @override
  int get hashCode {
    return name.hashCode ^ image.hashCode ^ role.hashCode ^ number.hashCode;
  }
}
