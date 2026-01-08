import 'package:flutter/material.dart';
import 'carteira_screen.dart';
import 'nivel_screen.dart';
import 'renda_membros_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Exemplo: lógica para mostrar o botão (substitua por sua lógica real)
  bool get _isAgenteOuHost => true; // Troque para false para ocultar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PERFIL'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isAgenteOuHost)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.groups, color: Colors.white),
                  label: const Text('Renda de Membros'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RendaMembrosScreen()),
                    );
                  },
                ),
              ),
            Container(
              color: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                        'assets/avatar.png'), // Substitua pelo caminho do avatar
                  ),
                  const SizedBox(height: 12),
                  const Text('Nome do Usuário',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('ID: 123456',
                          style: TextStyle(color: Colors.white70)),
                      SizedBox(width: 12),
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      Text(' VIP', style: TextStyle(color: Colors.amber)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Nível: 10',
                          style: TextStyle(color: Colors.white70)),
                      SizedBox(width: 12),
                      Text('Host/Streamer: 5',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                          label: Text('🔥 Top 1',
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.orange),
                      Chip(
                          label: Text('🎤 Streamer',
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.blue),
                      // Adicione mais badges conforme necessário
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetric('Visitantes', '1.2K'),
                  _buildMetric('Siga', '800'),
                  _buildMetric('Fãs', '350'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💰 CARTEIRAS',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildWalletButton(
                          Icons.monetization_on, 'Carteira de Moedas'),
                      _buildWalletButton(Icons.diamond, 'Renda'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('🏠 FUNÇÕES PRINCIPAIS (ATALHOS)',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildShortcutButton(Icons.meeting_room, 'Quarto'),
                      _buildShortcutButton(Icons.leaderboard, 'Nível'),
                      _buildShortcutButton(Icons.emoji_events, 'Medalha'),
                      _buildShortcutButton(Icons.store, 'Loja'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('⭐ SEÇÃO “MEU”',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildShortcutButton(Icons.star, 'VIP'),
                      _buildShortcutButton(Icons.business, 'Minha Agência'),
                      _buildShortcutButton(Icons.task, 'Centro de Tarefa'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('⚙️ GERENCIAMENTO DA CONTA',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildShortcutButton(Icons.edit, 'Editar Perfil'),
                      _buildShortcutButton(Icons.settings, 'Configuração'),
                      _buildShortcutButton(Icons.videocam, 'Iniciar Live'),
                      _buildShortcutButton(Icons.history, 'Histórico de Live'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Casa'),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), label: 'Descobrir'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Mensagem'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Mim'),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildWalletButton(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {
        if (label == 'Carteira de Moedas') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CarteiraScreen()),
          );
        } else if (label == 'Renda') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RendaMembrosScreen()),
          );
        }
      },
      icon: Icon(icon, color: Colors.amber),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildShortcutButton(IconData icon, String label) {
    return InkWell(
      onTap: () {
        if (label == 'Nível') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NivelScreen()),
          );
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.deepPurple.shade50,
            child: Icon(icon, color: Colors.deepPurple),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
