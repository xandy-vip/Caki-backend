import 'package:flutter/material.dart';

class VipLevelsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Níveis VIP'),
        backgroundColor: Colors.amber[100],
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Text('Nenhum benefício VIP cadastrado.'),
      ),
    );
  }
}
