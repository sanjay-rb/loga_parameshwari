// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SpecialDatesModel {
  Timestamp amavasya_pooja;
  Timestamp ayilyam_pooja;
  Timestamp pournami_pooja;
  SpecialDatesModel({
    this.amavasya_pooja,
    this.ayilyam_pooja,
    this.pournami_pooja,
  });

  SpecialDatesModel copyWith({
    Timestamp amavasya_pooja,
    Timestamp ayilyam_pooja,
    Timestamp pournami_pooja,
  }) {
    return SpecialDatesModel(
      amavasya_pooja: amavasya_pooja ?? this.amavasya_pooja,
      ayilyam_pooja: ayilyam_pooja ?? this.ayilyam_pooja,
      pournami_pooja: pournami_pooja ?? this.pournami_pooja,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amavasya_pooja': amavasya_pooja,
      'ayilyam_pooja': ayilyam_pooja,
      'pournami_pooja': pournami_pooja,
    };
  }

  factory SpecialDatesModel.fromMap(Map<String, dynamic> map) {
    return SpecialDatesModel(
      amavasya_pooja: map['amavasya_pooja'] as Timestamp,
      ayilyam_pooja: map['ayilyam_pooja'] as Timestamp,
      pournami_pooja: map['pournami_pooja'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory SpecialDatesModel.fromJson(String source) =>
      SpecialDatesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SpecialDatesModel(amavasya_pooja: $amavasya_pooja, ayilyam_pooja: $ayilyam_pooja, pournami_pooja: $pournami_pooja)';

  @override
  bool operator ==(covariant SpecialDatesModel other) {
    if (identical(this, other)) return true;

    return other.amavasya_pooja == amavasya_pooja &&
        other.ayilyam_pooja == ayilyam_pooja &&
        other.pournami_pooja == pournami_pooja;
  }

  @override
  int get hashCode =>
      amavasya_pooja.hashCode ^
      ayilyam_pooja.hashCode ^
      pournami_pooja.hashCode;
}
