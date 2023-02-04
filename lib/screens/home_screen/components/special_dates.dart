import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/model/special_dates_model.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

class SpecialDatesComponent extends StatelessWidget {
  final double width;
  final double height;
  const SpecialDatesComponent({Key key, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: StreamBuilder<DocumentSnapshot>(
        stream: DatabaseManager.getCurrentMonthSpecialDates(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          final SpecialDatesModel specialDatesModel = SpecialDatesModel.fromMap(
            snapshot.data.data() as Map<String, dynamic>,
          );
          debugPrint("specialDatesModel = $specialDatesModel");
          return Row(
            children: [
              SpecialDates(
                title: "Ayilyam Pooja",
                dateTime: specialDatesModel.ayilyam_pooja.toDate(),
              ),
              SpecialDates(
                title: "Amavasya Pooja",
                dateTime: specialDatesModel.amavasya_pooja.toDate(),
              ),
              SpecialDates(
                title: "Pournami Pooja",
                dateTime: specialDatesModel.pournami_pooja.toDate(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SpecialDates extends StatelessWidget {
  final String title;
  final DateTime dateTime;
  const SpecialDates({
    Key key,
    this.title,
    this.dateTime,
  }) : super(key: key);

  String getMonth(int index) {
    return [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ][index - 1];
  }

  String getWeekDay(int index) {
    return ["Mon", "Tues", "Wed", "Thur", "Fri", "Sat", "Sun"][index - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    border: Border.all(),
                  ),
                  child: Center(
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(title),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: FittedBox(child: Text("${dateTime.day}")),
              ),
              Expanded(
                flex: 3,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    border: Border.all(),
                  ),
                  child: Center(
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${getWeekDay(dateTime.weekday)} (${getMonth(dateTime.month)})",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
