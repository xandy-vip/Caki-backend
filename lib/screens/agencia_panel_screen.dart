import 'package:flutter/material.dart';

class AgenciaPanelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Agente'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Escolha uma opção:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.meeting_room, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Navegar para tela de escolha de agência como Host
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EscolherAgenciaHostScreen(),
                  ),
                );
              },
              label: const Text('Entrar em uma agência como Host',
                  style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.business, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroAgenciaScreen(),
                  ),
                );
              },
              label: const Text('Abrir minha agência',
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class EscolherAgenciaHostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolher Agência'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text('Tela de escolha de agência como Host (em breve)',
            style: TextStyle(fontSize: 18)),
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
  bool _loading = false;
  String? _error;
  String? _success;

  void _pickDoc(bool frente) async {
    // TODO: Implementar picker de imagem
    setState(() {
      if (frente) {
        _docFrente = 'frente.png';
      } else {
        _docVerso = 'verso.png';
      }
    });
  }

  void _submit() async {
    setState(() {
      _loading = true;
      _error = null;
      _success = null;
    });
    await Future.delayed(const Duration(seconds: 2)); // Simula envio
    setState(() {
      _loading = false;
      _success = 'Agência cadastrada com sucesso!';
    });
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Agência'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome da agência'),
            ),
            TextField(
              controller: _whatsController,
              decoration: const InputDecoration(labelText: 'WhatsApp'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _paisController,
              decoration: const InputDecoration(labelText: 'País'),
            ),
            TextField(
              controller: _cidadeController,
              decoration: const InputDecoration(labelText: 'Cidade'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickDoc(true),
                    child: Text(
                        _docFrente == null ? 'Documento Frente' : 'Frente OK'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickDoc(false),
                    child: Text(
                        _docVerso == null ? 'Documento Verso' : 'Verso OK'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_success != null)
              Text(_success!, style: const TextStyle(color: Colors.green)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Cadastrar Agência'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
