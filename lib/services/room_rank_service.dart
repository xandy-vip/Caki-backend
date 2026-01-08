import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room_trophy.dart';

class RoomRankService {
  Future<RoomRank> fetchRoomRank(String roomId) async {
    final url =
        Uri.parse('https://caki-backend.onrender.com/rooms/$roomId/rank');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      List<RoomTrophy> parseList(List<dynamic> list) => list
          .map((e) => RoomTrophy(
                userId: e['user'] ?? '',
                userName: e['user'] ?? '',
                points: e['points'] ?? 0,
                charma: e['charma'] ?? 0,
              ))
          .toList();
      return RoomRank(
        daily: parseList(data['daily'] ?? []),
        weekly: parseList(data['weekly'] ?? []),
        monthly: parseList(data['monthly'] ?? []),
      );
    } else {
      throw Exception('Erro ao buscar ranking');
    }
  }

  // Lógica para calcular início/fim do dia e semana conforme regras do app
  DateTime getAppDayStart(DateTime now) {
    final today18 = DateTime(now.year, now.month, now.day, 18);
    if (now.isBefore(today18)) {
      return today18.subtract(Duration(days: 1));
    } else {
      return today18;
    }
  }

  Map<String, DateTime> getAppWeekRange(DateTime now) {
    // Semana inicia domingo 18h e termina domingo 18h
    final appDayStart = getAppDayStart(now);
    int daysToSunday = appDayStart.weekday % 7;
    DateTime weekStart = appDayStart.subtract(Duration(days: daysToSunday));
    weekStart = DateTime(weekStart.year, weekStart.month, weekStart.day, 18);
    DateTime weekEnd = weekStart.add(Duration(days: 7));
    return {'start': weekStart, 'end': weekEnd};
  }
}
