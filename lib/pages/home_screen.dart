import 'package:flutter/material.dart';

// Firebase Services
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Pages
import 'package:login_page/pages/groupCreation/create_group.dart';
import 'package:login_page/pages/profile/profile_view.dart';
import 'package:login_page/pages/groupCreation/chat_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // Fetch groups for the current user
  Stream<List<Map<String, dynamic>>> fetchUserGroups() {
    return FirebaseFirestore.instance
        .collection('groups')
        .where('userIDs', arrayContains: user.uid) // Check if the user is part of the group
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'id': doc.id,
                'name': doc.get('name') as String,
              };
            }).toList());
  }

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
              // Navigate to the user profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfilePage()),
              );
            },
          ),
        ],
      ),
      drawer: const Drawer(),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: fetchUserGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No groups found.' , style: TextStyle(color: Colors.white),));
          } else {
            final groups = snapshot.data!;
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Text('G'),
                  ),
                  title: Text(
                    group["name"] ?? "",
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
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
            );
          }
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


