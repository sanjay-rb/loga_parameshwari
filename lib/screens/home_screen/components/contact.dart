import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/model/contact.dart';
import 'package:loga_parameshwari/services/database_manager.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactComponent extends StatelessWidget {
  final double height;
  final double width;
  const ContactComponent({Key key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: DatabaseManager.getContactInfo(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              snapshot.data.docs.length,
              (index) => ContactCard(
                height: height,
                width: width,
                contactModel: ContactModel.fromMap(
                  snapshot.data.docs[index].data() as Map<String, dynamic>,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ContactCard extends StatelessWidget {
  final double width;
  final double height;
  final ContactModel contactModel;
  const ContactCard({
    Key key,
    this.height,
    this.width,
    this.contactModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber.shade100,
      child: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: const [
                  Text(
                    "卐",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "卐",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        child: CachedNetworkImage(
                          imageUrl: contactModel.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "🪔 ",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextSpan(
                                    text: contactModel.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "🪔 ",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextSpan(
                                    text: contactModel.role,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "🪔 ",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextSpan(
                                    text: contactModel.number,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 25,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  launchUrlString("tel:${contactModel.number}");
                                },
                                icon: const Icon(Icons.call),
                                label: const Text("Call"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: const [
                  Text(
                    "卐",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "卐",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
