import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/screens/donation_screen/donation_screen.dart';
import 'package:loga_parameshwari/services/responsive_services.dart';

class DonateBtn extends StatelessWidget {
  const DonateBtn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DonationScreen(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 2,
              color: Colors.blue,
            ),
          ),
          height: Responsiveness.heightRatio(0.1),
          child: const Center(
            child: Text(
              "Donate",
              style: TextDesign.headText,
            ),
          ),
        ),
      ),
    );
  }
}
