// ignore_for_file: prefer_const_constructors

import 'package:dental_app/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

// Modell a felhasználó adatainak tárolására és frissítésére
class UserData {
  final String firstName;
  final String lastName;
  final String email;
  final int age;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.age,
  });

  // Konvertálás mappába Firebase-hez
  Map<String, dynamic> toMap() {
    return {
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'age': age,
    };
  }
}

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late User? user;
  late UserData? currentUserData;
  bool isLoading = true;

  // Controller-ek a szerkeszthető mezők számára
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadCurrentUserData();
  }

  // Metódus a felhasználó adatok betöltésére az email cím alapján
  Future<void> _loadCurrentUserData() async {
    try {
      QuerySnapshot usersQuery = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: user!.email).get();

      if (usersQuery.docs.isNotEmpty) {
        DocumentSnapshot userDataSnapshot = usersQuery.docs.first;
        setState(() {
          currentUserData = UserData(
            firstName: userDataSnapshot['first name'],
            lastName: userDataSnapshot['last name'],
            email: userDataSnapshot['email'],
            age: userDataSnapshot['age'],
          );
          isLoading = false; // Megállítjuk a betöltést, mert adataink megérkeztek
          
          // Adatok beállítása a mezőkbe
          _firstNameController.text = currentUserData!.firstName;
          _lastNameController.text = currentUserData!.lastName;
          _ageController.text = currentUserData!.age.toString();
        });
      }
    } catch (e) {
      print('Error retrieving current user data: $e');
      setState(() {
        isLoading = false; // Hiba esetén is megállítjuk a betöltést
      });
    }
  }

// Metódus a felhasználó adatok frissítésére a Firestore-ban
Future<void> _updateUserDataInFirestore(UserData newData) async {
  try {
    // Felhasználó UID-jének lekérése
    String userUid = user!.uid;
    
    // Dokumentum referencia létrehozása a Firestore-ban
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userUid);
    
    // Dokumentum frissítése az új adatokkal
    await userDocRef.update(newData.toMap());
  } catch (e) {
    print('Error updating user data: $e');
  }
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Felhasználói adatok'),
        backgroundColor: titleColor,
        titleTextStyle: titleText,
    ),
        body: Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDAE2F8), Color(0xFF9D50BB)],
        ),
      ),
    child: isLoading
        ? Center(child: CircularProgressIndicator())
        : currentUserData == null
            ? Center(child: Text('No user data found.'))
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  labelText: 'Családnév',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  labelText: 'Keresztnév',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _ageController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Életkor',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.cake),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          UserData newData = UserData(
                            firstName: _firstNameController.text.trim(),
                            lastName: _lastNameController.text.trim(),
                            email: currentUserData!.email,
                            age: int.parse(_ageController.text.trim()),
                          );
                          _updateUserDataInFirestore(newData);
                        },
                        child: Text('Mentés'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color?>(titleColor),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12, horizontal: 50)),
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18)),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),  // Itt adjuk meg, hogy a szöveg színe fehér legyen
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(titleColor),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12, horizontal: 50)),
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18)),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),  // Itt adjuk meg, hogy a szöveg színe fehér legyen
                        ),
                        child: Text('Kijelentkezés'),
                      ),
                    ],
                  ),
                ),
              ),
        ),
  );
}
}