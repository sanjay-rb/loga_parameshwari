import 'package:flutter/material.dart';

class SpecialPoojaComponent extends StatelessWidget {
  const SpecialPoojaComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.amber,
          ),
          child: Center(
            child: Text(
              "Special Poojaa",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Container(
          child: DataTable(columns: [
            DataColumn(label: Text("Month")),
            DataColumn(label: Text("Poojaa")),
          ], rows: [
            DataRow(cells: [
              DataCell(Text("Meenam")),
              DataCell(Text("Varshika Poojaa")),
            ]),
            DataRow(cells: [
              DataCell(Text("Medam")),
              DataCell(Text("Vishukanii Poojaa")),
            ]),
            DataRow(cells: [
              DataCell(Text("Karkidakam")),
              DataCell(Text("Aadivelli pooja")),
            ]),
            DataRow(cells: [
              DataCell(Text("Dhanu")),
              DataCell(Text("Vilakoduvu poojaa")),
            ]),
          ]),
        ),
      ],
    );
  }
}
