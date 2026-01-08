import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarteiraRevendaScreen extends StatelessWidget {
  final int userId;
  final String apiUrl;

  const CarteiraRevendaScreen({
    Key? key,
    required this.userId,
    required this.apiUrl,
  }) : super(key: key);

  Future<Map<String, dynamic>> fetchCarteira() async {
    final response =
        await http.get(Uri.parse('$apiUrl/api/reseller/wallet?userId=$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao buscar carteira da revenda');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carteira da Revenda'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchCarteira(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final data = snapshot.data!;
          final saldoMoedas = data['saldoMoedas'] ?? 0;
          final saldoFinanceiro = data['saldoFinanceiro']?.toDouble() ?? 0.0;
          final historicoCompras =
              List<Map<String, dynamic>>.from(data['historicoCompras'] ?? []);
          final historicoVendas =
              List<Map<String, dynamic>>.from(data['historicoVendas'] ?? []);

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Saldo de Moedas', style: TextStyle(fontSize: 18)),
                        Text('$saldoMoedas',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                        SizedBox(height: 12),
                        Text('Saldo Financeiro',
                            style: TextStyle(fontSize: 18)),
                        Text('R\$ ${saldoFinanceiro.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text('Histórico de Compras',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: historicoCompras.length,
                    itemBuilder: (context, index) {
                      final compra = historicoCompras[index];
                      return ListTile(
                        leading: Icon(Icons.add_circle, color: Colors.green),
                        title: Text(
                            'Moedas: ${compra['moedas'] ?? compra['coins'] ?? '-'}'),
                        subtitle: Text(
                            'Valor: R\$ ${compra['valor'] ?? '-'} | Data: ${compra['data'] ?? compra['created_at'] ?? '-'}'),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                Text('Histórico de Vendas',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: historicoVendas.length,
                    itemBuilder: (context, index) {
                      final venda = historicoVendas[index];
                      return ListTile(
                        leading: Icon(Icons.remove_circle, color: Colors.red),
                        title: Text(
                            'Moedas: ${venda['moedas'] ?? venda['coins'] ?? '-'}'),
                        subtitle: Text(
                            'Valor: R\$ ${venda['valor'] ?? '-'} | Data: ${venda['data'] ?? venda['created_at'] ?? '-'}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
