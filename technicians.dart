import 'package:Smartmeter/chattech.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TechniciansPage extends StatefulWidget {
  @override
  _TechniciansPageState createState() => _TechniciansPageState();
}

class _TechniciansPageState extends State<TechniciansPage> {
  // Fetch all conversations and map userId to user fullName
  Future<List<Map<String, dynamic>>> fetchConversations() async {
    List<Map<String, dynamic>> conversationsList = [];
    try {
      // Get all conversations from the "conversations" collection
      final querySnapshot =
          await FirebaseFirestore.instance.collection('conversations').get();

      // For each conversation, we will fetch the userId and their fullName
      for (var doc in querySnapshot.docs) {
        String userId = doc['userId'];

        // Fetch the fullName from the "users" collection using userId
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          String fullName = userDoc['fullName'] ?? 'No Name';
          conversationsList.add({
            'userId': userId,
            'fullName': fullName,
            'lastMessage': doc['lastMessage'],
            'lastMessageTimestamp': doc['lastMessageTimestamp'],
          });
        }
      }
    } catch (e) {
      print("Error fetching conversations: $e");
    }
    return conversationsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background to white

      appBar: AppBar(
        backgroundColor: Colors.white, // Set the background to white

        title: Text('Technicians Conversations'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchConversations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No conversations found.'));
          }

          // Get the list of conversations
          List<Map<String, dynamic>> conversations = snapshot.data!;

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              var conversation = conversations[index];
              String fullName = conversation['fullName'];
              String userId = conversation['userId'];
              String lastMessage = conversation['lastMessage'];
              Timestamp lastMessageTimestamp =
                  conversation['lastMessageTimestamp'];

              // Formatting the timestamp (you can adjust this format as needed)
              String formattedTimestamp =
                  lastMessageTimestamp.toDate().toString();

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow direction
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets
                      .zero, // Removes internal padding for better alignment
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      fullName[0].toUpperCase(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    fullName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last message: $lastMessage',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      Text(
                        'Sent at: $formattedTimestamp',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Navigate to the ChatTech page when clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatTech(
                          userId: userId,
                          societyId:
                              '10', // Example societyId, replace with actual value if needed
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
