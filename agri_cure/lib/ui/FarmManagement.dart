import 'dart:developer';

import 'package:agri_cure/constants.dart';
import 'package:agri_cure/ui/Manage%20Planting.dart';
import 'package:agri_cure/ui/chat.dart';
import 'package:floating_chat_button/floating_chat_button.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: FarmManagement(),
  ));
}

class FarmManagement extends StatefulWidget {
  const FarmManagement({Key? key}) : super(key: key);

  @override
  State<FarmManagement> createState() => _FarmManagementState();
}

class _FarmManagementState extends State<FarmManagement> {
  var temperature;
  var actualCondition;
  var place = "";

  @override
  void initState() {
    super.initState();
    fetchWeather(place);
  }

  Future<void> fetchWeather(String location) async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?appid=b3db578458e199bfda327ec5ba3b3178&lang=fr&q=$location'));

    if (response.statusCode == 200) {
      setState(() {
        actualCondition = json.decode(response.body)['weather'][0]['main'];
        temperature =
            ((json.decode(response.body)['main']['temp']) - 273.15).round();
      });
    } else {
      throw Exception("Failed to get weather data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          title: Text(
            "Farm Management",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(87, 130, 89, 1),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 350,
                          height: 100,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 12.0,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/loupe.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          place = value;
                                        });
                                        fetchWeather(value);
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Enter location',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 350,
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Temperature\n",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/low-temperature-icon.webp',
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                  "$temperature°C",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 300,
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 350,
                          height: 100,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 12.0,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/plants.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ManagePlanting()),
                                        );
                                      },
                                      child: Text(
                                        "Manage Planting",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      


    );
  }
}
