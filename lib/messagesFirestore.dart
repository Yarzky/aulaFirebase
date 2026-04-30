import 'package:test_firebase/widgets/widgetsInput.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/mensagens.dart';
import 'widgets/widgetsButton.dart';
import 'widgets/widgetsTexto.dart';

class MensagensFirestore extends StatefulWidget {
  String user;
  String friend;
  MensagensFirestore(this.user, this.friend);

  @override
  _MensagensFirestoreState createState() => _MensagensFirestoreState();
}

class _MensagensFirestoreState extends State<MensagensFirestore> {
  final _friend = TextEditingController();
  final _user = TextEditingController();
  final _msg = TextEditingController();
  final _qtdmsg = TextEditingController();
  List _resultsList = [];

  @override
  Widget build(BuildContext context) {
    _user.text = widget.user.toString();
    _friend.text = widget.friend.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text("Mensagens"),
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(9),
      children: [
        Textos("Conversas com seu amigo: " + _friend.text),
        Textos(" "),
        InputTextos("", "Digite a mensagem:", controller: _msg),
        Botoes("Enviar", onPressed: () {
          _clicksend(context);
        }),
        Botoes("Receber", onPressed: _buscaRegistro),
        SizedBox(height: 10),
        ..._resultsList.map((msg) => Card(
          child: ListTile(
            title: Text(msg.msg),
            subtitle: Text("${msg.user} → ${msg.friend} | ${msg.dt}"),
          ),
        )),
      ],
    );
  }

  ContainerInsere(TextEditingController txt, String label, String rotulo) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(left: 3, right: 3, bottom: 0, top: 0),
      child: InputTextos(rotulo, label, controller: txt),
      alignment: AlignmentDirectional.topStart,
    );
  }

  void _clicksend(BuildContext ctx) {
    if (_msg.text.isEmpty) return;

    Mensagens mensagem = Mensagens();
    mensagem.user = _user.text;
    mensagem.friend = _friend.text;
    mensagem.msg = _msg.text;
    mensagem.dt = DateTime.now();

    FirebaseFirestore.instance
        .collection("mensagens")
        .add(mensagem.toJson())
        .then((value) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text("Mensagem enviada!")),
      );
    });

    _msg.text = "";
    _qtdmsg.text = "1";
  }

  void _buscaRegistro() {
    FirebaseFirestore.instance
        .collection("mensagens")
        .where("user", isEqualTo: _user.text)
        .where("friend", isEqualTo: _friend.text)
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
