import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 1; // 0: Meu, 1: Popular, 2: Brasil
  int _currentIndex = 0;
  String _selectedCountry = 'Brasil';
  final List<String> _countries = ['Brasil', 'EG', 'US', 'IN'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar usuários, salas ou agências',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.emoji_events, color: Colors.amber),
              tooltip: 'VIP / Ranking',
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Colors.purple,
        elevation: 0,
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          // Tabs: Meu, Popular, Brasil ▼
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              children: [
                _buildTab('Meu', 0),
                _buildTab('Popular', 1),
                _buildTabWithDropdown('Brasil', 2),
              ],
            ),
          ),
          // Banner promocional
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.card_giftcard,
                      color: Colors.deepOrange, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('First recharge – To get rich rewards',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            'Banner de promoção de primeira recarga, incentivando compra de moedas com bônus/recompensas.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Cards de salas/hosts
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 8, // Exemplo
              itemBuilder: (context, index) => _buildRoomCard(index),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTab(String label, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color:
                    _selectedTab == index ? Colors.purple : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: _selectedTab == index ? Colors.purple : Colors.black54,
                fontWeight:
                    _selectedTab == index ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabWithDropdown(String label, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color:
                    _selectedTab == index ? Colors.purple : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _selectedCountry,
                  style: TextStyle(
                    color:
                        _selectedTab == index ? Colors.purple : Colors.black54,
                    fontWeight: _selectedTab == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.black54),
                if (_selectedTab == index)
                  DropdownButton<String>(
                    value: _selectedCountry,
                    underline: const SizedBox(),
                    items: _countries
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedCountry = v);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomCard(int index) {
    // Exemplo de dados estáticos
    final room = {
      'image': 'https://randomuser.me/api/portraits/men/${index + 10}.jpg',
      'level': 'L${4 + (index % 2)}',
      'name': 'Host ${index + 1}',
      'desc': '🎉 Sala animada! 😃',
      'country': index % 2 == 0 ? 'BR' : 'EG',
      'users': 20 + index * 3,
      'avatars': List.generate(4,
          (i) => 'https://randomuser.me/api/portraits/women/${i + index}.jpg'),
    };
    return GestureDetector(
      onTap: () {
        // Entrar na sala ao vivo
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      room['image'] as String,
                      height: 90,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(room['level'] as String,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Image.asset(
                      'assets/flags/${(room['country'] as String).toLowerCase()}.png',
                      width: 24,
                      height: 16,
                      errorBuilder: (c, e, s) => const SizedBox(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(room['name'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(room['desc'] as String,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.people, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${room['users']}'),
                  const SizedBox(width: 8),
                  ...((room['avatars'] as List)
                      .map<Widget>((a) => Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: CircleAvatar(
                              radius: 10,
                              backgroundImage: NetworkImage(a),
                            ),
                          ))
                      .toList()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        // Abrir menu de criar/entrar em sala
      },
      icon: const Icon(Icons.add),
      label: const Text('Criar / Entrar'),
      backgroundColor: Colors.purple,
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Início'),
        BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports), label: 'Jogos'),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              Icon(Icons.people),
              Positioned(
                right: 0,
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Center(
                      child: Text('7',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
            ],
          ),
          label: 'Amigos',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
      onTap: (i) {
        setState(() => _currentIndex = i);
        if (i == 3) {
          Navigator.pushNamed(context, '/profile');
        }
        // Adicione navegação para outras abas se necessário
      },
    );
  }
}
