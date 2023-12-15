import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:agri_cure/ui/consts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(
        seconds: 200,
      ),
    ),
    enableLog: true,
  );

  final ChatUser _currentUser = ChatUser(
    id: '1',
    firstName: 'Hussain',
    lastName: 'Mustafa',
    profileImage: "assets/images/user.png",
  );

  final ChatUser _gptChatUser = ChatUser(
    id: '2',
    firstName: 'Agri',
    lastName: 'Cure',
    profileImage: "assets/images/chatbot.jpg",
  );
  bool _isFirstOpen = true;
  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];
  @override
  void initState() {
    super.initState();
    if (_isFirstOpen) {
      _isFirstOpen = false;
      _displayWelcomeMessage();
    }
  }

  void _displayWelcomeMessage() {
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          user: _gptChatUser,
          createdAt: DateTime.now(),
          text:
              "Hi, I'm AgriCure and I can tell you anything about tomato, potato, and pepper.",
        ),
      );
    });
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });

    List<Messages> _messagesHistory = _messages.reversed.map((m) {
      if (m.user == _currentUser) {
        return Messages(role: Role.user, content: m.text);
      } else {
        return Messages(role: Role.assistant, content: m.text);
      }
    }).toList();

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: _messagesHistory,
      maxToken: 800,
    );

    final response = await _openAI.onChatCompletion(request: request);

    for (var element in response!.choices) {
      if (element.message != null) {
        final chatMessage = ChatMessage(
          user: _gptChatUser,
          createdAt: DateTime.now(),
          text: element.message!.content,
        );

        if (_containsKeyword(chatMessage.text)) {
          setState(() {
            _messages.insert(0, chatMessage);
          });
        } else {
          setState(() {
            _messages.insert(
              0,
              ChatMessage(
                user: _gptChatUser,
                createdAt: DateTime.now(),
                text:
                    "I'm sorry, I don't understand that. I can tell you more about tomato, potato, and pepper.",
              ),
            );
          });
        }
      }
    }

    setState(() {
      _typingUsers.remove(_gptChatUser);
    });
  }

  bool _containsKeyword(String text) {
    final keywords = ['tomato', 'potato', 'pepper'];
    for (var keyword in keywords) {
      if (text.toLowerCase().contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Add your image here
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.transparent,
                child: Image.asset(
                  'assets/images/chatbot.jpg',
                  height: 30,
                  width: 30,
                ),
              ),
            ),
            Text(
              "AgriCure Bot",
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: DashChat(
        currentUser: _currentUser,
        typingUsers: _typingUsers,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.black,
          containerColor: Color(0xff296e48),
          textColor: Colors.white,
        ),
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        messages: _messages,
      ),
    );
  }
}
