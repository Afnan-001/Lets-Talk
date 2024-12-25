import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> fetchUserName() async {
  try {
    // Get the currently signed-in user
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('No user is signed in');
      return null;
    }

    // Fetching the user's document from the 'users' collection using their UID
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      // Access the 'name' field
      String? name = userDoc.get('name') as String?;
      return name;
    } else {
      print('User document does not exist');
      return null;
    }
  } catch (e) {
    print('Error fetching user name: $e');
    return null;
  }
}

Future<String?> fetchAbout() async {
  try {
    // Get the currently signed-in user
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('No user is signed in');
      return null;
    }

    // Fetching the user's document from the 'users' collection using their UID
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      // Access the 'about' field
      String? about = userDoc.get('about') as String?;
      return about;
    } else {
      print('User document does not exist');
      return null;
    }
  } catch (e) {
    print('Error fetching user name: $e');
    return null;
  }
}

Future<String?> fetchEmail() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('No user is signed in');
      return null;
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      
      String? email = userDoc.get('email') as String?;
      return email;
    } else {
      print('User document does not exist');
      return null;
    }
  } catch (e) {
    print('Error fetching user name: $e');
    return null;
  }
}

  Stream<List<String>> getUserNames() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.get('name') as String) // Get the 'name' field
            .toList());
  }


