import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/services/responsive_services.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({Key key}) : super(key: key);
  static final _listofData = [
    {'title': 'Account name', 'value': 'Babu RJ'},
    {'title': 'Account number', 'value': '1392500101678101'},
    {'title': 'IFSC number', 'value': 'KARB0000139'},
    {'title': 'GooglePay number', 'value': '9500907006'},
    {'title': 'UPI ID', 'value': 'baburj1973@oksbi'},
  ];

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
            child: ListView(
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
                ...List.generate(DonationScreen._listofData.length, (index) {
                  final String currentValue =
                      DonationScreen._listofData[index]['value'];
                  final String currentTitle =
                      DonationScreen._listofData[index]['title'];
                  return Column(
                    children: [
                      Container(
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
                            labelStyle: const TextStyle(color: Colors.white),
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
            ),
          ),
        ),
      ),
    );
  }
}
