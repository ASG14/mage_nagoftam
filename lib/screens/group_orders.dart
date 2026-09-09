import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/group.dart';
import 'package:mage_nagoftam/models/order.dart';

import 'package:mage_nagoftam/services/auth_service.dart';
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

  bool _isLoading = true;

  String? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _currentUserId =
        await AuthService.getUserId();

    if (!mounted) return;

    await _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

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
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = 'دریافت سفارش‌ها انجام نشد';
      });
    }
  }

  Future<void> _reserveOrder(Order order) async {
    try {
      await OrderService.assignOrder(
        orderId: order.id,
      );

      if (!mounted) return;

      await _loadOrders();
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'سپردن سفارش انجام نشد',
      );
    }
  }

  Future<void> _completeOrder(Order order) async {
    if (order.assignedUserId != _currentUserId) {
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

      await _loadOrders();
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'تکمیل سفارش انجام نشد',
      );
    }
  }

  Future<void> _deleteOrder(Order order) async {
    if (order.createdBy != _currentUserId) {
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
          (item) => item.id == order.id,
        );
      });
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'حذف سفارش انجام نشد',
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: GroupOrdersAppBar(
          group: widget.group,
        ),

        body: _buildBody(),

        floatingActionButton:
            const AddOrderButton(),

        bottomNavigationBar:
            const MyBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loadOrders,
              child: const Text('تلاش مجدد'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: OrdersList(
        orders: _orders,
        currentUserId: _currentUserId,
        onReserve: _reserveOrder,
        onComplete: _completeOrder,
        onDelete: _deleteOrder,
      ),
    );
  }
}