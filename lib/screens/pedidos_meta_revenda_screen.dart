import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PedidosMetaRevendaScreen extends StatefulWidget {
  @override
  _PedidosMetaRevendaScreenState createState() =>
      _PedidosMetaRevendaScreenState();
}

class _PedidosMetaRevendaScreenState extends State<PedidosMetaRevendaScreen> {
  List pedidos = [];
  bool loading = true;
  String error = '';

  Future<void> fetchPedidos() async {
    setState(() {
      loading = true;
      error = '';
    });
    try {
      final res = await http
          .get(Uri.parse('http://SEU_BACKEND/api/renda/pedidos-pendentes'));
      if (res.statusCode == 200) {
        pedidos = json.decode(res.body);
      } else {
        error = 'Erro ao buscar pedidos';
      }
    } catch (e) {
      error = 'Falha de conexão';
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> responderPedido(String id, String acao) async {
    setState(() {
      error = '';
      loading = true;
    });
    try {
      final res = await http.post(
        Uri.parse('http://SEU_BACKEND/api/renda/pedido/$id/acao'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'acao': acao}),
      );
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Pedido ${acao == 'aceito' ? 'aceito' : 'negado'}!')));
        await fetchPedidos();
      } else {
        error = json.decode(res.body)['error'] ?? 'Erro ao responder pedido';
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
    fetchPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pedidos de Transferência de Meta')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    ...pedidos.map((p) => Card(
                          child: ListTile(
                            leading: p['usuario']?['foto'] != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(p['usuario']['foto']))
                                : null,
                            title: Text(p['usuario']?['nick'] ?? ''),
                            subtitle: Text(
                                'ID: ${p['usuario']?['id']} | Valor: US\$${p['valor']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      responderPedido(p['_id'], 'aceito'),
                                  child: Text('Aceitar'),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () =>
                                      responderPedido(p['_id'], 'negado'),
                                  child: Text('Negar'),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
    );
  }
}
