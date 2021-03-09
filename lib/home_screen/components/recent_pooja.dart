import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/pooja.dart';

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
        stream: FirebaseFirestore.instance
            .collection('Event')
            .where('on', isGreaterThanOrEqualTo: Timestamp.now())
            .orderBy('on')
            .snapshots(),
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
          flex: 60,
          child: Container(
            width: double.maxFinite,
            child: CachedNetworkImage(
              imageUrl: ImagesAndUrls.godImg,
              fit: BoxFit.fill,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child:
                    CircularProgressIndicator(value: downloadProgress.progress),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 15,
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
