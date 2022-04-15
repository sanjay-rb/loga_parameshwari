import 'package:flutter/material.dart';

class SpecialPoojaComponent extends StatelessWidget {
  const SpecialPoojaComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        border: Border.all(),
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            width: double.maxFinite,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.amber,
            ),
            child: const Center(
              child: Text(
                "Special Poojaa",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text("Month")),
              DataColumn(label: Text("Poojaa")),
            ],
            rows: const [
              DataRow(
                cells: [
                  DataCell(Text("Meenam")),
                  DataCell(Text("Varshika Poojaa")),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text("Medam")),
                  DataCell(Text("Vishukanii Poojaa")),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text("Karkidakam")),
                  DataCell(Text("Aadivelli pooja")),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text("Dhanu")),
                  DataCell(Text("Vilakoduvu poojaa")),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
