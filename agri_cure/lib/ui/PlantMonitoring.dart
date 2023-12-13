import 'package:agri_cure/ui/blue.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: PlantMonitoring(),
  ));
}

class PlantMonitoring extends StatefulWidget {
  const PlantMonitoring({Key? key}) : super(key: key);

  @override
  State<PlantMonitoring> createState() => _PlantMonitoringState();
}

class _PlantMonitoringState extends State<PlantMonitoring> {
  late DatabaseReference _databaseReference;
  late int humidityValue = 0;
  late int temperatureValue = 0;
  //late int moistureValue = 0;
  late String moisture = "";

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.reference();

    print("Database reference: $_databaseReference");

    _fetchData();
  }

  void _fetchData() {
    print("Fetching data...");
    _databaseReference.child('Sensor').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      print("Data under 'Sensor': ${snapshot.value}");
      if (snapshot.value != null) {
        humidityValue = (snapshot.child('humidity').value as int?) ?? 0;
        _updateHumidityValue(humidityValue);

        temperatureValue = (snapshot.child('temperature').value as int?) ?? 0;
        _updateTemperatureValue(temperatureValue);

        moisture = snapshot.child('moisture').value.toString();
        _updatemoistureValue(moisture);

        print("Humidity value: $humidityValue");
        print("Temperature value: $temperatureValue");
      } else {
        print("Values are null");
      }
    }).catchError((error) {
      print("Error fetching data: $error");
    });
  }

  void _updateHumidityValue(int newhumidityValue) {
    setState(() {
      humidityValue = newhumidityValue;
      print(humidityValue);
    });
  }

  void _updateTemperatureValue(int newTemperatureValue) {
    setState(() {
      temperatureValue = newTemperatureValue;
      print(temperatureValue);
    });
  }

  void _updatemoistureValue(String newMoistureeValue) {
    setState(() {
      moisture = '$newMoistureeValue';
      print(moisture);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          title: Text(
            "Plant Monitoring",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(87, 130, 89, 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PlantParameterCard(
              title: 'Plant Humidity',
              description:
                  'Relative percentage of water vapor present in plant',
              value: '$humidityValue N/A % : $moisture',
              icon: Icons.opacity,
            ),
            SizedBox(height: 16.0),
            PlantParameterCard(
              title: 'Plant Temperature',
              description:
                  'Weather parameter that measures how hot or cold the plant is',
              value: '$temperatureValue °C',
              icon: Icons.wb_sunny,
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => BluetoothOffScreen()));
            },
            mini: true,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.green.shade900,
          ),
        ),
      ),
    );
  }
}

class PlantParameterCard extends StatelessWidget {
  final String title;
  final String description;
  String value;
  final IconData icon;

  PlantParameterCard({
    required this.title,
    required this.description,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32.0),
                SizedBox(width: 8.0),
                Text(
                  title,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
