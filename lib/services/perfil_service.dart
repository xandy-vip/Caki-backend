import 'package:cloud_firestore/cloud_firestore.dart';

class PerfilService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> salvarPerfil({
    required String userId,
    required Map<String, dynamic> dados,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .set(dados, SetOptions(merge: true));
  }
}
