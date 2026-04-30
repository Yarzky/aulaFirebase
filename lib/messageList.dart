import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/mensagens.dart';

class MessageList extends StatefulWidget {
  String user;
  String friend;
  MessageList(this.user, this.friend);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  List<Mensagens> _resultsList = [];

  @override
  void initState() {
    super.initState();
    _buscaRegistro();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista conversas"),
        actions: [
          IconButton(
            onPressed: _buscaRegistro,
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: _lista(),
    );
  }

  _lista() {
    if (_resultsList.isEmpty) {
      return Center(
        child: Text("Nenhuma conversa encontrada."),
      );
    }
    return ListView.builder(
      itemCount: _resultsList.length,
      itemBuilder: (context, index) {
        Mensagens msg = _resultsList[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Icon(Icons.message, color: Colors.blue),
            title: Text(msg.msg),
            subtitle: Text("${msg.user} → ${msg.friend}"),
            trailing: Text(
              "${msg.dt.day}/${msg.dt.month}/${msg.dt.year}",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }

  void _buscaRegistro() {
    FirebaseFirestore.instance
        .collection("mensagens")
        .where("user", isEqualTo: widget.user)
        .orderBy("dt", descending: true)
        .get()
        .then((snapshot) {
      setState(() {
        _resultsList = snapshot.docs
            .map((doc) => Mensagens.fromSnapshot(doc))
            .toList();
      });
    });
  }
}
