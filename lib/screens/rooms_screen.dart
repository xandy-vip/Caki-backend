import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'audio_room_screen.dart';
import 'room_trophy_screen.dart';

class RoomsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = (AuthService().userId ?? '5551947').toString();
    final userName = 'Yasm';
    return Scaffold(
      backgroundColor: Color(0xFF1A1207),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.amber,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Container(
                            margin: EdgeInsets.only(top: 2),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green[900],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.shield,
                                    color: Colors.amber, size: 16),
                                SizedBox(width: 4),
                                Text(userId,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.emoji_events, color: Colors.amber),
                        tooltip: 'Ranking da Sala',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RoomTrophyScreen(roomId: userId),
                            ),
                          );
                        },
                      ),
                      Icon(Icons.power_settings_new, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            // Trophy and Recarga
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                        SizedBox(width: 4),
                        Text('0', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Icon(Icons.monetization_on,
                                color: Colors.amber, size: 36),
                            Text('Receba',
                                style: TextStyle(
                                    color: Colors.amber, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Grid de salas
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GridView.builder(
                  itemCount: 10,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AudioRoomScreen(roomName: 'Sala ${index + 1}'),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.amber, width: 2),
                              color: Colors.black.withOpacity(0.2),
                            ),
                            child: Center(
                              child: Icon(Icons.chair,
                                  color: Colors.amber, size: 32),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('${index + 1}',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            // Mensagens do sistema e chat
            Container(
              width: double.infinity,
              color: Colors.black.withOpacity(0.2),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Sistema: Bem-vindo ao Upfun, obedeça as especificações da plataforma',
                    style: TextStyle(color: Colors.cyanAccent, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Welcome everyone! Let's chat and have fun together!",
                    style: TextStyle(color: Colors.amber, fontSize: 14),
                  ),
                ],
              ),
            ),
            // Barra inferior de ícones
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.chat_bubble, color: Colors.white),
                  Icon(Icons.volume_up, color: Colors.white),
                  Icon(Icons.notifications, color: Colors.white),
                  Icon(Icons.grid_view, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
