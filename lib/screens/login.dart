import 'package:begir/style/color.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ثبت نام و ورود'),
          centerTitle: true,
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(8),
            width: 300,
            decoration: BoxDecoration(
              
              color: AppColors.white1,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 0.5, color: AppColors.gray4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "نام کاربری",
                    suffixIcon: Icon(Icons.supervised_user_circle_rounded),
                  ),
                ),
                TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "کلمه عبور",
                    suffixIcon: Icon(Icons.key),
                  ),
                ),
                SizedBox(height: 40,),
                FilledButton(onPressed: (){}, child: Text('ثبت نام - ورود'),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
