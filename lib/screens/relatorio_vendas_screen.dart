import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RelatorioVendasScreen extends StatefulWidget {
  @override
  _RelatorioVendasScreenState createState() => _RelatorioVendasScreenState();
}

class _RelatorioVendasScreenState extends State<RelatorioVendasScreen> {
  DateTime? inicio;
  DateTime? fim;
  String clienteId = '';
  String pacoteId = '';
  bool loading = false;
  String error = '';
  List vendas = [];
  int totalVendas = 0;
  int totalMoedas = 0;
  double totalValor = 0;

  Future<void> fetchRelatorio() async {
    setState(() {
      loading = true;
      error = '';
    });
    try {
      final params = [];
      if (inicio != null && fim != null) {
        params.add('inicio=${inicio!.toIso8601String()}');
        params.add('fim=${fim!.toIso8601String()}');
      }
      if (clienteId.isNotEmpty) params.add('clienteId=$clienteId');
      if (pacoteId.isNotEmpty) params.add('pacoteId=$pacoteId');
      final url = 'http://SEU_BACKEND/api/vendas/relatorio' +
          (params.isNotEmpty ? '?${params.join('&')}' : '');
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        vendas = data['vendas'] ?? [];
        totalVendas = data['totalVendas'] ?? 0;
        totalMoedas = data['totalMoedas'] ?? 0;
        totalValor = (data['totalValor'] ?? 0).toDouble();
      } else {
        error = 'Erro ao buscar relatório';
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
    fetchRelatorio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Relatório de Vendas')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total de vendas: $totalVendas'),
                  Text('Total de moedas vendidas: $totalMoedas'),
                  Text('Total faturado: US\$${totalValor.toStringAsFixed(2)}'),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2023),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                inicio = picked.start;
                                fim = picked.end;
                              });
                              fetchRelatorio();
                            }
                          },
                          child: Text('Filtrar por período'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(labelText: 'ID do Cliente'),
                    onChanged: (v) => clienteId = v,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'ID do Pacote'),
                    onChanged: (v) => pacoteId = v,
                  ),
                  ElevatedButton(
                    onPressed: fetchRelatorio,
                    child: Text('Filtrar'),
                  ),
                  if (error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(error, style: TextStyle(color: Colors.red)),
                    ),
                  Divider(),
                  Text('Vendas:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...vendas.map((v) => Card(
                        child: ListTile(
                          title:
                              Text('Cliente: ${v['cliente']?['nick'] ?? ''}'),
                          subtitle: Text(
                              'Pacote: ${v['pacote']?['nome'] ?? ''}\nMoedas: ${v['moedas']} | Valor: US\$${v['valor']}'),
                          trailing: Text(v['data'] ?? ''),
                        ),
                      ))
                ],
              ),
            ),
    );
  }
}
