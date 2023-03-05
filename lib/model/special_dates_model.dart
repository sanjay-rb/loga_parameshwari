// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

class SpecialDatesModel {
  final collectionName = "SpecialDates";
  Timestamp date;
  String pooja;
  SpecialDatesModel({
    this.date,
    this.pooja,
  });

  Future<void> add() async {
    await DatabaseManager().db.collection(collectionName).add(toMap());
  }

  Stream<List<SpecialDatesModel>> getThisMonthDates() {
    return DatabaseManager()
        .db
        .collection(collectionName)
        .where(
          // >= current month first day
          'date',
          isGreaterThanOrEqualTo: DateTime(
            DateTime.now().year,
            DateTime.now().month,
          ),
        )
        .where(
          // <= Next month first day
          'date',
          isLessThanOrEqualTo: DateTime(
            DateTime.now().year,
            ((DateTime.now().month) % 12) + 1,
          ),
        )
        .orderBy('date')
        .snapshots()
        .map((QuerySnapshot event) {
      return event.docs.map(
        (e) {
          final SpecialDatesModel model =
              SpecialDatesModel.fromMap(e.data() as Map<String, dynamic>);
          return model;
        },
      ).toList();
    });
  }

  SpecialDatesModel copyWith({
    Timestamp date,
    String pooja,
  }) {
    return SpecialDatesModel(
      date: date ?? this.date,
      pooja: pooja ?? this.pooja,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'pooja': pooja,
    };
  }

  factory SpecialDatesModel.fromMap(Map<String, dynamic> map) {
    return SpecialDatesModel(
      date: map['date'] as Timestamp,
      pooja: map['pooja'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SpecialDatesModel.fromJson(String source) =>
      SpecialDatesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SpecialDatesModel(date: $date, pooja: $pooja)';

  @override
  bool operator ==(covariant SpecialDatesModel other) {
    if (identical(this, other)) return true;

    return other.date == date && other.pooja == pooja;
  }

  @override
  int get hashCode => date.hashCode ^ pooja.hashCode;
}
