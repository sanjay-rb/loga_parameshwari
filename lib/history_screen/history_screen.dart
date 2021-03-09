import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loga_parameshwari/detail_pooja_screen/detail_pooja_screen.dart';
import 'package:loga_parameshwari/model/pooja.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text("History"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Event')
                .orderBy(
                  'on',
                  descending: true,
                )
                .snapshots(),
            initialData: null,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.data.docs.isNotEmpty) {
                  List<QueryDocumentSnapshot> allPooja = snapshot.data.docs;
                  return ListView.builder(
                    itemCount: allPooja.length,
                    itemBuilder: (context, index) {
                      return TreeLeaf(
                        pooja: Pooja.fromJson(allPooja[index]),
                        index: index,
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text("No Pooja has been fetched"),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

class TreeLeaf extends StatelessWidget {
  const TreeLeaf({
    Key key,
    @required this.pooja,
    @required this.index,
  }) : super(key: key);

  final Pooja pooja;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 100,
      child: Stack(
        children: [
          Row(
            children: index % 2 == 0
                ? [
                    LeafCard(pooja: pooja),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.purple,
                      ),
                    ),
                    LeafDate(pooja: pooja),
                  ]
                : [
                    LeafDate(pooja: pooja),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.purple,
                      ),
                    ),
                    LeafCard(pooja: pooja),
                  ],
          ),
          Center(
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeafCard extends StatelessWidget {
  const LeafCard({
    Key key,
    @required this.pooja,
  }) : super(key: key);

  final Pooja pooja;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 40,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: OpenContainer(
          closedBuilder: (context, action) => Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${pooja.name}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "by ${pooja.by}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          openBuilder: (context, action) => DetailPooja(
            pooja: pooja,
          ),
        ),
      ),
    );
  }
}

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
