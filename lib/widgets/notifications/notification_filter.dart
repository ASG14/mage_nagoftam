import 'package:flutter/material.dart';
import 'package:mage_nagoftam/models/group.dart';
import 'package:mage_nagoftam/style/color.dart';

class NotificationFilter extends StatelessWidget {
  final List<Group> groups;
  final int? selectedGroupId;
  final ValueChanged<int?> onChanged;

  const NotificationFilter({
    super.key,
    required this.groups,
    required this.selectedGroupId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            _FilterItem(
              title: 'همه',
              selected: selectedGroupId == null,
              onTap: () => onChanged(null),
            ),

            const SizedBox(width: 8),

            ...groups.map(
              (group) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _FilterItem(
                  title: group.title,
                  selected: selectedGroupId == group.id,
                  onTap: () => onChanged(group.id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterItem extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _FilterItem({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.green1 : AppColors.gray4,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? AppColors.white2 : AppColors.gray1,
            ),
          ),
        ),
      ),
    );
  }
}