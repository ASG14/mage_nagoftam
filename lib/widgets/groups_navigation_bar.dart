import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/group.dart';

class GroupsBar extends StatefulWidget {
  final Group group;

  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const GroupsBar({
    super.key,
    required this.group,
    this.onPrevious,
    this.onNext,
  });

  @override
  State<GroupsBar> createState() => _GroupsBarState();
}

class _GroupsBarState extends State<GroupsBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),

      child: Row(
        children: [
          // گروه قبلی
          SizedBox(
            width: 48,
            child: IconButton(
              onPressed: widget.onPrevious,
              icon: const Icon(
                Icons.chevron_left,
              ),
            ),
          ),

          // نام گروه فعلی
          Expanded(
            child: Text(
              widget.group.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
          ),

          // گروه بعدی
          SizedBox(
            width: 48,
            child: IconButton(
              onPressed: widget.onNext,
              icon: const Icon(
                Icons.chevron_right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}