import 'package:flutter/material.dart';

// Pages
import 'package:login_page/pages/groupCreation/create_group.dart';
import 'package:login_page/pages/profile/profile_view.dart';

class HomePage extends StatelessWidget {
  // Example groups list, replace with Firebase data
  final List<Map<String, String>> groups = [
    {"name": "College Friends", "id": "group1"},
    {"name": "Study Group", "id": "group2"},
    {"name": "WCE 2025", "id": "group3"},
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(69, 116, 157, 1.0),
        toolbarHeight: 80,
        centerTitle: true,
        title: const Text("Groups"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to the group Profile Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfilePage()),
              );
            },
          ),
        ],
      ),
      drawer: const Drawer(),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return ListTile(
            leading: const CircleAvatar(
              child: Text('G'),
            ),
            title: Text(group["name"] ?? "" , style: const TextStyle(fontSize: 20 , color: Colors.white),),
            onTap: () {
              // Navigate to the group chat page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(groupId: group["id"] ?? ""),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.group_add),
        onPressed: () {
          // Navigate to the group creation/join page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateGroupPage()),
          );
        },
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  final String groupId;

  const ChatPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Page"),
      ),
      body: Center(
        child: Text("Chat UI for group $groupId goes here."),
      ),
    );
  }
}
