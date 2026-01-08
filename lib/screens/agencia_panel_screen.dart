import 'package:flutter/material.dart';

class AgenciaPanelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Painel do Agente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Escolha uma opção:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navegar para tela de escolha de agência
              },
              child: Text('Entrar em uma agência como Host'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CadastroAgenciaScreen()),
                );
              },
              child: Text('Abrir minha agência'),
            ),
          ],
        ),
      ),
    );
  }
}

class CadastroAgenciaScreen extends StatefulWidget {
  @override
  State<CadastroAgenciaScreen> createState() => _CadastroAgenciaScreenState();
}

class _CadastroAgenciaScreenState extends State<CadastroAgenciaScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _whatsController = TextEditingController();
  final TextEditingController _paisController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  String? _docFrente;
  String? _docVerso;

  void _pickDoc(bool frente) async {
    // Aqui você pode implementar o picker de imagem
    // Exemplo: usando image_picker ou similar
  }

  void _submit() {
    // Aqui você pode enviar os dados para o backend
    // Gerar ID da agência (exemplo: random ou sequencial)
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Agência')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome da agência'),
            ),
            TextField(
              controller: _whatsController,
              decoration: InputDecoration(labelText: 'WhatsApp'),
            ),
            TextField(
              controller: _paisController,
              decoration: InputDecoration(labelText: 'País'),
            ),
            TextField(
              controller: _cidadeController,
              decoration: InputDecoration(labelText: 'Cidade'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickDoc(true),
                    child: Text(
                        _docFrente == null ? 'Documento Frente' : 'Frente OK'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickDoc(false),
                    child: Text(
                        _docVerso == null ? 'Documento Verso' : 'Verso OK'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Cadastrar Agência'),
            ),
          ],
        ),
      ),
    );
  }
}
