class RoomTrophy {
  final String userId;
  final String userName;
  final int points;
  final int charma;

  RoomTrophy({
    required this.userId,
    required this.userName,
    required this.points,
    required this.charma,
  });
}

class RoomRank {
  final List<RoomTrophy> daily;
  final List<RoomTrophy> weekly;
  final List<RoomTrophy> monthly;

  RoomRank({
    required this.daily,
    required this.weekly,
    required this.monthly,
  });
}
