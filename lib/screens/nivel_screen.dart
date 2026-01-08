import 'package:flutter/material.dart';

class NivelScreen extends StatelessWidget {
  const NivelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Nível'),
        backgroundColor: Colors.purple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nível de Riqueza
              Card(
                color: Colors.amber[50],
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.monetization_on,
                              color: Colors.amber, size: 32),
                          SizedBox(width: 12),
                          Text('Nível de Riqueza',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                          'Gaste moedas para subir de nível. Cada 1 gold gasto = 1 ponto de experiência de riqueza.',
                          style: TextStyle(color: Colors.black87)),
                      const SizedBox(height: 12),
                      _buildProgressBar('Lv. 8', 1200, 2000, 'Lv. 9'),
                      const SizedBox(height: 8),
                      Text('Recompensas:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Text('- Ícones de nível (Lv.1+)'),
                      const Text('- Enviar foto na sala (Lv.10+)'),
                      const Text('- Privilégios exclusivos'),
                    ],
                  ),
                ),
              ),
              // Nível de Charme
              Card(
                color: Colors.purple[50],
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.diamond, color: Colors.purple, size: 32),
                          SizedBox(width: 12),
                          Text('Nível de Charme',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                          'Receba diamantes para subir de nível. Cada 1 diamond recebido = 1 ponto de experiência de charme.',
                          style: TextStyle(color: Colors.black87)),
                      const SizedBox(height: 12),
                      _buildProgressBar('Lv. 5', 800, 1200, 'Lv. 6'),
                      const SizedBox(height: 8),
                      Text('Recompensas:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Text('- Ícones exclusivos de charme'),
                      const Text('- Permissões especiais em salas'),
                      const Text('- Destaque visual para hosts'),
                    ],
                  ),
                ),
              ),
              // Diferença entre sistemas
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('🏆 Diferença entre Riqueza e Charme',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Riqueza: Gastar moedas (investidores/apoiadores)'),
                      Text('Charme: Receber diamantes (hosts/popularidade)'),
                      SizedBox(height: 8),
                      Text('Você pode evoluir ambos ao mesmo tempo!'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('🧠 Importância no App',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              const Text(
                  'Define ranking, libera funções exclusivas, aumenta credibilidade, incentiva recarga e engajamento, fortalece a economia interna.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(
      String currentLevel, int currentExp, int nextExp, String nextLevel) {
    double percent = currentExp / nextExp;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(currentLevel,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(nextLevel,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percent,
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          color: Colors.purple,
        ),
        const SizedBox(height: 4),
        Text('$currentExp / $nextExp XP', style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
