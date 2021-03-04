import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/contact_model.dart';
import 'package:loga_parameshwari/services/database_manager.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactComponent extends StatelessWidget {
  final double height;
  final double width;
  const ContactComponent({Key key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseManager.getContactInfo(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Contacts",
              style: TextDesign.headText,
            ),
            SingleChildScrollView(
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
            ),
          ],
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(10.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            border: Border.all(),
            borderRadius: BorderRadius.circular(10.0),
          ),
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
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "卐",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.w900,
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
                              placeholder: (context, url) => const Icon(
                                Icons.account_box,
                              ),
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
                                        style: TextDesign.titleText,
                                      ),
                                      TextSpan(
                                        text: contactModel.name,
                                        style: TextDesign.titleText,
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "🪔 ",
                                        style: TextDesign.titleText,
                                      ),
                                      TextSpan(
                                        text: contactModel.role,
                                        style: TextDesign.subTitleText,
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "🪔 ",
                                        style: TextDesign.titleText,
                                      ),
                                      TextSpan(
                                        text: contactModel.number,
                                        style: TextDesign.subTitleText,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: 30,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      launchUrlString(
                                        "tel:${contactModel.number}",
                                      );
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
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "卐",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
