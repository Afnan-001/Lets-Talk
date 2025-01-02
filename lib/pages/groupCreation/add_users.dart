import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/pages/home_screen.dart';

class AddUsersPage extends StatefulWidget {
  final String groupName;
  final String groupDescription;

  const AddUsersPage({
    super.key,
    required this.groupName,
    required this.groupDescription,
  });

  @override
  State<AddUsersPage> createState() => _AddUsersPageState();
}

class _AddUsersPageState extends State<AddUsersPage> {
  final selectedUserIDs = <String>{}; // Track selected users

  // Fetch users with their IDs and names
  Stream<List<Map<String, dynamic>>> getUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'id': doc.id, // User document ID
                'name': doc.get('name') as String,
              };
            }).toList());
  }

  // Create a group in Firebase
  Future<void> createGroup() async {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to create group: User not logged in.')),
    );
    return;
  }

  // Add the admin's UID to the selectedUserIDs set
  selectedUserIDs.add(currentUser.uid);

  final groupData = {
    'admin': currentUser.uid, // Current user as admin
    'createdTime': FieldValue.serverTimestamp(),
    'description': widget.groupDescription,
    'name': widget.groupName,
    'userIDs': selectedUserIDs.toList(), // Include admin and selected users
  };

  try {
    await FirebaseFirestore.instance.collection('groups').add(groupData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Group created successfully!')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    ); // Navigate back after creation
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to create group: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Members to ${widget.groupName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: selectedUserIDs.isEmpty
                ? null
                : createGroup, // Only enabled if users are selected
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final isSelected = selectedUserIDs.contains(user['id']);
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(user['name'][0].toUpperCase()),
                  ),
                  title: Text(
                    user['name'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedUserIDs.add(user['id']);
                        } else {
                          selectedUserIDs.remove(user['id']);
                        }
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
