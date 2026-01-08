import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> messages = [];
  Map<String, dynamic>? room;
  bool _loading = false;
  String? _error;
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty || room == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final token = AuthService().token;
      final res = await http.post(
        Uri.parse(
            'http://localhost:3000/rooms/${room!['id'] ?? room!['_id']}/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token != null ? 'Bearer $token' : ''
        },
        body: jsonEncode({
          'user': 'Você',
          'text': _controller.text.trim(),
          'type': 'text',
        }),
      );
      if (res.statusCode == 200) {
        _controller.clear();
        await _fetchMessages();
      } else {
        setState(() {
          _error = 'Erro ao enviar mensagem';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro de conexão';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _sendImage() {
    setState(() {
      messages.add({
        'user': 'Você',
        'text': '[Imagem enviada]',
        'type': 'image',
      });
    });
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        messages.add({
          'user': 'Usuário X',
          'text': '[Imagem recebida]',
          'type': 'image',
        });
      });
    });
  }

  void _sendAudio() {
    setState(() {
      messages.add({
        'user': 'Você',
        'text': '[Áudio enviado]',
        'type': 'audio',
      });
    });
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        messages.add({
          'user': 'Usuário X',
          'text': '[Áudio recebido]',
          'type': 'audio',
        });
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is Map<String, dynamic>) {
      room = arg;
      _fetchMessages();
    }
  }

  Future<void> _fetchMessages() async {
    if (room == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final token = AuthService().token;
      final res = await http.get(
        Uri.parse(
            'http://localhost:3000/rooms/${room!['id'] ?? room!['_id']}/messages'),
        headers: {'Authorization': token != null ? 'Bearer $token' : ''},
      );
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() {
          messages = List<Map<String, dynamic>>.from(data);
        });
      } else {
        setState(() {
          _error = 'Erro ao buscar mensagens';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro de conexão';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String roomName =
        room != null ? (room!['name'] ?? 'Chat da Sala') : 'Chat da Sala';
    return Scaffold(
      appBar: AppBar(title: Text(roomName)),
      body: Column(
        children: [
          if (_loading) LinearProgressIndicator(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_error!, style: TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                Widget content;
                if (msg['type'] == 'image') {
                  content = Row(
                    children: [
                      Icon(Icons.image, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(msg['text'] ?? ''),
                    ],
                  );
                } else if (msg['type'] == 'audio') {
                  content = Row(
                    children: [
                      Icon(Icons.mic, color: Colors.green),
                      SizedBox(width: 8),
                      Text(msg['text'] ?? ''),
                    ],
                  );
                } else {
                  content = Text(msg['text'] ?? '');
                }
                return ListTile(
                  title: Text(msg['user'] ?? ''),
                  subtitle: content,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _sendImage,
                  tooltip: 'Enviar imagem (simulado)',
                ),
                IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: _sendAudio,
                  tooltip: 'Enviar áudio (simulado)',
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Digite uma mensagem...',
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
