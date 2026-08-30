class Player {
  final String id;
  final String name;
  final String position;
  final int rating;
  final int price;
  final String type;
  final String club;
  final String country;
  int? boughtFor;

  Player({
    required this.id,
    required this.name,
    required this.position,
    required this.rating,
    required this.price,
    required this.type,
    required this.club,
    required this.country,
    this.boughtFor,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      position: json['position'] ?? '',
      rating: json['rating'] ?? 0,
      price: json['price'] ?? 0,
      type: json['type'] ?? 'regular',
      club: json['club'] ?? '',
      country: json['country'] ?? '🏳️',
      boughtFor: json['boughtFor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'rating': rating,
      'price': price,
      'type': type,
      'club': club,
      'country': country,
      'boughtFor': boughtFor,
    };
  }

  Player copyWith({
    String? id,
    String? name,
    String? position,
    int? rating,
    int? price,
    String? type,
    String? club,
    String? country,
    int? boughtFor,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      type: type ?? this.type,
      club: club ?? this.club,
      country: country ?? this.country,
      boughtFor: boughtFor ?? this.boughtFor,
    );
  }

  bool get isLegend => type == 'legend';
  bool get isPremium => type == 'premium';
  bool get isRegular => type == 'regular';

  String get typeLabel {
    switch (type) {
      case 'legend':
        return '🏆 أسطورة';
      case 'premium':
        return '⭐ مميز';
      default:
        return '⚽ عادي';
    }
  }

  String get positionLabel {
    const labels = {
      'GK': 'حارس',
      'RB': 'ظهير',
      'CB': 'مدافع',
      'LB': 'ظهير',
      'CDM': 'وسط دفاع',
      'CM': 'وسط',
      'RM': 'جناح',
      'LM': 'جناح',
      'CAM': 'رقم 10',
      'RW': 'جناح',
      'LW': 'جناح',
      'ST': 'مهاجم',
    };
    return labels[position] ?? position;
  }
}
