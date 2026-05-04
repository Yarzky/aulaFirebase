import 'package:cloud_firestore/cloud_firestore.dart';

class Mensagens {
  String user = "";
  String friend = "";
  String msg = "";
  DateTime dt = DateTime.now();

  Mensagens();
  Map<String, dynamic> toJson() => {
    'user': user,
    'friend': friend,
    'msg': msg,
    'dt': dt,
  };

  Mensagens.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    user = data['user'] ?? "";
    friend = data['friend'] ?? "";
    msg = data['msg'] ?? "";
    
    if (data['dt'] is Timestamp) {
      dt = (data['dt'] as Timestamp).toDate();
    } else if (data['dt'] is String) {
      dt = DateTime.tryParse(data['dt']) ?? DateTime.now();
    } else {
      dt = DateTime.now();
    }
  }
}
