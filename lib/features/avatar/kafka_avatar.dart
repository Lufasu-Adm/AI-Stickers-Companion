import 'package:flutter/material.dart';

enum AvatarState { 
  idle, 
  thinking, 
  talking, 
  angry, 
  happy,
  sad,
  confused, 
  shy,      
  serious,  
}

class KafkaAvatar extends StatefulWidget {
  final AvatarState currentState;

  const KafkaAvatar({super.key, required this.currentState});

  @override
  State<KafkaAvatar> createState() => _KafkaAvatarState();
}

class _KafkaAvatarState extends State<KafkaAvatar> {
  
  @override
  Widget build(BuildContext context) {
    int stackIndex = 0;
    
    // MAPPING ENUM KE INDEX STICKER (0-6)
    switch (widget.currentState) {
      case AvatarState.idle: 
      case AvatarState.thinking: // Menggunakan sticker Bingung/Confused untuk Idle dan Thinking
      case AvatarState.confused:
        stackIndex = 0; 
        break;
      case AvatarState.talking: 
      case AvatarState.happy:
        stackIndex = 1; // Menggunakan sticker Tertawa untuk Talking dan Happy
        break; 
      case AvatarState.angry:
        stackIndex = 2; // Menggunakan sticker Serius untuk Angry (karena tidak ada marah.png)
        break; 
      case AvatarState.sad: 
        stackIndex = 3; // Sedih
        break; 
      case AvatarState.shy:
        stackIndex = 4; // Malu
        break;
      case AvatarState.serious:
        stackIndex = 5; // Serius
        break;
      // Tambahkan case baru jika ada stiker baru
    }

    return SizedBox(
      height: 350, // Tinggi disesuaikan untuk stiker
      width: double.infinity,
      child: IndexedStack(
        index: stackIndex, 
        children: [
          // Index 0 (Idle, Thinking, Confused) -> Bingung.png
          _buildSticker('assets/stikcers/tertawa.png'),
          
          // Index 1 (Talking, Happy) -> Tertawa.png
          _buildSticker('assets/stikcers/tertawa.png'),
          
          // Index 2 (Angry) -> Serius.png (Mapping)
          _buildSticker('assets/stikcers/serius.png'), 
          
          // Index 3 (Sad) -> Sedih.png
          _buildSticker('assets/stikcers/sedih.png'),
          
          // Index 4 (Shy) -> Malu.png
          _buildSticker('assets/stikcers/malu.png'),
          
          // Index 5 (Serious) -> Serius.png
          _buildSticker('assets/stikcers/serius.png'),
          
          // JIKA ADA INDEX BARU, TAMBAHKAN DI SINI
        ],
      ),
    );
  }

  // Widget _buildSticker (Pengganti _buildModel)
  Widget _buildSticker(String path) {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        path,
        fit: BoxFit.contain,
        gaplessPlayback: true,
      ),
    );
  }
}