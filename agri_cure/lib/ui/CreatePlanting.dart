import 'dart:convert';
import 'package:agri_cure/ui/PlantDetails.dart';
import 'package:agri_cure/ui/cardDisease.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

void main() {
  runApp(MaterialApp(
    home: CreatePlanting(),
  ));
}

class CreatePlanting extends StatefulWidget {
  const CreatePlanting({Key? key}) : super(key: key);

  @override
  State<CreatePlanting> createState() => _CreatePlantingState();
}

class _CreatePlantingState extends State<CreatePlanting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          title: Text(
            "Create Planting",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(87, 130, 89, 1),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(15),
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/images/background.png'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          children: [
            _buildPlantCard(context, 'Tomato', 'assets/images/tomate.png'),
            _buildPlantCard(context, 'Pepper', 'assets/images/pepper.png'),
            _buildPlantCard(context, 'Potato', 'assets/images/potato.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantCard(
      BuildContext context, String plantName, String imagePath) {
    return SizedBox(
      height: 150,
      width: 150,
      child: GestureDetector(
        onTap: () {
          // _showAddPlantDialog(context, plantName);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CardDisease()),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
          ),
          color: Colors.white,
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Text(
                  plantName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _showAddPlantDialog(BuildContext context, String plantName) {
  //   TextEditingController _plantController = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Add $plantName'),
  //         content: StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //             return Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 TextField(
  //                   controller: _plantController,
  //                   keyboardType: TextInputType.number,
  //                   decoration:
  //                       InputDecoration(labelText: 'Number of $plantName'),
  //                 ),
  //                 SizedBox(height: 10),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       style: ButtonStyle(
  //                         backgroundColor: MaterialStateProperty.all<Color>(
  //                           Colors.red,
  //                         ),
  //                         foregroundColor: MaterialStateProperty.all<Color>(
  //                           Color.fromRGBO(255, 255, 255, 1.0),
  //                         ),
  //                       ),
  //                       child: Text('Cancel'),
  //                     ),
  //                     ElevatedButton(
  //                       onPressed: () async {
  //                         if (_plantController.text.isEmpty) {
  //                           showDialog(
  //                             context: context,
  //                             builder: (BuildContext context) {
  //                               return AlertDialog(
  //                                 title: Text('Error'),
  //                                 content: Text(
  //                                     'Please enter the number of $plantName'),
  //                                 actions: <Widget>[
  //                                   TextButton(
  //                                     onPressed: () {
  //                                       Navigator.of(context).pop();
  //                                     },
  //                                     child: Text('OK'),
  //                                   ),
  //                                 ],
  //                               );
  //                             },
  //                           );
  //                         } else {
  //                           final apiUrl =
  //                               Uri.parse('http://10.0.2.2:8081/addPlant');
  //                           final plantData = {
  //                             'category': plantName,
  //                             'number': int.parse(_plantController.text),
  //                             'UserUsername': globals.loggedInUsername
  //                           };

  //                           final response = await http.post(
  //                             apiUrl,
  //                             body: json.encode(plantData),
  //                             headers: {'Content-Type': 'application/json'},
  //                           );

  //                           if (response.statusCode == 201) {
  //                             print('Plant added successfully');
  //                             Navigator.of(context).pop();
  //                           } else {
  //                             Navigator.of(context).pop();
  //                             print(
  //                                 'Failed to add plant. Error: ${response.body}');
  //                           }
  //                         }
  //                       },
  //                       style: ButtonStyle(
  //                         backgroundColor: MaterialStateProperty.all<Color>(
  //                           Color.fromRGBO(87, 130, 89, 1),
  //                         ),
  //                         foregroundColor: MaterialStateProperty.all<Color>(
  //                           Color.fromRGBO(255, 255, 255, 1.0),
  //                         ),
  //                       ),
  //                       child: Text('Add'),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }
}
