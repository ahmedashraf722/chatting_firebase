import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controller = TextEditingController();
  String _enteredMessage = "";

  _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userName': userData['userName'],
      'userId': user.uid,
      'userImage': userData['image_url'],
    });
    _controller.clear();
    setState(() {
      _enteredMessage = "";
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            SizedBox(width: 3),
            Expanded(
              child: TextField(
                autocorrect: true,
                enableSuggestions: true,
                textCapitalization: TextCapitalization.sentences,
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Send a message.... ",
                ),
                onChanged: (val) {
                  setState(() {
                    _enteredMessage = val;
                  });
                },
              ),
            ),
            Transform.translate(
              offset: Offset(0, 10),
              child: IconButton(
                color: Theme.of(context).primaryColor,
                disabledColor: Colors.grey,
                icon: Icon(Icons.send),
                onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
