import 'package:flutter/material.dart';

import 'package:begir/models/group.dart';
import 'package:begir/models/order.dart';
import 'package:begir/models/user.dart';

import 'package:begir/tempDB/groups.dart';
import 'package:begir/tempDB/orders.dart';
import 'package:begir/tempDB/manager.dart';

import 'package:begir/widgets/add_order.dart';
import 'package:begir/widgets/bottom_navigation_bar.dart';
import 'package:begir/widgets/drawer.dart';
import 'package:begir/widgets/group_items.dart';
import 'package:begir/widgets/groups_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Groups _groups = Groups();
  final Orders _orders = Orders();
  final Manager _manager = Manager();

  late User _currentUser;
  late Group _currentGroup;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) {
      return;
    }

    _initialize();
    _isInitialized = true;
  }

  // --------------------------------------------------
  // Initialization
  // --------------------------------------------------

  void _initialize() {
    final now = DateTime.now();

    _currentUser = User(
      id: 'user_1',
      phoneNumber: 9120000000,
      firstName: 'علی',
      lastName: 'احمدی',
      registeredAt: now,
    );

    _createTestGroups(now);
    _createTestOrders(now);

    final arguments =
        ModalRoute.of(context)?.settings.arguments;

    if (arguments is Group) {
      final selectedGroup = _groups.getById(
        arguments.getId(),
      );

      if (selectedGroup != null) {
        _currentGroup = selectedGroup;
        return;
      }
    }

    // اگر از صفحه دیگری بدون انتخاب گروه وارد Home شدیم،
    // اولین گروه به صورت پیش‌فرض انتخاب می‌شود.
    _currentGroup = _groups.getAll().first;
  }

  // --------------------------------------------------
  // Test Groups
  // --------------------------------------------------

  void _createTestGroups(DateTime now) {
    final familyGroup = Group(
      id: 'group_1',
      creator: _currentUser,
      createdAt: now,
      groupTitle: 'خانواده احمدی',
    );

    final homeGroup = Group(
      id: 'group_2',
      creator: _currentUser,
      createdAt: now,
      groupTitle: 'خانه',
    );

    final dormGroup = Group(
      id: 'group_3',
      creator: _currentUser,
      createdAt: now,
      groupTitle: 'خوابگاه',
    );

    _groups.add(familyGroup);
    _groups.add(homeGroup);
    _groups.add(dormGroup);
  }

  // --------------------------------------------------
  // Test Orders
  // --------------------------------------------------

  void _createTestOrders(DateTime now) {
    final groups = _groups.getAll();

    final familyGroup = groups[0];
    final homeGroup = groups[1];
    final dormGroup = groups[2];

    final order1 = Order(
      itemId: 'order_1',
      createdBy: _currentUser,
      title: 'شیر کم‌چرب',
      quantity: '۲ بطری',
      createdAt: now,
      deadline: now.add(
        const Duration(days: 1),
      ),
      itemPriority: Priority.high,
    );

    final order2 = Order(
      itemId: 'order_2',
      createdBy: _currentUser,
      title: 'نان سنگک',
      quantity: '۳ عدد',
      createdAt: now.subtract(
        const Duration(minutes: 30),
      ),
      deadline: now.add(
        const Duration(days: 1),
      ),
      itemPriority: Priority.medium,
    );

    final order3 = Order(
      itemId: 'order_3',
      createdBy: _currentUser,
      title: 'مایع ظرفشویی',
      quantity: '۱ عدد',
      createdAt: now.subtract(
        const Duration(hours: 1),
      ),
      deadline: now.add(
        const Duration(days: 2),
      ),
      itemPriority: Priority.low,
    );

    final order4 = Order(
      itemId: 'order_4',
      createdBy: _currentUser,
      title: 'برنج',
      quantity: '۵ کیلو',
      createdAt: now.subtract(
        const Duration(hours: 2),
      ),
      deadline: now.add(
        const Duration(days: 2),
      ),
      itemPriority: Priority.high,
    );

    _addTestOrder(
      group: familyGroup,
      order: order1,
    );

    _addTestOrder(
      group: familyGroup,
      order: order2,
    );

    _addTestOrder(
      group: homeGroup,
      order: order3,
    );

    _addTestOrder(
      group: dormGroup,
      order: order4,
    );
  }

  void _addTestOrder({
    required Group group,
    required Order order,
  }) {
    _orders.add(order);

    _manager.addOrderToGroup(
      group: group,
      order: order,
    );
  }

  // --------------------------------------------------
  // Order Actions
  // --------------------------------------------------

  void _addOrder(Order order) {
    setState(() {
      _orders.add(order);

      _manager.addOrderToGroup(
        group: _currentGroup,
        order: order,
      );
    });
  }

  void _reserveOrder(Order order) {
    setState(() {
      order.setItemStatus(Status.reserved);
      order.setReservedBy(_currentUser);
      order.setReservedAt(DateTime.now());
    });
  }

  void _completeOrder(Order order) {
    setState(() {
      order.setItemStatus(Status.complete);
    });
  }

  // --------------------------------------------------
  // Group Navigation
  // --------------------------------------------------

  void _previousGroup() {
    final groups = _groups.getAll();

    final currentIndex =
        groups.indexOf(_currentGroup);

    if (currentIndex > 0) {
      setState(() {
        _currentGroup =
            groups[currentIndex - 1];
      });
    }
  }

  void _nextGroup() {
    final groups = _groups.getAll();

    final currentIndex =
        groups.indexOf(_currentGroup);

    if (currentIndex < groups.length - 1) {
      setState(() {
        _currentGroup =
            groups[currentIndex + 1];
      });
    }
  }

  // --------------------------------------------------
  // Build
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final orders =
        _manager.getOrdersForGroup(
      _currentGroup,
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سبد خرید'),
        ),

        drawer: const MyDrawer(),

        floatingActionButton:
            FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AddOrder(
                  user: _currentUser,
                  onOrderCreated: _addOrder,
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),

        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              GroupsBar(
                group: _currentGroup,

                onPrevious:
                    _previousGroup,

                onNext:
                    _nextGroup,
              ),

              const SizedBox(height: 12),

              Expanded(
                child: GroupItems(
                  orders: orders,

                  onReserve:
                      _reserveOrder,

                  onComplete:
                      _completeOrder,
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar:
            const MyBottomNavigationBar(),
      ),
    );
  }
}