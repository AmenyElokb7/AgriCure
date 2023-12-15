import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'globals.dart' as globals;

void main() {
  runApp(MaterialApp(
    home: DiseaseDetection(),
  ));
}

class DiseaseDetection extends StatefulWidget {
  const DiseaseDetection({Key? key}) : super(key: key);

  @override
  State<DiseaseDetection> createState() => _DiseaseDetectionState();
}

class _DiseaseDetectionState extends State<DiseaseDetection> {
  String predictionTreatment = "";
  File? _image;
  late String predictionClass = "";
  bool detectButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Disease Detection",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(87, 130, 89, 1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildImageContainer(),
            SizedBox(height: 20),
            if (_image != null) ...[
              _buildDetectButton(),
              SizedBox(height: 20),
              _buildDiseaseCard(),
            ],
            SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer() {
    return SizedBox(
      width: 350,
      child: Card(
        child: Column(
          children: <Widget>[
            _image != null
                ? Image.file(
                    _image!,
                    width: 200,
                    height: 200,
                  )
                : Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/NoPicture.png',
                        width: 50,
                        height: 50,
                      ),
                      Text(
                        "No Picture Selected",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetectButton() {
    return ElevatedButton(
      onPressed: () async {
        await _Detect();
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
      ),
      child: Text(
        'Detect',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            await _openCamera();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
          child: Text(
            'Take from Camera',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: () async {
            await _openGallery();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.orange,
          ),
          child: Text(
            'Take from Gallery',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildDiseaseCard() {
    return SizedBox(
      width: 350,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12.0,
          ),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Disease: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red.shade900,
                      ),
                    ),
                    TextSpan(
                      text: '$predictionClass',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Treatment: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.green.shade900,
                      ),
                    ),
                    TextSpan(
                      text: '$predictionTreatment',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openCamera() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (image != null) {
      setState(() {
        _image = File(image.path);
        detectButtonPressed = false;
        predictionClass = "";
        predictionTreatment = "";
      });
      print('Camera Image path: ${image.path}');
    } else {
      print('No image selected from camera.');
    }
  }

  Future<void> _savePlantInfo(String UserUsername, String image, String disease,
      String treatment) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.196.191:3000/save-plant'),
        body: {
          'UserUsername': UserUsername,
          'Image': image,
          'Disease': disease,
          'Treatment': treatment,
        },
      );

      if (response.statusCode == 201) {
        print('Plant information saved successfully');
      } else {
        print('Failed to save plant information. Error ${response.statusCode}');
      }
    } catch (error) {
      print('Error saving plant information: $error');
    }
  }

  Future<void> _Detect() async {
    if (_image == null) {
      print('Please select an image before detecting.');
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.196.191:8000/predict'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        _image!.path,
      ),
    );
    print(request);
    print(_image!.path);

    try {
      final response = await request.send();
      print("response: $response");
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(await response.stream.bytesToString());

        final diseaseName = jsonResponse['class'] ?? "Unknown Disease";
        final treatment =
            jsonResponse['solution'] ?? "No Treatment Information";
        await _savePlantInfo(
            globals.loggedInUsername, _image!.path, diseaseName, treatment);

        setState(() {
          predictionClass = diseaseName;
          predictionTreatment = treatment;
          detectButtonPressed = true;
        });
      } else {
        print('Failed to upload image. Error ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading image: $error');
      print('Error type: ${error.runtimeType}');
    }
  }

  Future<void> _openGallery() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        detectButtonPressed = false;
        predictionClass = "";
        predictionTreatment = "";
      });
      print('Gallery Image path: ${image.path}');
    } else {
      print('No image selected from gallery.');
    }
  }
}
