import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransferirMetaScreen extends StatefulWidget {
  @override
  _TransferirMetaScreenState createState() => _TransferirMetaScreenState();
}

class _TransferirMetaScreenState extends State<TransferirMetaScreen> {
  final TextEditingController _revendaIdController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  double saldoDisponivel = 0;
  double saldoBloqueado = 0;
  String error = '';
  bool loading = false;
  List pedidos = [];

  Future<void> fetchSaldos() async {
    // TODO: Substituir pelo endpoint real do usuário logado
    setState(() {
      loading = true;
    });
    try {
      final res =
          await http.get(Uri.parse('http://SEU_BACKEND/api/usuario/saldos'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        saldoDisponivel = data['saldoMetaDisponivel'] ?? 0;
        saldoBloqueado = data['saldoMetaBloqueado'] ?? 0;
      }
    } catch (e) {}
    setState(() {
      loading = false;
    });
  }

  Future<void> transferirMeta() async {
    setState(() {
      error = '';
      loading = true;
    });
    try {
      final valor = double.tryParse(_valorController.text) ?? 0;
      final res = await http.post(
        Uri.parse('http://SEU_BACKEND/api/renda/transferir-meta'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'revendaId': _revendaIdController.text,
          'valor': valor,
        }),
      );
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Pedido enviado!')));
        _valorController.clear();
        _revendaIdController.clear();
        await fetchSaldos();
      } else {
        error = json.decode(res.body)['error'] ?? 'Erro ao transferir meta';
      }
    } catch (e) {
      error = 'Falha de conexão';
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> fetchPedidos() async {
    // TODO: Substituir pelo endpoint real do usuário logado
    try {
      final res = await http
          .get(Uri.parse('http://SEU_BACKEND/api/usuario/pedidos-metas'));
      if (res.statusCode == 200) {
        pedidos = json.decode(res.body);
      }
    } catch (e) {}
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchSaldos();
    fetchPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transferir Meta para Revenda')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Saldo disponível: US\$${saldoDisponivel.toStringAsFixed(2)}'),
                  Text(
                      'Saldo bloqueado: US\$${saldoBloqueado.toStringAsFixed(2)}'),
                  SizedBox(height: 16),
                  TextField(
                    controller: _revendaIdController,
                    decoration: InputDecoration(labelText: 'ID da Revenda'),
                  ),
                  TextField(
                    controller: _valorController,
                    decoration: InputDecoration(
                        labelText: 'Valor da meta (mín. US\$5)'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: transferirMeta,
                    child: Text('Transferir para Revenda'),
                  ),
                  if (error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(error, style: TextStyle(color: Colors.red)),
                    ),
                  Divider(),
                  Text('Pedidos de Transferência:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...pedidos.map((p) => Card(
                        child: ListTile(
                          leading: p['usuario']?['foto'] != null
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(p['usuario']['foto']))
                              : null,
                          title: Text(p['usuario']?['nick'] ?? ''),
                          subtitle: Text(
                              'Valor: US\$${p['valor']} | Status: ${p['status']}'),
                          trailing: Text(p['criadoEm'] ?? ''),
                        ),
                      ))
                ],
              ),
            ),
    );
  }
}
