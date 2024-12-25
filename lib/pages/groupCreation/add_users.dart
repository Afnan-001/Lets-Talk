import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/fetch_data/fetch_info.dart';

class AddUsersPage extends StatefulWidget {
  const AddUsersPage({super.key});

  @override
  State<AddUsersPage> createState() => _AddUsersPage();
}

class _AddUsersPage extends State<AddUsersPage> {
  final user = FirebaseAuth.instance.currentUser!;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Users'),
      ),
      body: StreamBuilder<List<String>>(
        stream: getUserNames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            final userNames = snapshot.data!;
            return ListView.builder(
              itemCount: userNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    child: Text('A'),
                  ),
                  title: Text(
                    userNames[index],
                    style: const TextStyle(color: Colors.white),
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
