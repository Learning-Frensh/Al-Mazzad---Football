class AppConstants {
  // Server URL - Change this to your server address
  static const String serverUrl = 'http://YOUR_SERVER_IP:3000';
  
  // Auction types
  static const String auctionSquad5 = 'squad5';
  static const String auctionTeam11 = 'team11';
  static const String auctionBench = 'bench';
  
  // Auction prices (in millions)
  static const int squad5Price = 100;
  static const int team11Price = 200;
  static const int benchPrice = 1000;
  
  // Auction settings
  static const int turnTimeSeconds = 30;
  static const int minBidIncrement = 1;
  static const int benchBidIncrement = 10;
  
  // Player types
  static const String typeLegend = 'legend';
  static const String typePremium = 'premium';
  static const String typeRegular = 'regular';
  
  // Positions
  static const Map<String, String> positionNames = {
    'GK': 'حارس مرمى',
    'RB': 'ظهير أيمن',
    'CB': 'مدافع',
    'LB': 'ظهير أيسر',
    'CDM': 'وسط دفاعي',
    'CM': 'وسط',
    'RM': 'جناح أيمن',
    'LM': 'جناح أيسر',
    'CAM': 'رقم 10',
    'RW': 'جناح أيمن',
    'LW': 'جناح أيسر',
    'ST': 'مهاجم',
  };
  
  // Formations
  static const List<String> formations = [
    '4-3-3',
    '4-2-3-1',
    '4-4-2',
    '3-5-2',
    '5-3-2',
  ];
  
  // AI Difficulty
  static const String aiEasy = 'easy';
  static const String aiMedium = 'medium';
  static const String aiHard = 'hard';
  
  static String getDifficultyName(String difficulty) {
    switch (difficulty) {
      case aiEasy:
        return 'سهل';
      case aiMedium:
        return 'متوسط';
      case aiHard:
        return 'صعب';
      default:
        return 'متوسط';
    }
  }
  
  static String getAuctionTypeName(String type) {
    switch (type) {
      case auctionSquad5:
        return 'خماسي';
      case auctionTeam11:
        return 'فريق كامل';
      case auctionBench:
        return 'دكه كاملة';
      default:
        return type;
    }
  }
}
