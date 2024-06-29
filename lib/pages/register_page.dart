// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_app/style/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage( {Key? Key,required this.showLoginPage,}) : super(key: Key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controls

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firtsNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  bool _isObscured = true; // Hozzáadjuk az _isObscured változó

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _lastNameController.dispose();
    _firtsNameController.dispose();
    super.dispose();
  }
  
Future singUp() async{
  try {
    // Felhasználó létrehozása az authentikációban
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Felhasználó adatainak hozzáadása a Firestore adatbázishoz
    await addUserDetails(
      _firtsNameController.text.trim(),
      _lastNameController.text.trim(),
      _emailController.text.trim(),
      int.parse(_ageController.text.trim()),
      userCredential.user!.uid, // Használjuk az auth során kapott UID-t
    );
  } catch (e) {
    print('Error during registration: $e');
    // Kezeljük a hibát, például jelenítsünk meg egy üzenetet a felhasználónak
  }
}

Future addUserDetails(String firstName, String lastName, String email, int age, String uid) async{
  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    'first name' : firstName,
    'last name' : lastName,
    'email' : email,
    'age' : age,
    // Használjuk az auth során kapott UID-t a dokumentum azonosítójaként
  });
}


  @override
  Widget build(BuildContext context) {
 return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
         decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDAE2F8), Color(0xFF9D50BB)],
        ),
      ),
        child: SafeArea(
          child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.tooth,
                  size: 80,
                ),
                Text(
                  'Regisztráció',
                  style: GoogleFonts.bebasNeue(
                    fontSize:40,
                  ),
                  ),
             //first name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75.0),
                    child: TextField(
                      controller: _firtsNameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                        ),
                       focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10),
                       ),
                       hintText: 'Családi név',
                       fillColor: Colors.grey[200],
                       filled: true,
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10), // Bal, Fel, Jobb, Le
                      ),
                    ),
                  ),
            
                  SizedBox(height: 5),
                   //last name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75.0),
                    child: TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                        ),
                       focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                       ),
                       hintText: 'Keresztnév',
                       fillColor: Colors.grey[200],
                       filled: true,
                       contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10), // Bal, Fel, Jobb, Le
                      ),
                    ),
                  ),
            
                  SizedBox(height: 5),
                   //age
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75.0),
                    child: TextField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                        ),
                       focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                       ),
                       hintText: 'Életkor',
                       fillColor: Colors.grey[200],
                       filled: true,
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10), // Bal, Fel, Jobb, Le                     
                      ),
                    ),
                  ),
            
                  SizedBox(height: 5),
            //email
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                        ),
                       focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                       ),
                       hintText: 'Email',
                       fillColor: Colors.grey[200],
                       filled: true,
                       prefixIcon: Icon(Icons.mail_lock_outlined),
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10), // Bal, Fel, Jobb, Le
                      ),
                    ),
                  ),
            
                  SizedBox(height: 5),
                 
                 //password
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 75.0),
          child: TextField(
            obscureText: _isObscured,  // Az _isObscured változó használata, hogy dinamikusan kezelje a jelszó láthatóságát
            controller: _passwordController,
            decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: 'Jelszó',
        fillColor: Colors.grey[200],
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),  // Bal, Fel, Jobb, Le
        prefixIcon: Icon(Icons.lock_outline),  // Kulcs ikon a bal oldalon
        suffixIcon: IconButton(  // Szem ikon a jobb oldalon
          icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;  // Átváltás a láthatóság állapotok között
            });
          },
        ),
            ),
          ),
        ),
        
            
                  SizedBox(height: 5),
            
            //Sing in buttton
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75.0),
                    child: GestureDetector(
                      onTap: singUp,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Regisztráció',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              ),
                              
                            ),
                        ),
                      ),
                    ),
                  ),
            
                  SizedBox(height: 5),
            
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Már van fiókod?  ', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        ),
                        ),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: Text('Jelentkezbe itt!', 
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          ),
                          ),
                      )
                    ],
                  )
            
            ],),
          ),
        ),
        ),
      )
       );  }
}