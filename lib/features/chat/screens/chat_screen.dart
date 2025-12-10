import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/chat_provider.dart';
import '../../../data/services/llm_service.dart';
import '../../avatar/kafka_avatar.dart'; 

// PROVIDER UNTUK MENGONTROL STATE AVATAR
// Menggunakan Enum Stiker 2D yang diperluas
final avatarStateProvider = StateProvider<AvatarState>((ref) => AvatarState.idle);

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final LlmService _llmService = LlmService();
  
  // Kontrol utama untuk transisi: idle -> thinking -> idle
  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // LOGIC MOOD ANALYSIS (Menganalisis mood dari pesan PENGGUNA)
  void _analyzeMood(String text) {
    final lowerText = text.toLowerCase();
    
    // Mapping ke Enum Stiker yang sudah di-fix
    if (lowerText.contains('haha') || lowerText.contains('senang') || lowerText.contains('tertawa')) {
      ref.read(avatarStateProvider.notifier).state = AvatarState.happy;
    } else if (lowerText.contains('sedih') || lowerText.contains('maaf') || lowerText.contains('susah')) {
      ref.read(avatarStateProvider.notifier).state = AvatarState.sad;
    } else if (lowerText.contains('marah') || lowerText.contains('kesal')) {
      ref.read(avatarStateProvider.notifier).state = AvatarState.angry;
    } else if (lowerText.contains('bingung') || lowerText.contains('apa') || lowerText.contains('bagaimana')) {
      ref.read(avatarStateProvider.notifier).state = AvatarState.confused;
    } else if (lowerText.contains('malu') || lowerText.contains('ih') || lowerText.contains('ehem')) {
      ref.read(avatarStateProvider.notifier).state = AvatarState.shy;
    } else if (lowerText.contains('serius') || lowerText.contains('penting') || lowerText.contains('fokus')) {
      ref.read(avatarStateProvider.notifier).state = AvatarState.serious;
    }
    // Jika tidak ada keyword, biarkan state sebelumnya tetap ada atau default ke idle saat selesai.
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isProcessing) return;

    // 1. ANALISIS MOOD PENGGUNA DULU (Agar Avatar bereaksi pada saat pengguna mengirim)
    _analyzeMood(text); 
    
    ref.read(chatProvider.notifier).addMessage(text, true);
    _controller.clear();
    _scrollToBottom();

    // 2. MULAI PROSES: Ganti state ke THINKING
    setState(() {
      _isProcessing = true;
    });
    ref.read(avatarStateProvider.notifier).state = AvatarState.thinking;

    try {
      final String response = await _llmService.getResponse(text);

      if (!mounted) return;

      // 3. AI SELESAI: Tampilkan respons
      ref.read(chatProvider.notifier).addMessage(response, false);
      
      // OPTIONAL: Analisis mood dari respons AI untuk transisi ekspresi cepat (misal: dari THINKING ke TALKING)
      // Namun, karena kita langsung ke IDLE, kita lewati ini.

    } catch (e) {
      if (!mounted) return;
      // Pesan error jika LLM gagal
      ref.read(chatProvider.notifier).addMessage("Maaf, Ruphas lagi pusing... 😵", false);
      ref.read(avatarStateProvider.notifier).state = AvatarState.sad; // Ekspresi sedih saat error
    } finally {
      if (mounted) {
        // 4. SELESAI TOTAL: Balik ke IDLE
        setState(() {
          _isProcessing = false;
        });
        ref.read(avatarStateProvider.notifier).state = AvatarState.idle;
        _scrollToBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);
    final currentAvatarState = ref.watch(avatarStateProvider);
    
    final bool isInputDisabled = _isProcessing;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // FIX: Perbaiki typo nama 'Ruphas'
        title: const Text("Ruphas"), 
        backgroundColor: Colors.pink[100],
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- BAGIAN AVATAR (STIKER) ---
          SizedBox(
            height: 350, // Tinggi area Stiker
            width: double.infinity,
            child: Stack(
              children: [
                Container(color: Colors.pink[50]),
                
                // Widget KafkaAvatar yang sekarang menampilkan Stiker
                KafkaAvatar(currentState: currentAvatarState),
                
                // Overlay Text Status Mood
                Positioned(
                  bottom: 10,
                  left: 0, 
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((255 * 0.8).toInt()), 
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Status: ${currentAvatarState.name.toUpperCase()}", 
                        style: TextStyle(color: Colors.pink[400], fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          // --- LIST CHAT ---
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                // ... (Widget Chat Message) ...
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: msg.isUser ? Colors.pink[300] : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: msg.isUser ? const Radius.circular(20) : Radius.zero,
                        bottomRight: msg.isUser ? Radius.zero : const Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // --- INPUT FIELD ---
          if (_isProcessing)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Aiko sedang mengetik...",
                  style: TextStyle(fontSize: 12, color: Colors.grey[500], fontStyle: FontStyle.italic),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !isInputDisabled, 
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: "Ketik pesan...",
                      filled: true,
                      fillColor: Colors.pink[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: isInputDisabled ? null : _sendMessage, 
                  backgroundColor: isInputDisabled ? Colors.grey[300] : Colors.pink[300],
                  mini: true,
                  elevation: 0,
                  child: isInputDisabled
                      ? const SizedBox(
                          width: 20, 
                          height: 20, 
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                        ) 
                      : const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}