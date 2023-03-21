import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    home: Mypickimage(),
  ));
}
class Mypickimage extends StatefulWidget {
  const Mypickimage({Key? key}) : super(key: key);

  @override
  State<Mypickimage> createState() => _MypickimageState();
}

class _MypickimageState extends State<Mypickimage> {
  final ImagePicker _picker = ImagePicker();

  List<XFile> imagefile = [];


  List<String> imagedatalist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton.icon(
                onPressed: () async {
                  var pickdimaged = await _picker.pickMultiImage();
                  if (pickdimaged != null) {
                    setState(() {
                      imagefile = pickdimaged;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("No Image Select")));
                  }
                },
                icon: Icon(Icons.photo),
                label: Text("Gallery")),
            Divider(),
            imagefile != null
                ? Wrap(
                children: imagefile.map((imageee) {
                  return CircleAvatar(
                    maxRadius: 60,
                    backgroundImage: FileImage(File(imageee.path)),
                  );
                }).toList())
                : Container(),
            ElevatedButton(
                onPressed: () async {
                  for (int i = 0; i < imagefile.length; i++) {
                    List<int> barray = File(imagefile[i].path).readAsBytesSync();
                    String img = base64Encode(barray);
                    setState(() {
                      imagedatalist.add(img);
                    });
                  }
                  print("==$imagedatalist");

                  Map addmultiimage = {
                    "userid" : "50",
                    "imgdata_list":"$imagedatalist",
                    "total_img" : "${imagedatalist.length}"
                  };

                  var url = Uri.parse('https://januflutter.000webhostapp.com/shopping/Addmultiimage.php');
                  var response = await http.post(url, body: addmultiimage);
                  print('Response status: ${response.statusCode}');
                  print('=== >Response body: ${response.body}');

                },
                child: Text("Add Product"))
          ],
        ),
      ),
    );
  }
}
