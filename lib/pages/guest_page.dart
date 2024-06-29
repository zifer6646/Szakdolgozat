// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_app/pages/rateingsGuest_page.dart';
import 'package:dental_app/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({Key? key}) : super(key: key);

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  int _selectedIndex = 0;
  List<String> uniqueExaminations = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadUniqueExaminations();
  }

  void loadUniqueExaminations() async {
    Set<String> examinationSet = Set<String>();
    var querySnapshot = await _firestore.collection('doctors').get();
    for (var doc in querySnapshot.docs) {
      var examination = doc.data()['examination'] as String? ?? '';
      examinationSet.add(examination);
    }
    setState(() {
      uniqueExaminations = examinationSet.toList();
    });
    _pages.add(buildServicesPage());
    _pages.add(RateGuest());
  }

Widget buildServicesPage() {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: titleColor,
      titleTextStyle: titleText, 
      title: Text("Szolgáltatásaink"),
      centerTitle: true,  // Ez középre igazítja a címet az AppBar-ban
      leading: Navigator.canPop(context) ? IconButton(
        icon: Icon(FontAwesomeIcons.arrowLeft),
        onPressed: () => Navigator.of(context).pop(),
      ) : null,
    ),
    body: Container(
       decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDAE2F8), Color(0xFF9D50BB)],
        ),
      ),
      child: ListView.builder(
        itemCount: uniqueExaminations.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(uniqueExaminations[index]),
              leading: Icon(Icons.check_circle_outline),
            ),
          );
        },
      ),
    ),
  );
}

  final List<Widget> _pages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex < _pages.length ? _pages[_selectedIndex] : CircularProgressIndicator(),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Szolgáltatások',
              ),
              GButton(
                icon: Icons.star_rate,
                text: 'Értékelések',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _navigateBottomBar,
          ),
        ),
      ),
    );
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
