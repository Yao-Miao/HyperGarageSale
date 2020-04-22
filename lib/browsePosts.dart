
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'postScreen.dart';
import 'record.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'itemScreen.dart';

///The dart class for browse post page
class BrowsePosts extends StatelessWidget{
  final FirebaseStorage _storage = FirebaseStorage(storageBucket:'gs://neu-spring2020.appspot.com');

  Future<dynamic> loadImage(String imagePath) async {
    return await _storage.ref().child(imagePath).getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Items In Store'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostScreen()),
                );
              },
            ),
          ]
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostScreen()),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),

    );
  }
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ym_items_list').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {

    return ListView(
      padding: const EdgeInsets.only(top: 10.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }
  Future<Widget> _getImage(String image) async {
    Image m;
    await loadImage(image).then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
      );
    });
    return m;
  }
  FutureBuilder _getImageWidget(BuildContext context, String image){
    return FutureBuilder(
      future: _getImage(image),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.done)
          return Container(
            //decoration: {},
            alignment: Alignment.centerLeft,
            height: MediaQuery.of(context).size.height /
                1,
            width: MediaQuery.of(context).size.width /
                8,
            child: snapshot.data,
          );

        if (snapshot.connectionState ==
            ConnectionState.waiting)
          return Container(
              alignment: Alignment.centerLeft,
              height: MediaQuery.of(context).size.height /
                  1,
              width: MediaQuery.of(context).size.width /
                  8,
              child: CircularProgressIndicator());

        return Container();
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);


    return Card(
      key: ValueKey(record.item),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      //padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          leading: record.imagePath1 == null ? Icon(Icons.camera):_getImageWidget(context,record.imagePath1),
            title: Text(record.item),
            trailing: Text("\$ " + record.price),
            onTap: () => {
              Navigator.push(
                context,
              MaterialPageRoute(builder: (context) => ItemScreen(record)),
              )
            },
        ),
      ),
    );
  }

}