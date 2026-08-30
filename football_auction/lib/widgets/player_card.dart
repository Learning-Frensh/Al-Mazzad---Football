import 'package:flutter/material.dart';
import '../utils/theme.dart';

class PlayerCard extends StatelessWidget {
  final String name;
  final String position;
  final int rating;
  final String type;
  final String club;
  final String country;
  final bool isHighlighted;
  final VoidCallback? onTap;

  const PlayerCard({
    super.key,
    required this.name,
    required this.position,
    required this.rating,
    required this.type,
    required this.club,
    required this.country,
    this.isHighlighted = false,
    this.onTap,
  });

  Color get _borderColor {
    switch (type) {
      case 'legend':
        return AppColors.legendColor;
      case 'premium':
        return AppColors.premiumColor;
      default:
        return AppColors.regularColor;
    }
  }

  String get _typeEmoji {
    switch (type) {
      case 'legend':
        return '🏆';
      case 'premium':
        return '⭐';
      default:
        return '⚽';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isHighlighted
                ? [
                    _borderColor.withOpacity(0.3),
                    AppColors.surface,
                  ]
                : [
                    AppColors.surface,
                    AppColors.surfaceLight,
                  ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _borderColor,
            width: isHighlighted ? 3 : 2,
          ),
          boxShadow: isHighlighted
              ? [
                  BoxShadow(
                    color: _borderColor.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Country flag
            Text(
              country,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 12),
            
            // Player info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _borderColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _typeEmoji,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          position,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (club.isNotEmpty)
                        Expanded(
                          child: Text(
                            club,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Rating
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _borderColor.withOpacity(0.2),
                border: Border.all(
                  color: _borderColor,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  '$rating',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _borderColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
