import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<http.Response>(
          future: http.get(
            Uri.parse(
              "https://raw.githubusercontent.com/sanjay-rb/loga_parameshwari/master/README.md",
            ),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final http.Response response = snapshot.data;
            return Markdown(data: response.body);
          },
        ),
      ),
    );
  }
}
