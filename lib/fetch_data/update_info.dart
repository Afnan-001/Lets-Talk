import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> updateUserProfile(BuildContext context,String name, String about) async {
  try {
   
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('No user is signed in');
      return;
    }

    // Updating the user's document in the 'users' collection
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'name': name,
      'about': about,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile info Updated'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    print('Error updating user profile: $e');
  }
}
