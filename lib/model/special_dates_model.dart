// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, avoid_dynamic_calls
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:loga_parameshwari/constant/api.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

class SpecialDatesModel {
  final collectionName = "SpecialDatesNew";
  Timestamp date;
  String pooja;
  SpecialDatesModel({
    this.date,
    this.pooja,
  });

  Future<DateTime> refreshNewDate(DateTime dateTime, String key) async {
    DateTime return_date;

    int refresh_rate = 30;
    if (["Amawasya", "Poornima"].contains(key)) {
      refresh_rate = 30;
    } else {
      refresh_rate = 27;
    }

    // Checking prev day from refresh_rate days
    DateTime new_date = dateTime.add(Duration(days: refresh_rate - 1));
    Map result = await checkThitiOrNakshatraAPI(new_date, key);
    if (result['name'] == key) {
      return new_date;
    }

    // Adding refresh_rate days and checking...
    new_date = dateTime.add(Duration(days: refresh_rate));
    result = await checkThitiOrNakshatraAPI(new_date, key);
    if (result['name'] == key) {
      return new_date;
    }

    // Checking next day from refresh_rate days
    new_date = dateTime.add(Duration(days: refresh_rate + 1));
    result = await checkThitiOrNakshatraAPI(new_date, key);
    if (result['name'] == key) {
      return new_date;
    }

    return return_date;
  }

  Future<Map> checkThitiOrNakshatraAPI(DateTime dateTime, String key) async {
    // Thiti Output : I/flutter (13848): {"number": 30, "name": "Amawasya", "paksha": "krishna", "completes_at": "2024-06-06 16:27:10", "left_precentage": 73.96}
    String URL = "";
    if (["Amawasya", "Poornima"].contains(key)) {
      URL = "https://json.freeastrologyapi.com/tithi-durations";
    } else {
      URL = "https://json.freeastrologyapi.com/nakshatra-durations";
    }

    final result = await http.post(
      Uri.parse(URL),
      body: jsonEncode({
        "year": dateTime.year,
        "month": dateTime.month,
        "date": dateTime.day,
        "hours": dateTime.hour,
        "minutes": dateTime.minute,
        "seconds": dateTime.second,
        "latitude": 10.766306,
        "longitude": 76.733572,
        "timezone": 5.5,
        "config": {
          "observation_point": "topocentric",
        }
      }),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': API.freeastrologyapi,
      },
    );
    final Map body = jsonDecode(result.body) as Map;
    if (result.statusCode == 200) {
      final Map output = jsonDecode(body['output'] as String) as Map;
      logger.i(output);
      return output;
    } else {
      logger.e(body);
      if (body['message'] == "Too Many Requests") {
        await Future.delayed(const Duration(seconds: 5));
        return checkThitiOrNakshatraAPI(dateTime, key);
      }
      return null;
    }
  }

  Future<void> add() async {
    await DatabaseManager().db.collection(collectionName).add(toMap());
  }

  Future<bool> updatePoojas() async {
    final List<SpecialDatesModel> currentData = await getThisMonthDates().first;
    final DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final SpecialDatesModel amavasai = currentData
        .where((element) => element.pooja.startsWith("Amavasai"))
        .first;
    final SpecialDatesModel ayilyam = currentData
        .where((element) => element.pooja.startsWith("Ayilyam"))
        .first;
    final SpecialDatesModel pournami = currentData
        .where((element) => element.pooja.startsWith("Pournami"))
        .first;

    final DateTime amavasai_date = DateTime(
      amavasai.date.toDate().year,
      amavasai.date.toDate().month,
      amavasai.date.toDate().day,
    );
    final DateTime ayilyam_date = DateTime(
      ayilyam.date.toDate().year,
      ayilyam.date.toDate().month,
      ayilyam.date.toDate().day,
    );
    final DateTime pournami_date = DateTime(
      pournami.date.toDate().year,
      pournami.date.toDate().month,
      pournami.date.toDate().day,
    );
    if (today.compareTo(amavasai_date) > 0) {
      logger.i("Refresh Amawasya");
      final DateTime new_amavasai =
          await refreshNewDate(amavasai_date, "Amawasya");
      if (new_amavasai != null) {
        updateSpecialDate(new_amavasai, amavasai.pooja);
      }
    }
    if (today.compareTo(ayilyam_date) > 0) {
      logger.i("Refresh Ayilyam");
      final DateTime new_ayilyam =
          await refreshNewDate(ayilyam_date, "Aaslesha");
      if (new_ayilyam != null) {
        updateSpecialDate(new_ayilyam, ayilyam.pooja);
      }
    }
    if (today.compareTo(pournami_date) > 0) {
      logger.i("Refresh Poornima");
      final DateTime new_pournami =
          await refreshNewDate(pournami_date, "Poornima");
      if (new_pournami != null) {
        updateSpecialDate(new_pournami, pournami.pooja);
      }
    }
    return Future.value(true);
  }

  Future updateSpecialDate(DateTime date, String pooja) {
    return DatabaseManager()
        .db
        .collection(collectionName)
        .doc(pooja.split(" ").first)
        .update({'date': Timestamp.fromDate(date), 'pooja': pooja});
  }

  Stream<List<SpecialDatesModel>> getThisMonthDates() {
    return DatabaseManager()
        .db
        .collection(collectionName)
        .orderBy('date')
        .snapshots()
        .map((QuerySnapshot event) {
      return event.docs
          .map(
            (e) => SpecialDatesModel.fromMap(e.data() as Map<String, dynamic>),
          )
          .toList();
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
