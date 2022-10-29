import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/services/database_manager.dart';
import 'package:loga_parameshwari/services/responsive_services.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({Key key}) : super(key: key);

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  String copiedText = '';

  @override
  void initState() {
    Clipboard.getData(Clipboard.kTextPlain).then((value) {
      setState(() {
        copiedText = value.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        ScaffoldMessenger.of(context).clearSnackBars();
        return Future.value(true);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<DocumentSnapshot>(
              stream: DatabaseManager.getAccountDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final listOfData = [
                    {
                      'title': 'Account name',
                      'value': snapshot.data["ac_name"] as String
                    },
                    {
                      'title': 'Account number',
                      'value': snapshot.data["ac_number"] as String
                    },
                    {
                      'title': 'IFSC number',
                      'value': snapshot.data["ifsc_number"] as String
                    },
                    {
                      'title': 'GooglePay number',
                      'value': snapshot.data["gpay_number"] as String
                    },
                    {
                      'title': 'UPI ID',
                      'value': snapshot.data["upi_id"] as String
                    },
                  ];

                  return ListView(
                    children: [
                      SizedBox(
                        height: Responsiveness.height(10),
                      ),
                      const Text(
                        "Donation Details",
                        style: TextDesign.headText,
                      ),
                      Divider(
                        endIndent: Responsiveness.widthRatio(0.3),
                        color: Colors.black,
                        thickness: 3,
                      ),
                      SizedBox(
                        height: Responsiveness.height(10),
                      ),
                      ...List.generate(listOfData.length, (index) {
                        final String currentValue = listOfData[index]['value'];
                        final String currentTitle = listOfData[index]['title'];
                        return Column(
                          children: [
                            ColoredBox(
                              color: Colors.yellow,
                              child: ListTile(
                                title: Text(currentValue),
                                subtitle: Text(currentTitle),
                                trailing: Chip(
                                  label: (currentValue == copiedText)
                                      ? const Text('Copied')
                                      : const Text('Copy'),
                                  backgroundColor: (currentValue == copiedText)
                                      ? Colors.green
                                      : Colors.blue,
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: currentValue,
                                    ),
                                  ).then((value) {
                                    ScaffoldMessenger.of(context)
                                      ..clearSnackBars()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Copied : $currentValue',
                                          ),
                                        ),
                                      );
                                    setState(() {
                                      copiedText = currentValue;
                                    });
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: Responsiveness.height(10),
                            ),
                          ],
                        );
                      }),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
