import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/group.dart';
import 'package:mage_nagoftam/screens/group_details.dart';
import 'package:mage_nagoftam/style/color.dart';
import 'package:mage_nagoftam/style/typography.dart';

class GroupOrdersAppBar
    extends StatelessWidget
    implements PreferredSizeWidget {
  final Group group;
  final int memberCount;

  const GroupOrdersAppBar({
    super.key,
    required this.group,
    required this.memberCount,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(
        kToolbarHeight,
      );

  void _openDetails(
    BuildContext context,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            GroupDetailsScreen(
          group: group,
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AppBar(
      elevation: 0,

      scrolledUnderElevation: 0,

      backgroundColor:
          AppColors.white2,

      surfaceTintColor:
          Colors.transparent,

      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },

        icon: const Icon(
          Icons.arrow_back,
        ),
      ),

      titleSpacing: 0,

      title: Row(
        children: [
          CircleAvatar(
            radius: 20,

            backgroundColor:
                _avatarColor(group.id),

            child: const Icon(
              Icons.groups,
              size: 21,
              color:
                  AppColors.white2,
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [
                Text(
                  group.title,

                  maxLines: 1,

                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      AppTypography.h6
                          .copyWith(
                    color:
                        AppColors.gray1,

                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 1,
                ),

                Text(
                  '$memberCount عضو',

                  style:
                      AppTypography.h10
                          .copyWith(
                    color:
                        AppColors.gray2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'details') {
              _openDetails(context);
            }

            if (value == 'leave') {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                const SnackBar(
                  content: Text(
                    'قابلیت ترک گروه در مرحله بعد اضافه می‌شود.',
                  ),
                ),
              );
            }
          },

          itemBuilder: (context) {
            return const [
              PopupMenuItem<String>(
                value: 'details',

                child: Text(
                  'مشخصات گروه',
                ),
              ),

              PopupMenuItem<String>(
                value: 'leave',

                child: Text(
                  'ترک گروه',
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  Color _avatarColor(
    int groupId,
  ) {
    const colors = [
      AppColors.green2,
      Color(0xFF2980B9),
      Color(0xFF8E44AD),
      AppColors.orange1,
      Color(0xFF27AE60),
      Color(0xFFD35400),
    ];

    return colors[
        groupId % colors.length];
  }
}