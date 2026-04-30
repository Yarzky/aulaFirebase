import 'package:flutter/material.dart';
import 'widgets/widgetsButton.dart';
import 'widgets/widgetsInput.dart';
import 'messagesFirestore.dart';
import 'messageList.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final _txtUsuario = TextEditingController();
  final _txtAmigo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Escolha a opção"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
            tooltip: 'Usuário',
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
            tooltip: 'Configurações',
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(9),
        children: [
          Botoes("Conversar", onPressed: () {
            _abreTelaConversar(context);
          }),
          SizedBox(height: 20),
          InputTextos("", "Seu usuário:", controller: _txtUsuario),
          SizedBox(height: 20),
          InputTextos("", "Com quem você quer conversar?", controller: _txtAmigo),
          SizedBox(height: 20),
          Botoes("Histórico de mensagens", onPressed: () {
            _abreTelaHistorico(context);
          }),
        ],
      ),
    );
  }

  _abreTelaConversar(BuildContext ctx) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context) {
      return MensagensFirestore(_txtUsuario.text, _txtAmigo.text);
    }));
  }

  _abreTelaHistorico(BuildContext ctx) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context) {
      return MessageList(_txtUsuario.text, _txtAmigo.text);
    }));
  }
}
