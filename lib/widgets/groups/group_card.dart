import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/group.dart';
import 'package:mage_nagoftam/style/color.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final int index;
  final VoidCallback onTap;

  const GroupCard({
    super.key,
    required this.group,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.green1,
      AppColors.green2,
      AppColors.yellow1,
      AppColors.blue1,
      AppColors.purple1,
    ];

    final avatarColor = colors[index % colors.length];

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: avatarColor,
                child: Icon(
                  _groupIcon,
                  size: 24,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  group.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '—',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData get _groupIcon {
    switch (index % 5) {
      case 0:
        return Icons.home_outlined;

      case 1:
        return Icons.people_outline;

      case 2:
        return Icons.family_restroom;

      case 3:
        return Icons.shopping_basket_outlined;

      default:
        return Icons.groups_outlined;
    }
  }
}