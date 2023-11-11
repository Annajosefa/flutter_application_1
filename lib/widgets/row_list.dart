import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RowList extends StatefulWidget {
  const RowList({super.key});

  @override
  State<RowList> createState() => _RowListState();
}

class _RowListState extends State<RowList> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<bool> rows = [false, false, false, false, false];

  @override
  void initState() {
    db.collection('rows').snapshots().listen((event) {
      bool row1 = event.docs.first.data()['r1'];
      bool row2 = event.docs.first.data()['r2'];
      bool row3 = event.docs.first.data()['r3'];
      bool row4 = event.docs.first.data()['r4'];
      bool row5 = event.docs.first.data()['r5'];
      setState(() {
        rows = [row1, row2, row3, row4, row5];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Row Available to Harvest'),
      content: Container(
        height: 300,
        width: MediaQuery.of(context).size.width * 0.8,
        alignment: Alignment.center,
        child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: const Icon(
                  Icons.local_florist,
                  color: Color(0xFFD67BFF),
                  size: 24,
                ),
                title: Text('Row #${index + 1}'),
                trailing: Text(
                  rows[index] ? 'Yes' : 'No',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: rows.length),
      ),
    );
  }
}
