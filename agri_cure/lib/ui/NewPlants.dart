import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ArticleDetails.dart';

class NewsPlants extends StatefulWidget {
  @override
  _NewsPlantsState createState() => _NewsPlantsState();
}

class _NewsPlantsState extends State<NewsPlants> {
  late List<dynamic> _newsList = [];

  @override
  void initState() {
    super.initState();
    fetchNewsData();
  }

  Future<void> fetchNewsData() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=plants%20vegetables&apiKey=8f743d747a284cd599c4844c370e874f'));
    if (response.statusCode == 200) {
      setState(() {
        _newsList = jsonDecode(response.body)['articles'];
      });
    } else {
      throw Exception('Failed to load news data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "News Plants",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(87, 130, 89, 1),
      ),
      body: _newsList != null
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _newsList.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildCard(context, _newsList[index]);
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildCard(BuildContext context, dynamic article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetails(
                title: article['title'] ?? 'Title not available',
                description:
                    article['description'] ?? 'Description not available',
                author: article['author'] ?? 'Author not available',
                picture: article['urlToImage'] ?? '',
                datePublish:
                    article['publishedAt'] ?? 'Publish Date not available',
                source: article['source']['name'] ?? 'Source not available'),
          ),
        );
      },
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                article['urlToImage'] ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/interdit.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    child: Text(
                      article['title'] ?? 'Title not available',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 40,
                    child: Text(
                      article['description'] ?? 'Description not available',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 20,
                    child: Text(
                      article['author'] ?? 'Author not available',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    child: Text(
                      article['publishedAt'] ?? 'Date not available',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    child: Text(
                      article['source']['name'] ?? 'Source not available',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
