import 'package:flutter/material.dart';
import '../utils/theme.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late AnimationController _timerController;
  
  int _myScore = 0;
  int _opponentScore = 0;
  int _minute = 0;
  bool _matchStarted = false;
  bool _matchEnded = false;
  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _timerController = AnimationController(
      duration: const Duration(seconds: 90),
      vsync: this,
    );
  }

  void _startMatch() {
    setState(() => _matchStarted = true);
    
    _timerController.addListener(() {
      if (!mounted) return;
      setState(() {
        _minute = _timerController.value.round();
      });
    });
    
    _timerController.forward();
    
    // Simulate goals
    Future.delayed(const Duration(seconds: 15), () {
      if (!mounted || _matchEnded) return;
      _simulateGoal(isMyGoal: true);
    });
    
    Future.delayed(const Duration(seconds: 25), () {
      if (!mounted || _matchEnded) return;
      _simulateGoal(isMyGoal: false);
    });
    
    Future.delayed(const Duration(seconds: 45), () {
      if (!mounted || _matchEnded) return;
      _simulateGoal(isMyGoal: true);
    });
    
    Future.delayed(const Duration(seconds: 60), () {
      if (!mounted) return;
      _endMatch();
    });
  }

  void _simulateGoal({required bool isMyGoal}) {
    setState(() {
      if (isMyGoal) {
        _myScore++;
        _events.add({
          'minute': _minute,
          'type': 'goal',
          'team': 'my',
          'player': 'Messi',
        });
      } else {
        _opponentScore++;
        _events.add({
          'minute': _minute,
          'type': 'goal',
          'team': 'opponent',
          'player': 'Ronaldo',
        });
      }
    });
    _scoreController.forward(from: 0);
  }

  void _endMatch() {
    setState(() {
      _matchEnded = true;
      _minute = 90;
    });
    _timerController.stop();
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المباراة'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Scoreboard
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.fieldGreen.withOpacity(0.3),
                  AppColors.background,
                ],
              ),
            ),
            child: Column(
              children: [
                // Teams
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTeamColumn('فرقتي', '🟢', true),
                    AnimatedBuilder(
                      animation: _scoreController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1 + (_scoreController.value * 0.2),
                          child: Text(
                            '$_myScore - $_opponentScore',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildTeamColumn('الخصم', '🔴', false),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Timer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: _minute > 80 ? AppColors.error : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _matchEnded ? '90\' END' : '\'$_minute',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _minute > 80 ? Colors.white : AppColors.gold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Match events
          Expanded(
            child: _matchStarted
                ? ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      return _buildEventItem(event);
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.stadium,
                          size: 80,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'جاهز للمباراة؟',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'الذكاء الاصطناعي سيحلل الفريقين',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _startMatch,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('ابدأ المباراة!'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          
          // Result
          if (_matchEnded) _buildResultSection(),
        ],
      ),
    );
  }

  Widget _buildTeamColumn(String name, String emoji, bool isLeft) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEventItem(Map<String, dynamic> event) {
    final isMyGoal = event['team'] == 'my';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMyGoal
            ? AppColors.success.withOpacity(0.2)
            : AppColors.error.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isMyGoal ? AppColors.success : AppColors.error,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${event['minute']}\'',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.gold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.sports_soccer,
            color: isMyGoal ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${event['player']} 🎯',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isMyGoal ? AppColors.success : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection() {
    final won = _myScore > _opponentScore;
    final draw = _myScore == _opponentScore;
    
    return Container(
      padding: const EdgeInsets.all(24),
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
          Icon(
            won ? Icons.emoji_events : (draw ? Icons.handshake : Icons.sports),
            size: 64,
            color: won ? AppColors.gold : AppColors.textSecondary,
          ),
          const SizedBox(height: 8),
          Text(
            won ? '🎉 فزت!' : (draw ? '🤝 تعادل!' : '😢 خسرت!'),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: won ? AppColors.gold : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildResultStat('تقيمي', '89', AppColors.primary),
              _buildResultStat('أفضل لاعب', 'Messi', AppColors.gold),
              _buildResultStat('نجوم', '★★★', AppColors.gold),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('الرئيسية'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('لعب مرة أخرى'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultStat(String label, String value, Color color) {
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
}
