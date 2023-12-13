import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  final String text;
  final String sender;
  final bool isImage;

  const Messages(
      {super.key,
      required this.text,
      required this.sender,
      this.isImage = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                radius: 15,
                backgroundColor: sender == "user"
                    ? Theme.of(context).primaryColor
                    : Colors.blueGrey,
                child:
                    sender == "user" ? Icon(Icons.man) : Icon(Icons.computer)),
            Expanded(
              child: isImage
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        text,
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const CircularProgressIndicator.adaptive(),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        text.trim(),
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
