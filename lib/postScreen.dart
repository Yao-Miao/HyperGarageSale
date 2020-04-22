import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

///The dart class for Post Screen

class PostScreen extends StatefulWidget{
  @override
  PostScreenState createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen>{
  final TextEditingController _controller_item = new TextEditingController();
  final TextEditingController _controller_price = new TextEditingController();
  final TextEditingController _controller_description = new TextEditingController();

  File _image1;
  File _image2;
  File _image3;
  File _image4;

  final FirebaseStorage _storage = FirebaseStorage(storageBucket:'gs://neu-spring2020.appspot.com');
  StorageUploadTask _uploadTask;
  List<String> deletePathList;

  /// Starts an upload task, upload image into firestorage
  String _startUpload(File image) {

    /// Unique file name for the file
    String filePath = 'ym_image/${DateTime.now()}';
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(image);
    });
    return filePath;
  }

  Future getImage1() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image1 = image;
    });
  }
  Future getImage2() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image2 = image;
    });
  }
  Future getImage3() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image3 = image;
    });
  }
  Future getImage4() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image4 = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Hyper Garage Sale'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.list),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ]
      ),
      body: ListView(
        children:[
          enterSection(),
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        tooltip: 'take a photo',
        child: Icon(Icons.camera_alt),
        onPressed: () async{
          WidgetsFlutterBinding.ensureInitialized();
          final cameras = await availableCameras();
          final firstCamera = cameras.first;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TakePictureScreen(
              camera: firstCamera,
            )),
          );
        },
      ),*/

    );
  }

  //String item, double price, String description
  //The function to post item information into firebase.
  void _postItem(){
    List<String> imagePathList = new List<String>();
    DocumentReference item_ref = Firestore.instance.document('ym_items_list/' + _controller_item.text);
    Map<String, dynamic> item_data = {
      'item':_controller_item.text,
      'price':double.parse(_controller_price.text),
      'description':_controller_description.text};

    if(_image1!=null) imagePathList.add(_startUpload(_image1));
    if(_image2!=null) imagePathList.add(_startUpload(_image2));
    if(_image3!=null) imagePathList.add(_startUpload(_image3));
    if(_image4!=null) imagePathList.add(_startUpload(_image4));
    deletePathList = imagePathList;
    if(imagePathList.isNotEmpty){
      for(int i = 0;i < imagePathList.length;i++){
        item_data.addAll({'imagePath' + (i+1).toString():imagePathList[i]});
      }
    }
    item_ref.setData(item_data);
  }
  //The function to delete item from firebase. The function will be used after user click "Undo"
  void _deleteItem(){
    DocumentReference item_ref = Firestore.instance.document('ym_items_list/' + _controller_item.text);
    for(int i = 0; i < deletePathList.length; i++){
      _storage.ref().child(deletePathList[i]).delete();
    }
    item_ref.delete();
  }
  //The section of entering field
  Widget enterSection(){
    return  Container(
      padding: const EdgeInsets.only(top:30, left: 20,right: 20),
      child:Column(
        children:[
          TextField(
            //autofocus: true,
            keyboardType: TextInputType.text,
            controller: _controller_item,
            decoration: InputDecoration(
                labelText: "Item",
                hintText: "Enter title of the item",
                prefixIcon: Icon(Icons.label)
            ),
          ),
          TextField(
            keyboardType: TextInputType.numberWithOptions(signed: false,decimal: true),
            controller: _controller_price,
            decoration: InputDecoration(
                labelText: "Price",
                hintText: "Enter price of the item",
                prefixIcon: Icon(Icons.attach_money)
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top:50),
            constraints: BoxConstraints(
                maxHeight: 300
            ),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _controller_description,
              decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "Enter description of the item",
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    //borderSide: BorderSide.none,
                  )
              ),
            ),
          ),
          Column(
            children: <Widget>[
              GridView.count(
                shrinkWrap: true,
                primary: false,
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                padding: const EdgeInsets.all(20),
                children: <Widget>[
                  GestureDetector(
                      onTap: (){
                        getImage1();
                      },
                      child: Container(
                        color: Colors.black12,
                        child:_image1 == null ? Icon(FontAwesomeIcons.plus): Image.file(_image1),
                      )
                  ),
                  GestureDetector(
                      onTap: (){
                        getImage2();
                      },
                      child: Container(
                        color: Colors.black12,
                        child:_image2 == null ? Icon(FontAwesomeIcons.plus): Image.file(_image2),
                      )
                  ),
                  GestureDetector(
                      onTap: (){
                        getImage3();
                      },
                      child: Container(
                        color: Colors.black12,
                        child:_image3 == null ? Icon(FontAwesomeIcons.plus): Image.file(_image3),
                      )
                  ),
                  GestureDetector(
                      onTap: (){
                        getImage4();
                      },
                      child: Container(
                        color: Colors.black12,
                        child:_image4 == null ? Icon(FontAwesomeIcons.plus): Image.file(_image4),
                      )
                  )
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top:20),

            child: Builder(
              builder: (context) => RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                highlightColor: Colors.blue[800],
                colorBrightness: Brightness.dark,
                elevation: 4.0,
                highlightElevation: 8.0,
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Text("POST"),
                onPressed: () {
                  _postItem();
                  final snackBar = SnackBar(
                    content: Text('A new item has been added!'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        _deleteItem();
                      },
                    ),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}