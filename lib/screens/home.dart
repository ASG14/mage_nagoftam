import 'package:flutter/material.dart';
import 'package:begir/widgets/order_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                Container(
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8) ,
                  ),

                  child: Row(
                    
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 1, child: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_left),),),
                      Expanded(flex: 8, child: Text('عنوان گروه فعلی', textAlign: TextAlign.center,)),
                      Expanded(flex: 1, child: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_right),),),
                    ],
                  ),

                ),
                Column(
                  children: [
                    OrderCard(),
                    OrderCard(),
                    OrderCard(),

                  ],
                ),
              ],
            
              
            ),
          ),
        ),
    );
  }
}
