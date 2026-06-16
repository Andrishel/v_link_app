import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/moto_provider.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zphrnqdxgjuttyzddsuq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpwaHJucWR4Z2p1dHR5emRkc3VxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc1MTQ0NTEsImV4cCI6MjA5MzA5MDQ1MX0.MmwS5_8Mjx2IJcc-nlAkBS4cyvGlObANnagAC0qTGfE',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MotoProvider()),
      ],
      child: MaterialApp(
        title: 'V-LINK App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(), // Arrancamos en la pantalla de Login
      ),
    );
  }
}