import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_companion_app/data/models/chat_message.dart';
import 'package:ai_companion_app/data/services/llm_service.dart'; 

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final LlmService _llmService = LlmService(); // Siapkan servis

  ChatNotifier() : super([]) {
    addMessage("Halo Master! Apa yang bisa kubantu~ 🌸", false);
  }

  // Fungsi Kirim Pesan (Versi AI)
  Future<void> sendMessage(String text) async {
    // 1. Tampilkan chat user
    state = [...state, ChatMessage(text: text, isUser: true, timestamp: DateTime.now())];

    // 2. Kirim ke AI & Tunggu jawaban
    final reply = await _llmService.getResponse(text);

    // 3. Tampilkan balasan AI
    state = [...state, ChatMessage(text: reply, isUser: false, timestamp: DateTime.now())];
  }

  void addMessage(String text, bool isUser) {
    state = [...state, ChatMessage(text: text, isUser: isUser, timestamp: DateTime.now())];
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier();
});