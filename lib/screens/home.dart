import 'package:begir/widgets/bottom_navigation_bar.dart';
import 'package:begir/widgets/drawer.dart';
import 'package:begir/widgets/group_items.dart';
import 'package:begir/widgets/groups_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),

        appBar: AppBar(
          title: const Text('عنوان اپ بار'),
        ),

        drawer: const MyDrawer(),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              GroupsBar(),
              GroupItems(),
            ],
          ),
        ),

        bottomNavigationBar: const MyBottomNavigationBar(),
      ),
    );
  }
}