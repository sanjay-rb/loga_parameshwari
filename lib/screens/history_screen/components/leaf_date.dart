import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/pooja.dart';

class LeafDate extends StatelessWidget {
  const LeafDate({
    Key key,
    @required this.pooja,
  }) : super(key: key);

  final Pooja pooja;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 40,
      child: Container(
        child: Center(
          child: Text(
              "${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(pooja.on.toDate())}"),
        ),
      ),
    );
  }
}
