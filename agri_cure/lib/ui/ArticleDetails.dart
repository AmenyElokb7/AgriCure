import 'dart:math';

import 'package:flutter/material.dart';

class ArticleDetails extends StatelessWidget {
  final String title;
  final String description;
  final String author;
  final String picture;
  final String datePublish;
  final String source;
  ArticleDetails({
    required this.title,
    required this.description,
    required this.author,
    required this.picture,
    required this.datePublish,
    required this.source
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text(
          "News Details",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(87, 130, 89, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              picture,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Image.asset(
                  'assets/interdit.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Author: $author',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              datePublish,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),

            ),
            Text(
              source,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}