import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:flutter_auto_echo_cancellation_websocket/flutter_auto_echo_cancellation_websocket.dart';
// import 'package:chat_flutter/chat_flutter.dart';

class AudioRoomScreen extends StatefulWidget {
  final String roomName;
  const AudioRoomScreen({Key? key, required this.roomName}) : super(key: key);

  @override
  State<AudioRoomScreen> createState() => _AudioRoomScreenState();
}

class _AudioRoomScreenState extends State<AudioRoomScreen>
    with SingleTickerProviderStateMixin {
  late IO.Socket socket;

  // Estado para "cadeira" (usuário é speaker ou não)
  bool _isOnChair = false;

  late TabController _tabController;

  bool _socketConnected = false;
  bool _socketConnecting = true;
  String? _socketError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initSocket();
  }

  void _initSocket() {
    // Altere a URL para o endereço do seu backend
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();

    setState(() {
      _socketConnecting = true;
      _socketConnected = false;
      _socketError = null;
    });

    socket.onConnect((_) {
      print('Conectado ao Socket.IO');
      setState(() {
        _socketConnected = true;
        _socketConnecting = false;
        _socketError = null;
      });
      // Exemplo: entrar na sala
      socket
          .emit('joinRoom', {'roomId': widget.roomName, 'userId': 'meuUserId'});
    });

    socket.onDisconnect((_) {
      print('Desconectado do Socket.IO');
      setState(() {
        _socketConnected = false;
        _socketConnecting = false;
      });
    });

    socket.onConnectError((err) {
      print('Erro de conexão Socket.IO: $err');
      setState(() {
        _socketConnected = false;
        _socketConnecting = false;
        _socketError = err.toString();
      });
    });

    socket.onError((err) {
      print('Erro Socket.IO: $err');
      setState(() {
        _socketConnected = false;
        _socketConnecting = false;
        _socketError = err.toString();
      });
    });

    socket.on('newMessage', (data) {
      print('Nova mensagem: $data');
      setState(() {
        if (data is Map<String, dynamic>) {
          _messages.add(data);
        } else if (data is Map) {
          _messages.add(Map<String, dynamic>.from(data));
        } else {
          _messages
              .add({'user': 'Outro', 'text': data.toString(), 'type': 'text'});
        }
      });
    });

    socket.on('micUpdated', (data) {
      print('Microfone atualizado: $data');
    });

    socket.on('presentSent', (data) {
      print('Presente recebido: $data');
    });

    socket.on('userJoined', (data) {
      print('Usuário entrou: $data');
    });

    socket.on('userLeft', (data) {
      print('Usuário saiu: $data');
    });

    // Adicione outros listeners conforme necessário
  }

  @override
  void dispose() {
    socket.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Função para jogar presente para si mesmo
  void _sendGiftToSelf() {
    setState(() {
      _messages.add({
        'user': 'Você',
        'text': 'Você enviou um presente para si mesmo! 🎁',
        'type': 'gift',
      });
    });
  }

  // Função para enviar presente para outro usuário (exemplo)
  void _sendGiftToUser(String user) {
    setState(() {
      _messages.add({
        'user': 'Você',
        'text': 'Você enviou um presente para $user! 🎁',
        'type': 'gift',
      });
    });
  }

  // Função para subir/descer na cadeira
  void _toggleChair() {
    setState(() {
      _isOnChair = !_isOnChair;
      _messages.add({
        'user': 'Sistema',
        'text': _isOnChair
            ? 'Você subiu na cadeira (microfone)!'
            : 'Você desceu da cadeira.',
        'type': 'system',
      });
    });
  }

  // Mensagens locais para chat de texto/imagem
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();

  // (Removido: métodos duplicados de initState e dispose)

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    final msg = {
      'user': 'Você',
      'text': _controller.text.trim(),
      'type': 'text',
    };
    setState(() {
      _messages.add(msg);
      _controller.clear();
    });
    // Envia para o backend via Socket.IO
    socket.emit('sendMessage', {
      'roomId': widget.roomName,
      'message': msg,
    });
  }

  void _sendImage() {
    setState(() {
      _messages.add({
        'user': 'Você',
        'text': '[Imagem enviada]',
        'type': 'image',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.roomName),
            SizedBox(width: 12),
            if (_socketConnecting)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
              )
            else if (_socketConnected)
              Icon(Icons.circle, color: Colors.green, size: 16)
            else
              Icon(Icons.circle, color: Colors.red, size: 16),
          ],
        ),
        backgroundColor: Colors.brown[900],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Chat', icon: Icon(Icons.chat)),
            Tab(text: 'Presentes', icon: Icon(Icons.card_giftcard)),
          ],
        ),
      ),
      backgroundColor: Color(0xFF1A1207),
      body: Column(
        children: [
          if (_socketError != null)
            Container(
              color: Colors.red[900],
              width: double.infinity,
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Erro de conexão: $_socketError',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          // Espaço para participantes com microfone
          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildSpeaker(0, isUser: true),
                ...List.generate(5, (i) => _buildSpeaker(i + 1)),
              ],
            ),
          ),
          Divider(color: Colors.brown[700]),
          // Abas de Chat e Presentes
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Aba Chat
                Container(
                  color: Colors.transparent,
                  child: ListView.builder(
                    reverse: false,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      Widget content;
                      if (msg['type'] == 'image') {
                        content = Row(
                          children: [
                            Icon(Icons.image, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(msg['text'] ?? '',
                                style: TextStyle(color: Colors.white)),
                          ],
                        );
                      } else {
                        content = Text(msg['text'] ?? '',
                            style: TextStyle(color: Colors.white));
                      }
                      return ListTile(
                        title: Text(msg['user'] ?? '',
                            style:
                                TextStyle(color: Colors.amber, fontSize: 13)),
                        subtitle: content,
                      );
                    },
                  ),
                ),
                // Aba Presentes
                _buildGiftTab(),
              ],
            ),
          ),
          // Barra de ações fixa na parte inferior
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isOnChair ? Icons.mic_off : Icons.mic,
                      color: Colors.amber),
                  tooltip:
                      _isOnChair ? 'Descer da cadeira' : 'Subir na cadeira',
                  onPressed: _toggleChair,
                ),
                IconButton(
                  icon: Icon(Icons.card_giftcard, color: Colors.pinkAccent),
                  tooltip: 'Jogar presente para si mesmo',
                  onPressed: _sendGiftToSelf,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Digite uma mensagem...',
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: TextStyle(color: Colors.white38),
                    ),
                    style: TextStyle(color: Colors.white),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.amber),
                  onPressed: _sendMessage,
                ),
                IconButton(
                  icon: Icon(Icons.music_note, color: Colors.amber),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.image, color: Colors.amber),
                  onPressed: _sendImage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget da aba de presentes
  Widget _buildGiftTab() {
    // Catálogo simples de presentes
    final gifts = [
      {'name': 'Flor', 'icon': Icons.local_florist, 'color': Colors.pink},
      {'name': 'Coração', 'icon': Icons.favorite, 'color': Colors.red},
      {'name': 'Estrela', 'icon': Icons.star, 'color': Colors.amber},
      {
        'name': 'Coroa',
        'icon': Icons.emoji_events,
        'color': Colors.yellow[700]
      },
    ];
    final users = List.generate(5, (i) => 'User ${i + 1}');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Escolha um presente para enviar:',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 12),
          Wrap(
            spacing: 16,
            children: gifts
                .map((gift) => Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: gift['color'] as Color?,
                          radius: 28,
                          child: Icon(gift['icon'] as IconData,
                              color: Colors.white, size: 32),
                        ),
                        SizedBox(height: 4),
                        Text(gift['name'] as String,
                            style: TextStyle(color: Colors.white)),
                        SizedBox(height: 4),
                        DropdownButton<String>(
                          dropdownColor: Colors.brown[900],
                          hint: Text('Para',
                              style: TextStyle(color: Colors.white)),
                          items: users
                              .map((u) => DropdownMenuItem(
                                    value: u,
                                    child: Text(u,
                                        style: TextStyle(color: Colors.white)),
                                  ))
                              .toList(),
                          onChanged: (user) {
                            if (user != null) _sendGiftToUser(user);
                          },
                        ),
                      ],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeaker(int i, {bool isUser = false}) {
    final bool showUser = isUser;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor:
                showUser && _isOnChair ? Colors.green : Colors.amber[200],
            child: showUser
                ? Icon(_isOnChair ? Icons.mic : Icons.person,
                    color: Colors.brown[900], size: 36)
                : Icon(Icons.person, color: Colors.brown[900], size: 36),
          ),
          SizedBox(height: 4),
          Text(showUser ? 'Você' : 'User $i',
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
