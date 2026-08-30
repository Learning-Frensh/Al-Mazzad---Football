import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_provider.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import 'auction_screen.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _nameController = TextEditingController();
  final _serverController = TextEditingController(text: 'http://localhost:3000');
  
  String _auctionType = AppConstants.auctionSquad5;
  String _difficulty = AppConstants.aiMedium;
  bool _vsAI = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _serverController.dispose();
    super.dispose();
  }

  Future<void> _createRoom() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final provider = Provider.of<GameProvider>(context, listen: false);
    
    await provider.createRoom(
      playerName: _nameController.text,
      auctionType: _auctionType,
      vsAI: _vsAI,
      aiDifficulty: _difficulty,
      serverUrl: _serverController.text,
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuctionScreen(),
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء روم جديد'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            const Text(
              'اسمك',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 24),

            // Server URL
            const Text(
              'عنوان السيرفر',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _serverController,
              decoration: const InputDecoration(
                hintText: 'http://localhost:3000',
                prefixIcon: Icon(Icons.dns),
              ),
            ),
            const SizedBox(height: 24),

            // Auction Type
            const Text(
              'نوع المزاد',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildAuctionTypeCard(
              AppConstants.auctionSquad5,
              '🖐️ مزاد خماسي',
              '5 لاعبين - 100 مليون',
              Icons.groups,
            ),
            const SizedBox(height: 8),
            _buildAuctionTypeCard(
              AppConstants.auctionTeam11,
              '⚽ فريق كامل',
              '11 لاعب - 200 مليون',
              Icons.people,
            ),
            const SizedBox(height: 8),
            _buildAuctionTypeCard(
              AppConstants.auctionBench,
              '🏆 دكه كاملة',
              'فريق كامل - مليار',
              Icons.emoji_events,
            ),
            const SizedBox(height: 24),

            // VS AI Toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _vsAI ? Icons.smart_toy : Icons.people,
                    color: _vsAI ? AppColors.gold : AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _vsAI ? 'ضد AI' : 'ضد لاعب',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _vsAI ? 'تلعب ضد الذكاء الاصطناعي' : 'ادعو صديقك',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _vsAI,
                    onChanged: (value) => setState(() => _vsAI = value),
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Difficulty (only if VS AI)
            if (_vsAI) ...[
              const Text(
                'مستوى الصعوبة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildDifficultyChip(AppConstants.aiEasy, '� Easy'),
                  const SizedBox(width: 8),
                  _buildDifficultyChip(AppConstants.aiMedium, '🎯 Medium'),
                  const SizedBox(width: 8),
                  _buildDifficultyChip(AppConstants.aiHard, '🔥 Hard'),
                ],
              ),
              const SizedBox(height: 32),
            ],

            // Create Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createRoom,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(_vsAI ? 'ابدأ اللعب' : 'إنشاء الروم'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuctionTypeCard(String type, String title, String subtitle, IconData icon) {
    final isSelected = _auctionType == type;
    return GestureDetector(
      onTap: () => setState(() => _auctionType = type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String diff, String label) {
    final isSelected = _difficulty == diff;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _difficulty = diff),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.gold.withOpacity(0.2) : AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.gold : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.gold : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
