import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/create_room_screen.dart';
import 'screens/join_room_screen.dart';
import 'screens/auction_screen.dart';
import 'screens/team_screen.dart';
import 'screens/match_screen.dart';
import 'services/game_provider.dart';
import 'utils/theme.dart';

void main() {
  runApp(const FootballAuctionApp());
}

class FootballAuctionApp extends StatelessWidget {
  const FootballAuctionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: MaterialApp(
        title: 'Football Auction',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/create': (context) => const CreateRoomScreen(),
          '/join': (context) => const JoinRoomScreen(),
          '/auction': (context) => const AuctionScreen(),
          '/team': (context) => const TeamScreen(),
          '/match': (context) => const MatchScreen(),
        },
      ),
    );
  }
}
