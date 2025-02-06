import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Smartmeter/models/messages.dart'; // Assuming you have a Message model
import 'package:Smartmeter/controller/controller.dart'; // Assuming the sendMessage function is here

class ChatTech extends StatefulWidget {
  final String userId;
  final String societyId;

  ChatTech({required this.userId, required this.societyId});

  @override
  _ChatTechState createState() => _ChatTechState();
}

class _ChatTechState extends State<ChatTech> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  // Method to send a message from the society
  void _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Send message from society to user
      await sendMessage(
        userId: widget.userId, // The message receiver is the user
        societyId: widget.societyId, // The message sender is the society
        text: text, SenderID: widget.societyId,
      );
      _controller.clear(); // Clear the input field after sending the message
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background to white
      appBar: AppBar(
        backgroundColor: Colors.white, // Set AppBar background to white
        elevation: 0, // Remove shadow from AppBar
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("images/logoapp.jpg"),
              radius: 20.0,
            ),
            SizedBox(width: 10),
            Text(
              "Society Chat",
              style: TextStyle(
                  color: Colors.black), // Set text color to black for contrast
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: getMessages(
                  userId: widget.userId, societyId: widget.societyId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No messages found.'));
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    bool isUserMessage = message.senderId == widget.societyId;

                    return ChatBubble(
                      message: message,
                      isUserMessage: isUserMessage,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed:
                      _isLoading ? null : () => _sendMessage(_controller.text),
                  child: Icon(Icons.send),
                  backgroundColor:
                      Colors.blue, // Blue background for send button
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isUserMessage;

  const ChatBubble({required this.message, required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    final alignment =
        isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isUserMessage ? Colors.blue : Colors.grey.shade300;
    final textColor = isUserMessage ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.message,
                  style: TextStyle(color: textColor),
                ),
                SizedBox(height: 4),
                Text(
                  message.timestamp
                      .toString(), // Assuming you have a timestamp field
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
