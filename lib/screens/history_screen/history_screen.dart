import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/model/pooja.dart';
import 'package:loga_parameshwari/screens/history_screen/components/tree_leaf.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: const Text("History"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: DatabaseManager.getAllPoojaStream(),
                  initialData: null,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.data.docs.isNotEmpty) {
                        final List<QueryDocumentSnapshot> allPooja =
                            snapshot.data.docs;
                        final controller = ScrollController(
                          initialScrollOffset: (allPooja.length + 1) * 50.0,
                        );
                        final data = allPooja
                            .where((QueryDocumentSnapshot<Object> element) {
                          final Pooja pooja = Pooja.fromJson(element);
                          return pooja.on.toDate().compareTo(DateTime.now()) ==
                              1;
                        });
                        var moveTo = 0.0;
                        if (data.isNotEmpty) {
                          moveTo = (allPooja.indexOf(data.last) * 2) * 50.0;
                        }
                        Future.delayed(const Duration(milliseconds: 500), () {
                          controller.animateTo(
                            moveTo,
                            duration: const Duration(seconds: 1),
                            curve: Curves.ease,
                          );
                        });

                        return ListView.builder(
                          controller: controller,
                          itemCount: allPooja.length + 1,
                          itemBuilder: (context, index) {
                            if (index == allPooja.length) {
                              return SizedBox(
                                width: double.maxFinite,
                                height: 50,
                                child: Stack(
                                  children: [
                                    Row(
                                      children: index.isEven
                                          ? [
                                              const Spacer(
                                                flex: 40,
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  color: Colors.purple,
                                                ),
                                              ),
                                              const Spacer(
                                                flex: 40,
                                              ),
                                            ]
                                          : [
                                              const Spacer(
                                                flex: 40,
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  color: Colors.purple,
                                                ),
                                              ),
                                              const Spacer(
                                                flex: 40,
                                              ),
                                            ],
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return TreeLeaf(
                                pooja: Pooja.fromJson(allPooja[index]),
                                index: index,
                                id: allPooja[index].id,
                              );
                            }
                          },
                        );
                      } else {
                        return const Center(
                          child: Text("No Pooja has been fetched"),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
