import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'globals.dart' as globals;

void main() {
  runApp(MaterialApp(
    home: PlantDetails(),
  ));
}

class PlantDetails extends StatefulWidget {
  const PlantDetails({Key? key}) : super(key: key);

  @override
  State<PlantDetails> createState() => _PlantDetailsState();
}

class _PlantDetailsState extends State<PlantDetails> {
  List<Plant> plants = [];
  @override
  void initState() {
    super.initState();
    getPlantsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Plant details",
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
            _buildPlantList(),
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
            plants.isNotEmpty && plants[0].image != null
                ? Image.file(
                    File(plants[0].image),
                    width: 200,
                    height: 200,
                  )
                : Text('No image available'),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantList() {
    return Column(
      children: plants.map((plant) {
        return _buildPlantCard(plant);
      }).toList(),
    );
  }

Widget _buildPlantCard(Plant plant) {
  return SizedBox(
    width: 350,
    child: Column(
      children: <Widget>[
        _buildCardItem("Disease ", plant.disease, Icons.warning, FontWeight.bold),
        SizedBox(height: 16.0),
        _buildCardItem("Treatment" , plant.treatment, Icons.healing, FontWeight.normal),
      ],
    ),
  );
}
Widget _buildCardItem(String title, String text, IconData iconData, FontWeight fontWeight) {
  return Card(
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                iconData,
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
             
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: fontWeight,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}





  Future<void> getPlantsData() async {
    try {
      final List<Plant> fetchedPlants =
          await fetchPlants(globals.loggedInUsername);
      setState(() {
        plants = fetchedPlants;
      });
      print("eeeeee");
      print(plants.first.disease);
    } catch (error) {
      print('Error fetching plants: $error');
    }
  }

  Future<List<Plant>> fetchPlants(String userUsername) async {
    final response = await http.get(
      Uri.parse('http://192.168.56.1:3000/plants/$userUsername'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((plantJson) => Plant.fromJson(plantJson)).toList();
    } else {
      throw Exception('Failed to load plants');
    }
  }
}

class Plant {
  final String userUsername;
  final String image;
  final String disease;
  final String treatment;

  Plant({
    required this.userUsername,
    required this.image,
    required this.disease,
    required this.treatment,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      userUsername: json['UserUsername'],
      image: json['Image'],
      disease: json['Disease'],
      treatment: json['Treatment'],
    );
  }
}
