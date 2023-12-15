import 'package:agri_cure/ui/CreatePlanting.dart';
import 'package:agri_cure/ui/View%20Planting.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ManagePlanting(),
  ));
}

class ManagePlanting extends StatefulWidget {
  const ManagePlanting({Key? key}) : super(key: key);

  @override
  State<ManagePlanting> createState() => _ManagePlantingState();
}

class _ManagePlantingState extends State<ManagePlanting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          title: Text(
            "Manage Planting",
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
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage('assets/images/background.png'),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(50),
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Image.asset(
                                    'assets/images/tomate.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreatePlanting()),
                                );
                              },
                              child: Text(
                                "View Planting",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(50),
                    //   child: Card(
                    //     child: Column(
                    //       children: <Widget>[
                    //         Row(
                    //           children: <Widget>[
                    //             Expanded(
                    //               child: Image.asset(
                    //                 'assets/images/viewPlanting.webp',
                    //                 fit: BoxFit.cover,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         GestureDetector(
                    //           onTap: () {
                    //             Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => ViewPlanting()),
                    //             );
                    //           },
                    //           child: Text(
                    //             "View Planting",
                    //             style: TextStyle(
                    //               fontSize: 20,
                    //               color: Colors.black,
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           width: 300,
                    //           height: 40,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
