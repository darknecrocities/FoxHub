import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = "https://wmwolbeeptlcoeebajnt.supabase.co";
  static const String supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Indtd29sYmVlcHRsY29lZWJham50Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU5NDgyNDYsImV4cCI6MjA3MTUyNDI0Nn0.X1cDXsHK-EgzyB8PWIuXYqjva92YCu0c6svf7kyfBUQ";

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
