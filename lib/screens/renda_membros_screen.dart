import 'package:flutter/material.dart';

class RendaMembrosScreen extends StatelessWidget {
  const RendaMembrosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renda de Membros'),
        backgroundColor: Colors.purple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade100, Colors.purple.shade200],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Diamantes Disponíveis',
                          style: TextStyle(color: Colors.black54)),
                      TextButton(
                        onPressed: () {},
                        child: const Text('conta',
                            style: TextStyle(color: Colors.white)),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.purple.shade300,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.diamond, color: Colors.purple, size: 32),
                      SizedBox(width: 8),
                      Text('100 000',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Total de Diamantes'),
                      Text('Diamantes Congelados'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('💎 100K',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('💎 0',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Diamantes do Host (semana passada)'),
                      Text('Diamantes do Agente (semana passada)'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('💎 1M',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('💎 /',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Host na Classificação da Semana'),
                      Text('Agente no Rating da Agência'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('😔 0',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('💎 2.9M',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Semana Passada'),
                      Text('Rating da Agência'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('/', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('💎 0',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Data e Hora: 2026-01-06 09:23:03',
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Operações com Diamantes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            _buildOperationTile(Icons.swap_horiz, 'Trocar Diamantes'),
            _buildOperationTile(
                Icons.account_balance_wallet, 'Sacar Diamantes'),
            _buildOperationTile(Icons.reply, 'Transferir Diamantes'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationTile(IconData icon, String label) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange, size: 32),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
