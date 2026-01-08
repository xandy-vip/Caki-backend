import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PacotesMoedasScreen extends StatefulWidget {
  @override
  _PacotesMoedasScreenState createState() => _PacotesMoedasScreenState();
}

class _PacotesMoedasScreenState extends State<PacotesMoedasScreen> {
  List pacotes = [];
  bool loading = true;
  String error = '';
  double saldo = 0;

  Future<void> fetchPacotes() async {
    setState(() {
      loading = true;
      error = '';
    });
    try {
      final res = await http.get(Uri.parse('http://SEU_BACKEND/api/pacotes'));
      if (res.statusCode == 200) {
        pacotes = json.decode(res.body);
      } else {
        error = 'Erro ao buscar pacotes';
      }
    } catch (e) {
      error = 'Falha de conexão';
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> comprarPacote(String id, double valor) async {
    // Aqui pode adicionar verificação de saldo
    setState(() {
      loading = true;
      error = '';
    });
    try {
      final res = await http
          .post(Uri.parse('http://SEU_BACKEND/api/pacotes/comprar/$id'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        saldo = data['saldo'] ?? saldo;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Compra realizada!')));
      } else {
        error = json.decode(res.body)['error'] ?? 'Erro ao comprar';
      }
    } catch (e) {
      error = 'Falha de conexão';
    }
    await fetchPacotes();
  }

  @override
  void initState() {
    super.initState();
    fetchPacotes();
    // TODO: buscar saldo da carteira
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pacotes de Moedas')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Saldo: US\$${saldo.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18)),
                    ),
                    ...pacotes.map((p) => Card(
                          child: ListTile(
                            title: Text(
                                'US\$${p['valor']} - ${p['moedas']} moedas'),
                            subtitle: p['bonus'] != null && p['bonus'] > 0
                                ? Text('Bônus: ${p['bonus']} moedas')
                                : null,
                            trailing: ElevatedButton(
                              child: Text('Comprar'),
                              onPressed: () => comprarPacote(
                                  p['_id'], p['valor'].toDouble()),
                            ),
                          ),
                        ))
                  ],
                ),
      // TODO: espaço para edição/admin
    );
  }
}
