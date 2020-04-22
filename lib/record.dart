import 'package:cloud_firestore/cloud_firestore.dart';

///The dart class to get item information from firebase
class Record {
  final String item;
  final String price;
  final String imagePath1;
  final String imagePath2;
  final String imagePath3;
  final String imagePath4;
  final String description;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['item'] != null),
        assert(map['price'] != null),
        item = map['item'],
        price = map['price'].toString(),
        imagePath1 = map['imagePath1'],
        imagePath2 = map['imagePath2'],
        imagePath3 = map['imagePath3'],
        imagePath4 = map['imagePath4'],
        description = map['description'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

}