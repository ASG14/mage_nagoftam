import 'package:begir/widgets/group_items.dart';
import 'package:begir/widgets/groups_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0; 
    final List<Widget> _pages = [
    const Text('صفحه خانه'),
    const Text('صفحه گروه ها'),
    const Text('صفحه اعلان ها'),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(onPressed: ((){}), child: Icon(Icons.add),),
          appBar: AppBar(title: Text('عنوان اپ بار'),backgroundColor: Color.fromARGB(255, 255, 255, 255),),
          endDrawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 153, 79, 0),
                  ),
                  child: Text('هدر کشو'),
                ),
                ListTile(
                  title: Text('گزینه 1'),
                  onTap: () {
                    // عمل مورد نظر برای گزینه 1
                    Navigator.pop(context); // بستن کشو
                  },
                ),
                ListTile(
                  title: Text('گزینه 2'),
                  onTap: () {
                    // عمل مورد نظر برای گزینه 2
                    Navigator.pop(context); // بستن کشو
                  },
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),

            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GroupsBar(),
                GroupItems(),
                
                
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'خانه',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'گروه ها',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'اعلان ها',
          ),
          
          
        ],
      ),
        ),
    );
  }
}
