import 'package:flutter/material.dart';
import 'package:mage_nagoftam/models/group.dart';
import 'package:mage_nagoftam/style/color.dart';

class GroupCard extends StatelessWidget {
  final Group group;

  final int index;

  final bool isOwner;

  final VoidCallback onTap;
  final VoidCallback onMembers;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GroupCard({
    required this.group,
    required this.index,
    required this.isOwner,
    required this.onTap,
    required this.onMembers,
    required this.onEdit,
    required this.onDelete,
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // ----------------------------------------
              // Group Avatar
              // ----------------------------------------

              CircleAvatar(
                radius: 25,
                backgroundColor: avatarColor,
                child: Icon(_groupIcon, size: 24, color: Colors.white),
              ),

              const SizedBox(width: 14),

              // ----------------------------------------
              // Group Name
              // ----------------------------------------
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

              // ----------------------------------------
              // Unfinished Orders
              // ----------------------------------------
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '—',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(width: 6),

              // ----------------------------------------
              // Menu
              // ----------------------------------------
              PopupMenuButton<String>(
                tooltip: 'گزینه‌های گروه',
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'members':
                      onMembers();
                      break;

                    case 'edit':
                      if (isOwner) {
                        onEdit();
                      }
                      break;

                    case 'delete':
                      if (isOwner) {
                        onDelete();
                      }
                      break;
                  }
                },
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 'members',
                      child: Text('اعضای گروه'),
                    ),
                    if (isOwner)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('ویرایش گروه'),
                      ),
                    if (isOwner)
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'حذف گروه',
                          style: TextStyle(color: AppColors.red1),
                        ),
                      ),
                  ];
                },
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
