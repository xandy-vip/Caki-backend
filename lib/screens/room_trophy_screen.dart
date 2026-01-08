import 'package:flutter/material.dart';
import '../services/room_rank_service.dart';
import '../models/room_trophy.dart';

class RoomTrophyScreen extends StatefulWidget {
  final String roomId;
  const RoomTrophyScreen({super.key, required this.roomId});

  @override
  State<RoomTrophyScreen> createState() => _RoomTrophyScreenState();
}

class _RoomTrophyScreenState extends State<RoomTrophyScreen> {
  final RoomRankService _service = RoomRankService();
  RoomRank? _rank;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchRank();
  }

  Future<void> _fetchRank() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final rank = await _service.fetchRoomRank(widget.roomId);
      setState(() {
        _rank = rank;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao buscar ranking';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekRange = _service.getAppWeekRange(now);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking da Sala'),
        backgroundColor: Colors.brown[900],
      ),
      backgroundColor: const Color(0xFF1A1207),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Diário'),
                Tab(text: 'Semanal'),
                Tab(text: 'Mensal'),
              ],
            ),
            if (_loading)
              const Expanded(child: Center(child: CircularProgressIndicator())),
            if (_error != null)
              Expanded(
                  child: Center(
                      child:
                          Text(_error!, style: TextStyle(color: Colors.red)))),
            if (!_loading && _error == null && _rank != null)
              Expanded(
                child: TabBarView(
                  children: [
                    _buildRankList(_rank!.daily, 'Hoje'),
                    _buildRankList(_rank!.weekly, 'Semana'),
                    _buildRankList(_rank!.monthly, 'Mês'),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Dia inicia às 18h. Semana: ${_formatDate(weekRange['start'])} até ${_formatDate(weekRange['end'])}',
                style: const TextStyle(color: Colors.amber, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankList(List<RoomTrophy> list, String label) {
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) => Divider(color: Colors.brown[700]),
      itemBuilder: (context, i) {
        final user = list[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.amber[200],
            child:
                Text('${i + 1}', style: const TextStyle(color: Colors.brown)),
          ),
          title:
              Text(user.userName, style: const TextStyle(color: Colors.white)),
          subtitle: Text('Pontos: ${user.points}   Charma: ${user.charma}',
              style: const TextStyle(color: Colors.amber)),
        );
      },
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} ${dt.hour}h';
  }
}
