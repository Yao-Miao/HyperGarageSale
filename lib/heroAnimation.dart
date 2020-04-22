import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///The dart class to realize Hero Animation function
class PhotoHero extends StatelessWidget {
  const PhotoHero({ Key key, this.imagePath, this.onTap, this.width,this.storage }) : super(key: key);

  final String imagePath;
  final VoidCallback onTap;
  final double width;
  final FirebaseStorage storage;

  Future<dynamic> loadImage(String imagePath) async {
    return await storage.ref().child(imagePath).getDownloadURL();
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

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: imagePath,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: _getImageWidget(context,imagePath)
          ),
        ),
      ),
    );
  }
}

class HeroAnimation extends StatelessWidget {
  final FirebaseStorage _storage = FirebaseStorage(storageBucket:'gs://neu-spring2020.appspot.com');
  String imagePath;
  HeroAnimation(String imagePath){
    this.imagePath = imagePath;
  }
  Widget build(BuildContext context) {
    timeDilation = 2.0; // 1.0 means normal animation speed.
    return PhotoHero(
          imagePath: this.imagePath,
          storage: _storage,
          width: 100.0,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    body: Container(
                      // Set background to blue to emphasize that it's a new route.
                      color: Colors.black,
                      padding: const EdgeInsets.all(10.0),
                      alignment: Alignment.center,
                      child: PhotoHero(
                        imagePath: this.imagePath,
                        storage: _storage,
                        width: 400.0,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                }
            ));
          },
    );
  }
}
