import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../widgets/player_card.dart';
import 'match_screen.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Demo teams
  final List<Map<String, dynamic>> _myTeam = [
    {'name': 'Messi', 'position': 'RW', 'rating': 99, 'type': 'legend'},
    {'name': 'Ronaldo', 'position': 'ST', 'rating': 99, 'type': 'legend'},
    {'name': 'Mbappé', 'position': 'ST', 'rating': 91, 'type': 'premium'},
    {'name': 'De Bruyne', 'position': 'CAM', 'rating': 91, 'type': 'premium'},
    {'name': 'van Dijk', 'position': 'CB', 'rating': 90, 'type': 'premium'},
  ];
  
  final List<Map<String, dynamic>> _opponentTeam = [
    {'name': 'Pelé', 'position': 'CAM', 'rating': 99, 'type': 'legend'},
    {'name': 'Maradona', 'position': 'CAM', 'rating': 99, 'type': 'legend'},
    {'name': 'Haaland', 'position': 'ST', 'rating': 91, 'type': 'premium'},
    {'name': 'Bellingham', 'position': 'CM', 'rating': 89, 'type': 'premium'},
    {'name': 'Alisson', 'position': 'GK', 'rating': 89, 'type': 'premium'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفريق'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'فرقتي 🟢'),
            Tab(text: 'فريق الخصم 🔴'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stats
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Rating', '92', AppColors.gold),
                _buildStat('Stars', '8 ⭐', AppColors.gold),
                _buildStat('Legends', '2 🏆', AppColors.legendColor),
                _buildStat('Spent', '180M', AppColors.primary),
              ],
            ),
          ),
          
          // Tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // My team
                _buildTeamList(_myTeam, isMe: true),
                // Opponent team
                _buildTeamList(_opponentTeam, isMe: false),
              ],
            ),
          ),
          
          // Play match button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'اختار التشكيله: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    DropdownButton<String>(
                      value: '4-3-3',
                      items: AppConstants.formations.map((f) {
                        return DropdownMenuItem(value: f, child: Text(f));
                      }).toList(),
                      onChanged: (value) {},
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MatchScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('ابدأ المباراة! ⚽'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamList(List<Map<String, dynamic>> team, {required bool isMe}) {
    // Group by position
    final gk = team.where((p) => p['position'] == 'GK').toList();
    final def = team.where((p) => ['CB', 'LB', 'RB'].contains(p['position'])).toList();
    final mid = team.where((p) => ['CM', 'CDM', 'CAM', 'RM', 'LM', 'RW', 'LW'].contains(p['position'])).toList();
    final fwd = team.where((p) => ['ST', 'CAM'].contains(p['position'])).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (gk.isNotEmpty) ...[
          _buildSection('حارس المرمى', gk),
        ],
        if (def.isNotEmpty) ...[
          _buildSection('المدافعين', def),
        ],
        if (mid.isNotEmpty) ...[
          _buildSection('الوسط', mid),
        ],
        if (fwd.isNotEmpty) ...[
          _buildSection('المهاجمين', fwd),
        ],
      ],
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> players) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ...players.map((p) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: PlayerCard(
            name: p['name'],
            position: p['position'],
            rating: p['rating'],
            type: p['type'],
            club: '',
            country: '🏳️',
          ),
        )),
      ],
    );
  }
}
