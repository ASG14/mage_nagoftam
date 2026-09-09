import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/group.dart';

class GroupOrdersAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final Group group;

  const GroupOrdersAppBar({
    super.key,
    required this.group,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),

      titleSpacing: 0,

      title: Row(
        children: [

          CircleAvatar(
            radius: 20,
            child: Text(
              group.title.isNotEmpty
                  ? group.title[0]
                  : '?',
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              group.title,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),

      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'details') {
              // بعداً → GroupDetailsScreen
            }

            if (value == 'leave') {
              // بعداً → Leave Group
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'details',
              child: Text('مشخصات گروه'),
            ),
            PopupMenuItem(
              value: 'leave',
              child: Text('ترک گروه'),
            ),
          ],
        ),
      ],
    );
  }
}