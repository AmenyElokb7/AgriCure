import 'package:agri_cure/ui/FarmManagement.dart';
import 'package:agri_cure/ui/Manage%20Planting.dart';
import 'package:agri_cure/ui/PlantDetails.dart';
import 'package:agri_cure/ui/PlantMonitoring.dart';
import 'package:agri_cure/ui/chat.dart';
import 'package:agri_cure/ui/disease%20Detection.dart';
import 'package:agri_cure/ui/home.dart';
import 'package:agri_cure/ui/profile.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    FarmManagement(),
    PlantMonitoring(),
    DiseaseDetection(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color.fromARGB(255, 40, 103, 3),
              width: 3.0, // Set the border width
            ),
            color: Color.fromARGB(255, 40, 103, 3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image(
              image: AssetImage("assets/images/chatbot.jpg"),
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/project-management .png"),
              size: 24,
            ),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/930493-200.png"),
              size: 24,
            ),
            label: 'Monitor',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/loupeNav.png"),
              size: 24,
            ),
            label: 'Detect',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/me.png"),
              size: 24,
            ),
            label: 'Profil',
          ),
        ],
        selectedIconTheme: IconThemeData(color: Color.fromRGBO(87, 130, 89, 1)),
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        selectedLabelStyle: TextStyle(color: Color.fromRGBO(87, 130, 89, 1)),
        unselectedLabelStyle: TextStyle(color: Color.fromRGBO(87, 130, 89, 1)),
        selectedItemColor: Color.fromRGBO(87, 130, 89, 1),
        unselectedItemColor: Colors.red,
      ),
    );
  }
}
