import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:join_to_eat/app/presentation/main_view.dart';
import 'package:join_to_eat/app/presentation/map_view.dart';
import 'package:join_to_eat/app/presentation/sign_in/auth_widget.dart';
import 'package:join_to_eat/app/utils/routes.dart';

class MainApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routes: {
        Routes.root: (c) => MyHomePage(title: 'Flutter Demo Home Page'),
        Routes.main: (c) => MapView(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Container(

      child: SignInWidget(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}