import 'package:cloud_firestore/cloud_firestore.dart';

class RendaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchRenda(String userId, String token) async {
    // Busca o documento do usuário na coleção "users"
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return doc.data()!;
    } else {
      throw Exception('Usuário não encontrado no Firestore');
    }
  }

  Future<bool> solicitarSaque({
    required String userId,
    required String token,
    required String metodo,
    required int moedas,
    required double valorBrutoUSD,
    required double taxa,
    required double valorLiquidoUSD,
  }) async {
    try {
      await _firestore.collection('saques').add({
        'user_id': userId,
        'metodo': metodo,
        'moedas': moedas,
        'valor_bruto_usd': valorBrutoUSD,
        'taxa': taxa,
        'valor_liquido_usd': valorLiquidoUSD,
        'status': 'PENDENTE',
        'data_solicitacao': DateTime.now().toIso8601String().substring(0, 10),
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
