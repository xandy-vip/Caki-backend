import 'package:flutter/material.dart';

class CarteiraScreen extends StatelessWidget {
  const CarteiraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carteira de Ouro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.amber[800],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Conta e saldo
            Container(
              color: Colors.amber[800],
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Minha Conta',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('ID: 123456',
                            style: TextStyle(color: Colors.white70)),
                        SizedBox(height: 8),
                        Text('Saldo de Ouro',
                            style: TextStyle(color: Colors.white70)),
                        Text('1.200.000',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Banner promocional
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.card_giftcard,
                      color: Colors.deepOrange, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Promoção de Primeira Recarga',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Ganhe bônus extras na sua primeira recarga!'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Métodos de pagamento
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💳 MÉTODOS DE PAGAMENTO',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet,
                        color: Colors.green),
                    title: const Text('Google Pay'),
                    subtitle:
                        const Text('Pagamento rápido e seguro com Google'),
                    trailing:
                        const Icon(Icons.check_circle, color: Colors.green),
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle),
                    label: const Text('Recarregar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('📦 PACOTES DE MOEDAS',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  _buildCoinPackage('60K coins', 'R\$ 0,99'),
                  _buildCoinPackage('300K coins', 'R\$ 4,99'),
                  _buildCoinPackage('600K coins', 'R\$ 9,99'),
                  _buildCoinPackage('3M coins', 'R\$ 49,99'),
                  _buildCoinPackage('6M coins', 'R\$ 99,99'),
                  const SizedBox(height: 24),
                  const Text('🔄 SISTEMA AUTOMÁTICO',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text(
                      'Pagamento validado em tempo real. Crédito instantâneo após aprovação. Histórico de recargas disponível.'),
                  const SizedBox(height: 24),
                  const Text('🔐 SEGURANÇA',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text(
                      'Pagamento protegido pela Google Play. Confirmação criptografada e prevenção contra fraude.'),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinPackage(String label, String price) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading:
            const Icon(Icons.monetization_on, color: Colors.amber, size: 32),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(price,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.green)),
        onTap: () {},
      ),
    );
  }
}
