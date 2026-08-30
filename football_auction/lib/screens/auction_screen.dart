import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_provider.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../widgets/player_card.dart';
import '../widgets/auction_timer.dart';
import 'team_screen.dart';

class AuctionScreen extends StatefulWidget {
  const AuctionScreen({super.key});

  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _timer;
  int _timeLeft = 30;
  int _currentBid = 0;
  int _bidAmount = 1;
  bool _isMyTurn = false;
  bool _auctionStarted = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    // Start auction simulation
    _startSimulation();
  }

  void _startSimulation() {
    // Simulate auction for demo
    setState(() {
      _auctionStarted = true;
      _currentBid = 100;
      _timeLeft = 30;
      _isMyTurn = true;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        _timeLeft--;
        
        if (_timeLeft <= 0) {
          // Auto pass
          _passTurn();
        }
      });
    });
  }

  void _placeBid() {
    if (_bidAmount > 0) {
      setState(() {
        _currentBid += _bidAmount;
        _timeLeft = 30;
        _isMyTurn = false;
      });
      
      // Simulate opponent response
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _isMyTurn = true;
        });
      });
    }
  }

  void _passTurn() {
    setState(() {
      _isMyTurn = false;
      _timeLeft = 30;
    });
    
    // Simulate opponent response
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isMyTurn = true;
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مزاد الكرة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share room code
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Room info
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoChip(Icons.vpn_key, 'ABC123'),
                _buildInfoChip(Icons.timer, '$_timeLeft s'),
                _buildInfoChip(Icons.monetization_on, '$_currentBid M'),
              ],
            ),
          ),
          
          // Turn indicator
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(12),
                color: _isMyTurn
                    ? AppColors.success.withOpacity(_pulseController.value * 0.3)
                    : AppColors.error.withOpacity(0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isMyTurn ? Icons.touch_app : Icons.hourglass_empty,
                      color: _isMyTurn ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isMyTurn ? 'دورك!' : 'دور الخصم...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _isMyTurn ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Current player card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'اللاعب المعروض',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PlayerCard(
                    name: 'Messi',
                    position: 'RW',
                    rating: 99,
                    type: 'legend',
                    club: 'Inter Miami',
                    country: '🇦🇷',
                    isHighlighted: true,
                  ),
                  const SizedBox(height: 24),
                  
                  // Bid controls
                  if (_auctionStarted)
                    Column(
                      children: [
                        Text(
                          'السعر الحالي: $_currentBid مليون',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Bid amount
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: _bidAmount > 1
                                  ? () => setState(() => _bidAmount--)
                                  : null,
                              icon: const Icon(Icons.remove_circle),
                              iconSize: 40,
                              color: AppColors.primary,
                            ),
                            Container(
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$_bidAmount M',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _bidAmount++),
                              icon: const Icon(Icons.add_circle),
                              iconSize: 40,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isMyTurn ? _passTurn : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.surfaceLight,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text('ممر'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: _isMyTurn ? _placeBid : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: Text(
                                  'زايد ${_currentBid + _bidAmount}M',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          
          // My budget
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBudgetInfo('فلوسي', '95 M', AppColors.gold),
                _buildBudgetInfo('فرقتي', '3 لاعبين', AppColors.primary),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TeamScreen(),
                      ),
                    );
                  },
                  child: const Text('فرقتي'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetInfo(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
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
