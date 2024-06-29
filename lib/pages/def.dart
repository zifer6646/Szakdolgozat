// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:dental_app/pages/booking.dart';
import 'package:dental_app/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:intl/intl.dart';

class ReservationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Szolgáltatásaink'),
        backgroundColor: titleColor,
        titleTextStyle: titleText,
      ),
      body: Container(
         decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDAE2F8), Color(0xFF9D50BB)],
        ),
      ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 10.0), // Kis térköz a cím és a grid között
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    _buildTile(context, 'Éves ellenőrzés'),
                    _buildTile(context, 'Fogkőeltávolítás'),
                    _buildTile(context, 'Gyulladt íny kezelése foganként'),
                    _buildTile(context, 'Helyi röntgenfelvétel'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  Widget _buildTile(BuildContext context, String title) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (context) => _buildAppointmentForm(context, title),
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            colors: [titleColor, buttonColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: gridTexts,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}


 Widget _buildAppointmentForm(BuildContext context, String title) {
  DateTime? selectedDate; // A kiválasztott dátum tárolására
  String? selectedDoctor; // A kiválasztott doktor tárolására
  TimeOfDay? selectedTime; // A kiválasztott idő tárolására

  return AlertDialog(
    title: Text(title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField(
          items: [
            DropdownMenuItem(
              child: Text('Dr. Smith'),
              value: 'Dr. Smith',
            ),
            DropdownMenuItem(
              child: Text('Dr. Johnson'),
              value: 'Dr. Johnson',
            ),
            DropdownMenuItem(
              child: Text('Dr. Tomas'),
              value: 'Dr. Tomas',
            ),
            DropdownMenuItem(
              child: Text('Dr. Terry'),
              value: 'Dr. Terry',
            ),
            DropdownMenuItem(
              child: Text('Dr. Boris'),
              value: 'Dr. Boris',
            ),
          ],
          onChanged: (value) {
            // Kiválasztott doktor tárolása
            selectedDoctor = value as String?;
          },
          decoration: InputDecoration(
            labelText: 'Válassz doktort',
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            // Jelenítsük meg a dátumválasztót és tároljuk el a kiválasztott dátumot
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)), // Egy évig lehet előre foglalni
            );
            if (pickedDate != null) {
              selectedDate = pickedDate;
            }
          },
          child: Text(selectedDate == null
              ? 'Válassz dátumot'
              : DateFormat('yyyy-MM-dd').format(selectedDate!)),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            // Jelenítsük meg az időválasztót és tároljuk el a kiválasztott időt
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) {
              selectedTime = pickedTime;
            }
          },
          child: Text(selectedTime == null
              ? 'Válassz időpontot'
              : selectedTime!.format(context)),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Kilépés'),
      ),
      ElevatedButton(
        onPressed: () async {
          // Ellenőrizd a kiválasztott dátumot, időt és doktort
          if (selectedDate != null && selectedTime != null && selectedDoctor != null) {
            try {
              // Mentsd el a foglalást a Firestore-ban
              await saveBooking(selectedDoctor!, title, DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, selectedTime!.hour, selectedTime!.minute));
              print('Booking saved successfully');
              // Visszatérhetünk a korábbi képernyőre vagy frissíthetjük a megjelenítést
              Navigator.of(context).pop(); // Bezárjuk a dialógust
            } catch (error) {
              print('Error saving booking: $error');
              // Kezeld a hibát megfelelően
            }
          } else {
            print('Please choose date, time, and doctor');
          }
        },
        child: Text('Foglalás'),
      ),
    ],
  );
}
