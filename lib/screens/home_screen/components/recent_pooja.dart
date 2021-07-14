import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

import '../../add_pooja_screen.dart';
import '../../../constant/constant.dart';
import '../../../model/pooja.dart';

class RecentPooja extends StatelessWidget {
  const RecentPooja({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: CardContainer.borderRadius,
        color: Colors.white,
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: DatabaseManager.getRecentPoojaStream(),
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data.docs.isNotEmpty) {
              Pooja next = Pooja.fromJson(snapshot.data.docs.first.data());
              return RecentPoojaView(next: next);
            } else {
              return RecentPoojaView(next: null);
            }
          }
        },
      ),
    );
  }
}

class RecentPoojaView extends StatelessWidget {
  const RecentPoojaView({
    Key key,
    @required this.next,
  }) : super(key: key);
  final Pooja next;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: 50,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  this.next != null ? "${next.name}" : "No Event Scheduled",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
            height: 50,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  this.next != null
                      ? "on ${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(next.on.toDate())}"
                      : "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 60,
          child: Container(
            width: double.maxFinite,
            child: Image.asset(
              'images/god.webp',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          flex: 15,
          child: GestureDetector(
            onTap: this.next != null
                ? null
                : () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPoojaScreen(),
                        ));
                  },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              height: 50,
              child: Center(
                child: Text(
                  this.next != null ? "by ${next.by}" : "Schedule Now",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
