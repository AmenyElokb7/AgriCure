import 'package:agri_cure/ui/Manage%20Planting.dart';
import 'package:flutter/material.dart';



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

  var nbrePlants;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(120),
        child:AppBar(
          title:
          Text(
            "Create Planting",
            style: TextStyle(
              color: Colors.white,
            ),
          ),


          centerTitle: true,
          backgroundColor: Color.fromRGBO(87, 130, 89, 1),

        ),
      ),


      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child:Padding(padding: EdgeInsets.all(50),
                    child:Column(
    children: <Widget>[

    Center(
    child:
    SizedBox(
    width:300,
    child: Card(
    child:Center(child:ListPlants()),
    ),
    ),

    ),
    Center(
    child:
    SizedBox(
    width:300,
    child: Card(
    child:Center(child:TextField(
    onChanged: (value) {
    setState(() {
    nbrePlants = value;
    });
    },
    decoration: InputDecoration(
    hintText: 'Enter number of plants',
    border: InputBorder.none,
    ),
    keyboardType: TextInputType.number,
    ),),
    ),
    ),
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children:<Widget> [
    ElevatedButton(
    onPressed: () {

    },
    style: ElevatedButton.styleFrom(
    primary: Colors.green,
    onPrimary: Colors.white,
    ),
    child: Text('Add Plant'),
    ),
    ],

    ),
    SizedBox(width: 120,),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children:<Widget> [
    ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder:(context) =>ManagePlanting()),
      );
    },
    style: ElevatedButton.styleFrom(
    primary: Colors.red,
    onPrimary: Colors.white,
    ),
    child: Text('Cancel'),
    ),
    ],

    ),
    ],
    ),
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListPlants extends StatefulWidget {
  @override
  _ListPlantsState createState() => _ListPlantsState();
}

class _ListPlantsState extends State<ListPlants> {
  String dropdownValue = 'Tomato';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Tomato', 'Potato', 'Pepper']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}