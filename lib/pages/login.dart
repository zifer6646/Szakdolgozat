// ignore_for_file: prefer_const_constructors

import 'package:dental_app/pages/guest_page.dart';
import 'package:dental_app/style/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscured = true; // Hozzáadjuk az _isObscured változó

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(), 
      password: _passwordController.text.trim()
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  Icon(
                    FontAwesomeIcons.tooth,
                    size: 120,  // Set the size of the icon
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Üdvözöllek újra!',
                    style: GoogleFonts.lato(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'A folytatáshoz jelentkezz be.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Email',
                        fillColor: Colors.grey[100],
                        filled: true,
                        prefixIcon: Icon(Icons.mail_lock_outlined),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextField(
            controller: _passwordController,
            obscureText: _isObscured,  // Ez a változó kezeli, hogy a jelszó látható-e
            decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintText: 'Jelszó',
        fillColor: Colors.grey[100],
        filled: true,
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
        
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ElevatedButton(
                      onPressed: signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Bejelentkezés',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 55.0),
          child: ElevatedButton(
            onPressed: () {
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GuestPage()),
        );
        // Add your onPressed code here
            },
            style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor, // Change this color if you want
        minimumSize: Size(double.infinity, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
            ),
            child: Text(
        'Folytatás vendégként', // Replace with your button text
        style: TextStyle(
          fontSize: 13,
          color: Colors.white,
        ),
            ),
          ),
        ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: widget.showRegisterPage,
                    child: Text(
                      'Regisztrálj most',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

