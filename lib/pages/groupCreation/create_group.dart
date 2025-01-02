import 'package:flutter/material.dart';
import 'package:login_page/pages/groupCreation/add_users.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupDescriptionController = TextEditingController();
  String? profileImagePath; // Placeholder for a profile image path.
  String? groupNameError;
  String? groupDescriptionError;

  void validateAndNavigate() {
  setState(() {
    groupNameError = groupNameController.text.isEmpty ? "Group Name is required" : null;
    groupDescriptionError = groupDescriptionController.text.isEmpty ? "Group Description is required" : null;
  });

  if (groupNameError == null && groupDescriptionError == null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddUsersPage(
          groupName: groupNameController.text,
          groupDescription: groupDescriptionController.text,
        ),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create/Join Group"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // functionality to pick and update profile image goes here.
                    print("Profile image tapped");
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: profileImagePath != null
                        ? AssetImage(profileImagePath!)
                        : null,
                    child: profileImagePath == null
                        ? Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.grey[700],
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: groupNameController,
                        decoration: const InputDecoration(
                          labelText: "Group Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      if (groupNameError != null)
                        Text(
                          groupNameError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: groupDescriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Group Description",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10,),
                if (groupDescriptionError != null)
                  Text(
                    groupDescriptionError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: validateAndNavigate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text("Add Members"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    groupNameController.dispose();
    groupDescriptionController.dispose();
    super.dispose();
  }
}
