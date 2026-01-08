import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoricoTransacoesScreen extends StatefulWidget {
  final bool isRevenda;
  HistoricoTransacoesScreen({this.isRevenda = false});
  @override
  _HistoricoTransacoesScreenState createState() =>
      _HistoricoTransacoesScreenState();
}

class _HistoricoTransacoesScreenState extends State<HistoricoTransacoesScreen> {
  List transacoes = [];
  bool loading = true;
  String error = '';

  Future<void> fetchTransacoes() async {
    setState(() {
      loading = true;
      error = '';
    });
    try {
      final url = widget.isRevenda
          ? 'http://SEU_BACKEND/api/transacoes/revenda'
          : 'http://SEU_BACKEND/api/transacoes/usuario';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        transacoes = json.decode(res.body);
      } else {
        error = 'Erro ao buscar transações';
      }
    } catch (e) {
      error = 'Falha de conexão';
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTransacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histórico de Transações')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    ...transacoes.map((t) => Card(
                          child: ListTile(
                            leading: t['origem']?['foto'] != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(t['origem']['foto']))
                                : null,
                            title: Text('${t['tipo']} - US\$${t['valor']}'),
                            subtitle: Text(
                                'De: ${t['origem']?['nick'] ?? ''} | Para: ${t['destino']?['nick'] ?? ''}\n${t['descricao'] ?? ''}'),
                            trailing: Text(t['criadoEm'] ?? ''),
                          ),
                        ))
                  ],
                ),
    );
  }
}
