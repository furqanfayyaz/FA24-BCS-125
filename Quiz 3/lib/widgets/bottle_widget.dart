// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/game_state.dart';

class BottleWidget extends StatelessWidget {
  final Bottle bottle;
  final bool isSelected;
  final VoidCallback onTap;

  const BottleWidget({
    super.key,
    required this.bottle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, isSelected ? -16 : 0, 0),
        child: Container(
          width: 54,
          height: 160,
          padding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.indigo.shade50 : Colors.white.withOpacity(0.9),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
              bottom: Radius.circular(24),
            ),
            border: Border.all(
              color: isSelected ? Colors.indigo : Colors.grey.shade400,
              width: isSelected ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected ? Colors.indigo.withOpacity(0.3) : Colors.black12,
                blurRadius: isSelected ? 10 : 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Liquid Units inside bottle (from bottom to top)
              ...List.generate(bottle.capacity, (index) {
                final colorIndex = index;
                final hasColor = colorIndex < bottle.colors.length;
                final color = hasColor ? bottle.colors[colorIndex] : Colors.transparent;

                return Container(
                  height: 31,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.vertical(
                      top: colorIndex == bottle.colors.length - 1 ? const Radius.circular(4) : Radius.zero,
                      bottom: colorIndex == 0 ? const Radius.circular(16) : Radius.zero,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
