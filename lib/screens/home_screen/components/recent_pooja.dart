import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/pooja.dart';
import 'package:loga_parameshwari/screens/add_pooja_screen.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

class RecentPooja extends StatelessWidget {
  const RecentPooja({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: CardContainer.borderRadius,
        color: Colors.white,
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: DatabaseManager.getRecentPoojaStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Object>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data.docs.isNotEmpty) {
              final Pooja next = Pooja.fromJson(snapshot.data.docs.first);
              return RecentPoojaView(next: next);
            } else {
              return const RecentPoojaView(next: null);
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
            decoration: const BoxDecoration(
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
                  next != null ? next.name : "No Event Scheduled",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
            decoration: const BoxDecoration(
              color: Colors.amber,
            ),
            height: 50,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  next != null
                      ? "on ${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(next.on.toDate())}"
                      : "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 70,
          child: SizedBox(
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
            onTap: next != null
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddPoojaScreen(),
                      ),
                    );
                  },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              height: 50,
              child: Center(
                child: Text(
                  getSponsorByText(),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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

  String getSponsorByText() {
    if (next != null) {
      if (next.by.split('\n').length > 1) {
        return "by ${next.by.split('\n').length} members";
      } else {
        return "by ${next.by}";
      }
    } else {
      return "Schedule Now";
    }
  }
}
