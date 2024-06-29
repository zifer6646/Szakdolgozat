// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dental_app/pages/account_page.dart';
import 'package:dental_app/pages/def.dart'; // A feltételezésem szerint ez a 'ReservationPage' valódi neve.
import 'package:dental_app/pages/message_page.dart';
import 'package:dental_app/pages/rateings_page.dart';
import 'package:dental_app/pages/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser!;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    ReservationPage(),
    YouChatPage(), // Assuming this is your chat page, please rename accordingly.
    SettingsPage(),
    RateDoctorsPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
          child: GNav(
            selectedIndex: _selectedIndex, // Corrected property name for selecting the index
            onTabChange: _navigateBottomBar, // Corrected method name for tab changes
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            padding: EdgeInsets.all(10),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Főoldal', // Translated to Hungarian
              ),
              GButton(
                icon: Icons.message,
                text: 'AI', // Translated to Hungarian
              ),
              GButton(
                icon: Icons.settings,
                text: 'Foglalások', // Translated to Hungarian
              ),
              GButton(
                icon: Icons.star_rate,
                text: 'Értékelések', // Translated to Hungarian and corrected spelling
              ),
              GButton(
                icon: Icons.person,
                text: 'Fiók', // Translated to Hungarian
              ),
            ],
          ),
        ),
      ),
    );
  }
}
