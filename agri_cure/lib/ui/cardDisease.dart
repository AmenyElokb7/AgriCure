import 'package:agri_cure/ui/PlantDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'globals.dart' as globals;

// void main() {
//   runApp(MaterialApp(
//     home: CardDisease(),
//   ));
// }

class CardDisease extends StatefulWidget {
  CardDisease({Key? key}) : super(key: key);

  @override
  State<CardDisease> createState() => _CardDiseasesState();
}

class _CardDiseasesState extends State<CardDisease> {
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
            _buildImageCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCards() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        Plant plant = plants[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantDetails(plantId: plant.plantId),
              ),
            );
          },
          child: Card(
            child: Image.file(
              File(plant.image),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
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
    } catch (error) {
      print('Error fetching plants: $error');
    }
  }

  Future<List<Plant>> fetchPlants(String userUsername) async {
    final response = await http.get(
      Uri.parse('http://192.168.196.191:3000/plants/$userUsername'),
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
  final String plantId;
  final String userUsername;
  final String image;

  Plant({
    required this.plantId,
    required this.userUsername,
    required this.image,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      plantId: json['_id'],
      userUsername: json['UserUsername'],
      image: json['Image'],
    );
  }
}

class PlantDetail extends StatelessWidget {
  final String plantId;

  PlantDetail({required this.plantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plant Detail"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Plant ID: $plantId"),
            // Add more details here based on the plant ID
          ],
        ),
      ),
    );
  }
}
