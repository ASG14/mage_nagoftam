import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/group.dart';
import 'package:mage_nagoftam/models/order.dart';

import 'package:mage_nagoftam/services/auth_service.dart';
import 'package:mage_nagoftam/services/group_service.dart';
import 'package:mage_nagoftam/services/order_service.dart';

import 'package:mage_nagoftam/widgets/bottom_navigation_bar.dart';
import 'package:mage_nagoftam/widgets/orders/group_orders_app_bar.dart';
import 'package:mage_nagoftam/widgets/orders/orders_list.dart';
import 'package:mage_nagoftam/widgets/orders/add_order_button.dart';

class GroupOrdersScreen extends StatefulWidget {
  final Group group;

  const GroupOrdersScreen({
    super.key,
    required this.group,
  });

  @override
  State<GroupOrdersScreen> createState() =>
      _GroupOrdersScreenState();
}

class _GroupOrdersScreenState
    extends State<GroupOrdersScreen> {
  List<Order> _orders = [];

  int? _currentUserId;

  int _memberCount = 0;

  bool _isLoading = true;

  String? _error;

  // سفارش‌هایی که در حال پردازش هستند
  final Set<int> _processingOrderIds = {};

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  // ==================================================
  // Initialize
  // ==================================================

  Future<void> _initialize() async {
    _currentUserId =
        await AuthService.getUserId();

    await _loadMemberCount();

    if (!mounted) return;

    await _loadOrders();
  }

  // ==================================================
  // Load Member Count
  // ==================================================

  Future<void> _loadMemberCount() async {
    try {
      final members =
          await GroupService.getMembers(
        groupId: widget.group.id,
      );

      if (!mounted) return;

      setState(() {
        _memberCount = members.length;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _memberCount = 0;
      });
    }
  }

  // ==================================================
  // Load Orders
  // ==================================================

  Future<void> _loadOrders() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final orders =
          await OrderService.getOrders(
        groupId: widget.group.id,
      );

      if (!mounted) return;

      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error =
            'دریافت سفارش‌ها انجام نشد.';
      });
    }
  }

  // ==================================================
  // Reserve Order
  // ==================================================

  Future<void> _reserveOrder(
    Order order,
  ) async {
    if (_processingOrderIds.contains(order.id)) {
      return;
    }

    setState(() {
      _processingOrderIds.add(order.id);
    });

    try {
      await OrderService.assignOrder(
        orderId: order.id,
      );

      if (!mounted) return;

      setState(() {
        order.status = Status.reserved;
        order.assignedUserId =
            _currentUserId;
        order.assignedUserName = 'شما';

        _processingOrderIds.remove(order.id);
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _processingOrderIds.remove(order.id);
      });

      _showMessage(
        'قبول مسئولیت سفارش انجام نشد.',
      );
    }
  }

  // ==================================================
  // Complete Order
  // ==================================================

  Future<void> _completeOrder(
    Order order,
  ) async {
    if (order.assignedUserId !=
        _currentUserId) {
      _showMessage(
        'شما مسئول این سفارش نیستید.',
      );

      return;
    }

    if (_processingOrderIds.contains(order.id)) {
      return;
    }

    setState(() {
      _processingOrderIds.add(order.id);
    });

    try {
      await OrderService.completeOrder(
        orderId: order.id,
      );

      if (!mounted) return;

      setState(() {
        order.status = Status.completed;

        _processingOrderIds.remove(order.id);
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _processingOrderIds.remove(order.id);
      });

      _showMessage(
        'تکمیل سفارش انجام نشد.',
      );
    }
  }

  // ==================================================
  // Delete Order
  // ==================================================

  Future<void> _deleteOrder(
    Order order,
  ) async {
    if (order.createdBy !=
        _currentUserId) {
      _showMessage(
        'شما اجازه حذف این سفارش را ندارید.',
      );

      return;
    }

    if (_processingOrderIds.contains(order.id)) {
      return;
    }

    setState(() {
      _processingOrderIds.add(order.id);
    });

    try {
      await OrderService.deleteOrder(
        orderId: order.id,
      );

      if (!mounted) return;

      setState(() {
        _orders.removeWhere(
          (item) => item.id == order.id,
        );

        _processingOrderIds.remove(order.id);
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _processingOrderIds.remove(order.id);
      });

      _showMessage(
        'حذف سفارش انجام نشد.',
      );
    }
  }

  // ==================================================
  // Add Order
  // ==================================================

  void _onOrderCreated(
    Order order,
  ) {
    if (!mounted) return;

    setState(() {
      _orders.insert(
        0,
        order,
      );
    });
  }

  // ==================================================
  // Message
  // ==================================================

  void _showMessage(
    String message,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  // ==================================================
  // Build
  // ==================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            const Color(0xFFF8FAF9),

        appBar: GroupOrdersAppBar(
          group: widget.group,
          memberCount: _memberCount,
        ),

        body: _buildBody(),

        floatingActionButton:
            AddOrderButton(
          groupId: widget.group.id,
          onOrderCreated:
              _onOrderCreated,
        ),

        bottomNavigationBar:
            const MyBottomNavigationBar(),
      ),
    );
  }

  // ==================================================
  // Body
  // ==================================================

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return _buildError();
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,

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
        onCancelReserve:
            null,
      ),
    );
  }

  // ==================================================
  // Error
  // ==================================================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(24),

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            const Icon(
              Icons.error_outline,
              size: 52,
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              _error!,
              textAlign:
                  TextAlign.center,
            ),

            const SizedBox(
              height: 20,
            ),

            FilledButton.icon(
              onPressed:
                  _loadOrders,

              icon: const Icon(
                Icons.refresh,
              ),

              label: const Text(
                'تلاش مجدد',
              ),
            ),
          ],
        ),
      ),
    );
  }
}