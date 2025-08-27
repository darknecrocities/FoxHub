import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/supabase_config.dart';

Future<void> migrateUsersToSupabase() async {
  final snapshot = await FirebaseFirestore.instance.collection('users').get();

  for (var doc in snapshot.docs) {
    final data = doc.data();
    final uid = doc.id;
    final fullName = data['fullName'] ?? '';
    final username = data['username'] ?? '';
    final email = data['email'] ?? '';
    final course = data['course'] ?? '';
    final number = data['number'] ?? '';

    await SupabaseConfig.client.from('users').upsert({
      'uid': uid,
      'fullName': fullName,
      'username': username,
      'email': email,
      'course': course,
      'number': number,
    });
  }

  print("Migration completed!");
}
