class ChatMessage {
  final String text;      // Isi pesannya
  final bool isUser;      // Siapa yang kirim? (True = Kita, False = Waifu)
  final DateTime timestamp; // Kapan dikirim

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}