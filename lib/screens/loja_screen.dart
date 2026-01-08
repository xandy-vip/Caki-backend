import 'package:flutter/material.dart';

class LojaScreen extends StatelessWidget {
  final List<Map<String, dynamic>> produtos = [
    {
      'nome': 'Moldura Dourada',
      'tipo': 'Moldura',
      'preco': 500,
      'imagem': Icons.crop_square,
    },
    {
      'nome': 'Entrada VIP',
      'tipo': 'Entrada',
      'preco': 200,
      'imagem': Icons.vpn_key,
    },
    {
      'nome': 'Fundo de Sala Luxo',
      'tipo': 'Fundo de Sala',
      'preco': 800,
      'imagem': Icons.wallpaper,
    },
    {
      'nome': 'Moldura Agência',
      'tipo': 'Moldura Agência',
      'preco': 1000,
      'imagem': Icons.verified,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loja'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final produto = produtos[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(produto['imagem'], size: 40, color: Colors.orange),
              title: Text(produto['nome'],
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(produto['tipo']),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('R\$ ${produto['preco']}',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Compra de ${produto['nome']} simulada!')),
                      );
                    },
                    child: Text('Comprar'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
