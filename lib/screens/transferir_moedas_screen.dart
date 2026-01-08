import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransferirMoedasScreen extends StatefulWidget {
  @override
  _TransferirMoedasScreenState createState() => _TransferirMoedasScreenState();
}

class _TransferirMoedasScreenState extends State<TransferirMoedasScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _qtdController = TextEditingController();
  Map? usuario;
  bool buscando = false;
  bool confirmando = false;
  String error = '';
  int quantidade = 0;

  Future<void> buscarUsuario() async {
    setState(() {
      buscando = true;
      error = '';
      usuario = null;
    });
    try {
      final res = await http.get(Uri.parse(
          'http://SEU_BACKEND/api/transferencias/buscar-usuario/${_idController.text}'));
      if (res.statusCode == 200) {
        usuario = json.decode(res.body);
      } else {
        error = json.decode(res.body)['error'] ?? 'Usuário não encontrado';
      }
    } catch (e) {
      error = 'Falha de conexão';
    }
    setState(() {
      buscando = false;
    });
  }

  void confirmarTransferencia() {
    setState(() {
      confirmando = true;
      error = '';
      quantidade = int.tryParse(_qtdController.text) ?? 0;
    });
  }

  Future<void> transferirMoedas() async {
    setState(() {
      error = '';
    });
    try {
      final res = await http.post(
        Uri.parse('http://SEU_BACKEND/api/transferencias/transferir-moedas'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'usuarioId': usuario!['id'],
          'quantidade': quantidade,
        }),
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Transferência realizada!')));
        setState(() {
          usuario = null;
          confirmando = false;
          _idController.clear();
          _qtdController.clear();
        });
      } else {
        error = json.decode(res.body)['error'] ?? 'Erro ao transferir';
      }
    } catch (e) {
      error = 'Falha de conexão';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transferir Moedas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID do Usuário'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: buscarUsuario,
              child: Text('Buscar'),
            ),
            if (buscando) CircularProgressIndicator(),
            if (usuario != null) ...[
              ListTile(
                leading: usuario!['foto'] != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(usuario!['foto']))
                    : null,
                title: Text(usuario!['nick'] ?? ''),
                subtitle: Text('ID: ${usuario!['id']}'),
              ),
              TextField(
                controller: _qtdController,
                decoration: InputDecoration(labelText: 'Quantidade de Moedas'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: confirmarTransferencia,
                child: Text('OK'),
              ),
            ],
            if (confirmando && usuario != null) ...[
              Card(
                child: ListTile(
                  leading: usuario!['foto'] != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(usuario!['foto']))
                      : null,
                  title: Text(usuario!['nick'] ?? ''),
                  subtitle: Text('Transferindo: $quantidade moedas'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: transferirMoedas,
                    child: Text('OK'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      confirmando = false;
                    }),
                    child: Text('Cancelar'),
                  ),
                ],
              ),
            ],
            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(error, style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
