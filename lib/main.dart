import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Wajib ada buat ProviderScope
import 'features/chat/screens/chat_screen.dart';

void main() {
  // PENTING: ProviderScope diperlukan agar Riverpod (ChatProvider) jalan
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Companion', // Judul App
      debugShowCheckedModeBanner: false, // Hilangkan label debug di pojok
      theme: ThemeData(
        // Tema warna Pink Kawaii 🌸
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      // Langsung masuk ke layar Chatting
      home: const ChatScreen(),
    );
  }
}