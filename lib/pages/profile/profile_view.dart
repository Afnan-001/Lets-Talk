import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/fetch_data/fetch_info.dart';
import 'package:login_page/fetch_data/update_info.dart';

// Pages
import 'package:login_page/pages/login_screen.dart';
import 'package:login_page/pages/profile/reset_password.dart';
import 'package:login_page/widgets/button.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  final _name = TextEditingController();
  final _about = TextEditingController();
  String? _email;

  @override
  void initState() {
    super.initState();
    _fetchEmail();
    _fetchUserName();
    _fetchAbout();
  }

  Future<void> _fetchEmail() async {
    String? email = await fetchEmail();
    if (email != null && email != 'null') {
      setState(() {
        _email = email; // Update the state with the fetched email
      });
    } else {
      setState(() {
        _email = 'No email available'; // Fallback message if email is null
      });
    }
  }

  // Fetching the username when the page is loaded
  Future<void> _fetchUserName() async {
    String? userName = await fetchUserName();
    if (userName != null && userName != 'null') {
      // if the username is not null set the fetched name to the controller
      _name.text = userName;
    }
  }

  Future<void> _fetchAbout() async {
    String? about = await fetchAbout();
    if (about != null && about != 'null') {
      _about.text = about;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _about.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Text(
                'A',
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _email ?? 'Loading...',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Name',
                border: OutlineInputBorder(),
                // hintText: 'Salman Khan',
              ),
              controller: _name,
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.info),
                labelText: 'About',
                border: OutlineInputBorder(),
                // hintText: "Hey, I'm using G-Chat!",
              ),
              controller: _about,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                updateUserProfile(context, _name.text, _about.text);
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'UPDATE',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Spacer(),
            CustomButton(
              label: "Reset Password",
              onPressed: () => _resetPassword(context),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => _logOut(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _resetPassword(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
  );
}

void _logOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    print('User signed out successfully');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  } catch (e) {
    print('Error signing out: $e');
  }
}
