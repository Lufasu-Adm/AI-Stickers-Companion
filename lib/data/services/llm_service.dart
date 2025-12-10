import 'package:dio/dio.dart';

class LlmService {
  // Pastikan API Key ini benar (tidak ada spasi di awal/akhir)
  final String _apiKey = 'API_KEY_MU_DI_SINI'; 
  
  final Dio _dio = Dio();

  Future<String> getResponse(String userMessage) async {
    try {
      final response = await _dio.post(
        'https://api.groq.com/openai/v1/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => true, 
        ),
        data: {
          "model": "llama-3.3-70b-versatile", 
          "messages": [
            {
              "role": "system",
              "content": "Kamu adalah Aiko, pacar virtual yang imut dan ceria. "
                  "Gunakan bahasa Indonesia gaul yang akrab. "
                  "Jawab singkat (maksimal 2 kalimat) dan pakai emoji lucu."
            },
            {"role": "user", "content": userMessage}
          ],
          "temperature": 0.7,
          "max_tokens": 200, // Batasi panjang jawaban biar cepat
        },
      );

      // Cek status code
      if (response.statusCode == 200) {
        // SUKSES!
        return response.data['choices'][0]['message']['content'];
      } else {
        final errorMsg = response.data['error']['message'] ?? 'Unknown error';
        return "Aduh, Aiko sakit... 🤒 (Server Error: $errorMsg)";
      }

    } catch (e) {
      return "Gak ada sinyal nih... 😭 (Cek internet kamu)";
    }
  }
}