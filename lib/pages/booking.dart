import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveBooking(String doctor, String examination, DateTime time) async {
  try {
    // Ellenőrizze, hogy a felhasználó be van-e jelentkezve
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No user signed in');
    }

    // Ellenőrizze, hogy a kötelező paraméterek üresek-e
    if (doctor.isEmpty || examination.isEmpty || time == null) {
      throw Exception('Missing required parameters');
    }

    // Készíts egy Map objektumot a foglalás adataival
    Map<String, dynamic> bookingData = {
      'doctor': doctor,
      'examination': examination,
      'time': time, // Itt használjuk közvetlenül a DateTime objektumot
      'userID': user.uid, // Hozzáadva az aktuális felhasználó UID-ja
    };

    // Mentsd el a foglalást az egyedi dokumentumnév alatt a Firestore-ban a 'booking' kollekcióban
    await FirebaseFirestore.instance.collection('booking').doc().set(bookingData);
  } catch (error) {
    print('Error saving booking: $error');
    throw error; // Dobd újra a hibát, hogy a hívó oldalon kezelni tudja azt
  }
}
