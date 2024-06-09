import 'package:flutter/material.dart';
import 'package:loga_parameshwari/model/special_dates_model.dart';

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
      child: StreamBuilder<List<SpecialDatesModel>>(
        stream: SpecialDatesModel().getThisMonthDates(),
        builder: (context, AsyncSnapshot<List<SpecialDatesModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          final List<SpecialDatesModel> data = snapshot.data;
          if (data.isEmpty) {
            return const Center(
              child: Text("No Special Pooja Dates"),
            );
          }
          return Row(
            children: List.generate(
              data.length,
              (index) => SpecialDates(
                title: data[index].pooja,
                dateTime: data[index].date.toDate(),
              ),
            ),
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
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ][index - 1];
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
                    color: dateTime.compareTo(DateTime.now()).isNegative
                        ? Colors.grey
                        : Colors.amber,
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
                child: FittedBox(
                  child: Text(
                    "${dateTime.day}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: dateTime.compareTo(DateTime.now()).isNegative
                        ? Colors.grey
                        : Colors.amber,
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
                        child: Text(getMonth(dateTime.month)),
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
