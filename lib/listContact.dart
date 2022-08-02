import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class listContacts extends StatefulWidget {
  listContacts({Key? key}) : super(key: key);

  @override
  ContactListPageState createState() => ContactListPageState();
}

class ContactListPageState extends State<listContacts> {

  final CollectionReference _contacts = FirebaseFirestore.instance.collection("contacts");

  String message = "";
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }
  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the bottom";
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the top";
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder(
        stream: _contacts.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshots) {
          if(streamSnapshots.hasData){
            return ListView.builder(
              controller: _controller,
              itemCount: streamSnapshots.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshots.data!.docs[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                      isThreeLine: true,
                      title: Text(documentSnapshot['users']),
                      subtitle: Column(
                        children: [
                          Text("Phone: "+documentSnapshot['phone']),
                          Text("Date Time: "+documentSnapshot['check-in'].toDate().toString()),
                          IconButton(
                            icon: Icon(Icons.delete_rounded) ,
                            onPressed: () {
                              final docUser = FirebaseFirestore.instance
                                  .collection('contacts')
                                  .doc(documentSnapshot.id);
                              docUser.delete();
                            },
                          ),

                        ],

                      )
                  ),

                );
              },
            );

          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

}
