import 'package:flutter/material.dart';

class AdminPanelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Painel do Gerente/Admin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Administração do App',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Exemplo: navegar para gerenciamento de usuários
              },
              child: Text('Gerenciar Usuários'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Exemplo: navegar para gerenciamento de agências
              },
              child: Text('Gerenciar Agências'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Exemplo: visualizar relatórios
              },
              child: Text('Relatórios e Estatísticas'),
            ),
            // Adicione mais opções conforme necessário
          ],
        ),
      ),
    );
  }
}
