import 'package:flutter/material.dart';

import 'package:begir/models/group.dart';
import 'package:begir/models/order.dart';

import 'package:begir/services/auth_service.dart';
import 'package:begir/services/group_service.dart';
import 'package:begir/services/order_service.dart';

import 'package:begir/widgets/add_order.dart';
import 'package:begir/widgets/bottom_navigation_bar.dart';
import 'package:begir/widgets/drawer.dart';
import 'package:begir/widgets/orders_list.dart';
import 'package:begir/widgets/groups_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  // --------------------------------------------------
  // Data
  // --------------------------------------------------

  List<Group> _groups = [];

  List<Order> _orders = [];

  Group? _currentGroup;

  int? _currentUserId;

  // --------------------------------------------------
  // Loading
  // --------------------------------------------------

  bool _isLoadingGroups = true;

  bool _isLoadingOrders = false;

  // --------------------------------------------------
  // Errors
  // --------------------------------------------------

  String? _groupsError;

  String? _ordersError;

  // --------------------------------------------------
  // Init
  // --------------------------------------------------

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    _currentUserId =
        await AuthService.getUserId();

    if (!mounted) return;

    await _loadGroups();
  }

  // --------------------------------------------------
  // Load Groups
  // --------------------------------------------------

  Future<void> _loadGroups() async {
    setState(() {
      _isLoadingGroups = true;
      _groupsError = null;
    });

    try {
      final groups =
          await GroupService.getGroups();

      if (!mounted) return;

      if (groups.isEmpty) {
        setState(() {
          _groups = [];
          _currentGroup = null;
          _orders = [];
          _isLoadingGroups = false;
        });

        return;
      }

      Group selectedGroup =
          groups.first;

      final arguments =
          ModalRoute.of(context)
              ?.settings
              .arguments;

      if (arguments is Group) {
        for (final group in groups) {
          if (group.id ==
              arguments.id) {
            selectedGroup = group;
            break;
          }
        }
      }

      setState(() {
        _groups = groups;
        _currentGroup = selectedGroup;
        _isLoadingGroups = false;
      });

      await _loadOrders();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingGroups = false;
        _groupsError =
            'دریافت گروه‌ها انجام نشد';
      });
    }
  }

  // --------------------------------------------------
  // Load Orders
  // --------------------------------------------------

  Future<void> _loadOrders() async {
    final group = _currentGroup;

    if (group == null) {
      setState(() {
        _orders = [];
        _isLoadingOrders = false;
      });

      return;
    }

    setState(() {
      _isLoadingOrders = true;
      _ordersError = null;
    });

    try {
      final orders =
          await OrderService.getOrders(
        groupId: group.id,
      );

      if (!mounted) return;

      setState(() {
        _orders = orders;
        _isLoadingOrders = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingOrders = false;
        _ordersError =
            'دریافت سفارش‌ها انجام نشد';
      });
    }
  }

  // --------------------------------------------------
  // Add Order
  // --------------------------------------------------

  void _showAddOrderDialog() {
    final group = _currentGroup;

    if (group == null) {
      _showMessage(
        'ابتدا یک گروه انتخاب کنید',
      );

      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AddOrder(
          groupId: group.id,
          onOrderCreated: (order) {
            setState(() {
              _orders.insert(
                0,
                order,
              );
            });
          },
        );
      },
    );
  }

  // --------------------------------------------------
  // Reserve Order
  // --------------------------------------------------

  Future<void> _reserveOrder(
    Order order,
  ) async {
    try {
      await OrderService.assignOrder(
        orderId: order.id,
      );

      if (!mounted) return;

      // Update the current order immediately.
      //
      // This prevents the UI from waiting for another
      // request to orders/list.php before changing the
      // button from "بسپرش به من".
      setState(() {
        order.status = Status.reserved;
        order.assignedUserId =
            _currentUserId;
        order.assignedUserName =
            'شما';
      });

      _showMessage(
        'سفارش به شما سپرده شد',
      );

      // Refresh from server after updating the UI.
      //
      // If the server returns the correct state,
      // the local state will be synchronized with it.
      await _loadOrders();
    } catch (e) {
      if (!mounted) return;

      final error = e.toString();

      if (error.contains(
        'already_assigned',
      )) {
        _showMessage(
          'این سفارش قبلاً به شخص دیگری سپرده شده است',
        );

        await _loadOrders();

        return;
      }

      if (error.contains(
        'forbidden',
      )) {
        _showMessage(
          'شما عضو این گروه نیستید',
        );

        return;
      }

      if (error.contains(
        'not_found',
      )) {
        _showMessage(
          'سفارش پیدا نشد',
        );

        await _loadOrders();

        return;
      }

      _showMessage(
        'سپردن سفارش انجام نشد',
      );
    }
  }

  // --------------------------------------------------
  // Complete Order
  // --------------------------------------------------

  Future<void> _completeOrder(
    Order order,
  ) async {
    if (order.assignedUserId !=
        _currentUserId) {
      _showMessage(
        'شما مسئول این سفارش نیستید',
      );

      return;
    }

    try {
      await OrderService.completeOrder(
        orderId: order.id,
      );

      if (!mounted) return;

      setState(() {
        order.status =
            Status.completed;
      });

      _showMessage(
        'سفارش با موفقیت تکمیل شد',
      );

      await _loadOrders();
    } catch (e) {
      if (!mounted) return;

      final error = e.toString();

      if (error.contains(
        'forbidden',
      )) {
        _showMessage(
          'شما مسئول این سفارش نیستید',
        );

        return;
      }

      _showMessage(
        'تکمیل سفارش انجام نشد',
      );
    }
  }

  // --------------------------------------------------
  // Delete Order
  // --------------------------------------------------

  Future<void> _deleteOrder(
    Order order,
  ) async {
    if (order.createdBy !=
        _currentUserId) {
      _showMessage(
        'شما اجازه حذف این سفارش را ندارید',
      );

      return;
    }

    try {
      await OrderService.deleteOrder(
        orderId: order.id,
      );

      if (!mounted) return;

      setState(() {
        _orders.removeWhere(
          (item) =>
              item.id == order.id,
        );
      });

      _showMessage(
        'سفارش با موفقیت حذف شد',
      );
    } catch (e) {
      if (!mounted) return;

      final error = e.toString();

      if (error.contains(
        'forbidden',
      )) {
        _showMessage(
          'شما اجازه حذف این سفارش را ندارید',
        );

        return;
      }

      if (error.contains(
        'not_found',
      )) {
        _showMessage(
          'سفارش پیدا نشد',
        );

        await _loadOrders();

        return;
      }

      _showMessage(
        'حذف سفارش انجام نشد',
      );
    }
  }

  // --------------------------------------------------
  // Previous Group
  // --------------------------------------------------

  Future<void> _previousGroup() async {
    if (_groups.isEmpty ||
        _currentGroup == null) {
      return;
    }

    final currentIndex =
        _groups.indexWhere(
      (group) =>
          group.id ==
          _currentGroup!.id,
    );

    if (currentIndex <= 0) {
      return;
    }

    setState(() {
      _currentGroup =
          _groups[currentIndex - 1];

      _orders = [];

      _ordersError = null;
    });

    await _loadOrders();
  }

  // --------------------------------------------------
  // Next Group
  // --------------------------------------------------

  Future<void> _nextGroup() async {
    if (_groups.isEmpty ||
        _currentGroup == null) {
      return;
    }

    final currentIndex =
        _groups.indexWhere(
      (group) =>
          group.id ==
          _currentGroup!.id,
    );

    if (currentIndex == -1 ||
        currentIndex >=
            _groups.length - 1) {
      return;
    }

    setState(() {
      _currentGroup =
          _groups[currentIndex + 1];

      _orders = [];

      _ordersError = null;
    });

    await _loadOrders();
  }

  // --------------------------------------------------
  // Message
  // --------------------------------------------------

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // --------------------------------------------------
  // Build
  // --------------------------------------------------

  @override
  Widget build(
    BuildContext context,
  ) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'بگیر',
          ),
        ),
        drawer: const MyDrawer(),
        floatingActionButton:
            FloatingActionButton(
          onPressed:
              _showAddOrderDialog,
          child: const Icon(
            Icons.add,
          ),
        ),
        body: _buildBody(),
        bottomNavigationBar:
            const MyBottomNavigationBar(),
      ),
    );
  }

  // --------------------------------------------------
  // Body
  // --------------------------------------------------

  Widget _buildBody() {
    if (_isLoadingGroups) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    if (_groupsError != null) {
      return Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Text(
              _groupsError!,
            ),
            const SizedBox(
              height: 12,
            ),
            FilledButton(
              onPressed:
                  _loadGroups,
              child: const Text(
                'تلاش مجدد',
              ),
            ),
          ],
        ),
      );
    }

    if (_groups.isEmpty ||
        _currentGroup == null) {
      return const Center(
        child: Text(
          'هنوز گروهی ایجاد نشده است',
        ),
      );
    }

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(8),
        child: SizedBox(
          width: 500,
          child: Column(
            children: [
              GroupsBar(
                group:
                    _currentGroup!,
                onPrevious:
                    _previousGroup,
                onNext:
                    _nextGroup,
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child:
                    _buildOrders(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Orders
  // --------------------------------------------------

  Widget _buildOrders() {
    if (_isLoadingOrders) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    if (_ordersError != null) {
      return Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Text(
              _ordersError!,
            ),
            const SizedBox(
              height: 12,
            ),
            FilledButton(
              onPressed:
                  _loadOrders,
              child: const Text(
                'تلاش مجدد',
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh:
          _loadOrders,
      child: OrdersList(
        orders: _orders,
        currentUserId:
            _currentUserId,
        onReserve:
            _reserveOrder,
        onComplete:
            _completeOrder,
        onDelete:
            _deleteOrder,
      ),
    );
  }
}