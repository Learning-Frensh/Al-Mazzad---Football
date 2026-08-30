import 'player.dart';

class Team {
  final String id;
  final String name;
  int budget;
  final List<Player> players;
  bool isAI;
  String? aiDifficulty;

  Team({
    required this.id,
    required this.name,
    required this.budget,
    List<Player>? players,
    this.isAI = false,
    this.aiDifficulty,
  }) : players = players ?? [];

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      budget: json['budget'] ?? 0,
      isAI: json['isAI'] ?? false,
      aiDifficulty: json['aiDifficulty'],
      players: (json['players'] as List<dynamic>?)
              ?.map((p) => Player.fromJson(p))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'budget': budget,
      'isAI': isAI,
      'aiDifficulty': aiDifficulty,
      'players': players.map((p) => p.toJson()).toList(),
    };
  }

  int get averageRating {
    if (players.isEmpty) return 0;
    return (players.map((p) => p.rating).reduce((a, b) => a + b) / players.length).round();
  }

  int get starCount {
    return players.fold(0, (sum, p) {
      if (p.isLegend) return sum + 3;
      if (p.isPremium) return sum + 2;
      return sum + 1;
    });
  }

  int get legendCount => players.where((p) => p.isLegend).length;
  int get premiumCount => players.where((p) => p.isPremium).length;

  Player? get goalkeeper => players.firstWhere(
    (p) => p.position == 'GK',
    orElse: () => players.first,
  );

  List<Player> get defenders => players.where((p) => ['CB', 'LB', 'RB'].contains(p.position)).toList();
  List<Player> get midfielders => players.where((p) => ['CM', 'CDM', 'CAM', 'RM', 'LM', 'RW', 'LW'].contains(p.position)).toList();
  List<Player> get forwards => players.where((p) => ['ST', 'CAM'].contains(p.position)).toList();

  int getSpentMoney() {
    return players.fold(0, (sum, p) => sum + (p.boughtFor ?? 0));
  }
}

class GameRoom {
  final String code;
  final String roomId;
  final String playerId;
  final String auctionType;
  final bool vsAI;
  Team? player1;
  Team? player2;

  GameRoom({
    required this.code,
    required this.roomId,
    required this.playerId,
    required this.auctionType,
    this.vsAI = false,
    this.player1,
    this.player2,
  });

  factory GameRoom.fromJson(Map<String, dynamic> json) {
    return GameRoom(
      code: json['roomCode'] ?? '',
      roomId: json['roomId'] ?? '',
      playerId: json['playerId'] ?? '',
      auctionType: json['auctionType'] ?? 'squad5',
      vsAI: json['vsAI'] ?? false,
      player1: json['player1'] != null ? Team.fromJson(json['player1']) : null,
      player2: json['player2'] != null ? Team.fromJson(json['player2']) : null,
    );
  }
}
