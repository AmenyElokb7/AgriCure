import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

class UserData {
  late String username;

  UserData({required this.username});
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

const String baseUrl = 'http://192.168.56.1:3000';

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserData> userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = fetchUserData();
  }

  Future<UserData> fetchUserData() async {
    try {
      print(globals.loggedInUsername);
      final response = await http.get(
        Uri.parse('$baseUrl/get-logged-in-user'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie': 'username=${globals.loggedInUsername}',
          'auth': '${globals.loggedInUsername}',
        },
      );

      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          final String authenticatedUsername = data['data']['username'];
          final UserData userData = UserData(username: authenticatedUsername);
          return userData;
        } else {
          print('Error: ${data['message']}');
          throw Exception(data['message']);
        }
      } else {
        print('Failed to fetch user data. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Error fetching user data');
    }
  }

  Future<void> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        print('Logout failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(87, 130, 89, 1),
        ),
      ),
      body: FutureBuilder<UserData>(
        future: userDataFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userData = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/user.jpg'),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    readOnly: true,
                    initialValue: userData.username,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    logout();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Color(0xff296e48), // Text color
                    side: BorderSide(color: Color(0xff296e48)), // Border color
                  ),
                  child: Text('Logout'),
                ),
                SizedBox(height: 20),
              ],
            );
          }
        },
      ),
    );
  }
}
