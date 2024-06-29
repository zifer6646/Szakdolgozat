import 'package:dental_app/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:dental_app/read_data/get_user_name.dart';  // Ez csak egy példa, használd a megfelelő importálást az API függvényedhez

class YouChatPage extends StatefulWidget {
  @override
  _YouChatPageState createState() => _YouChatPageState();
}

class _YouChatPageState extends State<YouChatPage> {
 final TextEditingController _messageController = TextEditingController();
  List<String> _chatMessages = [];

  void _sendMessage(String message) async {
    setState(() {
      _chatMessages.add("You: $message");
    });

    try {
      var response = await sendMessageAndGetResponse(message);
      print('API Response: $response');  

      setState(() {
        _chatMessages.add("YouChat: $response");
      });    } catch (error) {
      setState(() {
        _chatMessages.add("YouChat: Error occurred: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouChat'),
        backgroundColor: titleColor,
        titleTextStyle: titleText,
      ),
      body: Container(
         decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDAE2F8), Color(0xFF9D50BB)],
        ),
      ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _chatMessages.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Align(
                      alignment: _chatMessages[index].startsWith("You:") ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: _chatMessages[index].startsWith("You:") ? Colors.blue : Colors.green,
                        ),
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Text(
                          _chatMessages[index],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      String message = _messageController.text.trim();
                      if (message.isNotEmpty) {
                        _sendMessage(message);
                        _messageController.clear();
                      }
                    },
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