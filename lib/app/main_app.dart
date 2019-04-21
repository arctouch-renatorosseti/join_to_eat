import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:join_to_eat/app/bloc/user_bloc.dart';
import 'package:join_to_eat/app/bloc/user_bloc_provider.dart';
import 'package:join_to_eat/app/meeting/meeting_bloc.dart';
import 'package:join_to_eat/app/model/user.dart';
import 'package:join_to_eat/app/model/users_list.dart';
import 'package:join_to_eat/app/presentation/map_view.dart';
import 'package:join_to_eat/app/presentation/list_schedules.dart';
import 'package:join_to_eat/app/presentation/form_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_to_eat/app/presentation/sign_in/signin_widget.dart';
import 'package:join_to_eat/app/repository/repository.dart';

class MainApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MeetingBloc _meetingBloc = MeetingBloc();
  final UserBloc _usersBloc = UserBloc();

  int _selectedIndex = 0;
  final _widgetOptions = [
    MapView(),
    FormProfile(),
    ListSchedules()
  ];

//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    _usersBloc = UsersBlocProvider.of(context);
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join To Eat.'),
      ),
      body: SignInWidget(),
//        body: Container(
//          child: Center(
//            // Use future builder and DefaultAssetBundle to load the local JSON file
//            child: FutureBuilder(
//                future: DefaultAssetBundle.of(context)
//                    .loadString('assets/users.json'),
//                builder: (context, snapshot) {
//                  UsersList usersList = parseJson(snapshot.data.toString());
//                  return (usersList != null) ? Text("Length existed")
//                      : Center(child: CircularProgressIndicator());
//                }),
//          ),
//        ));
//      body: FutureBuilder (
//          future: DefaultAssetBundle.of(context).loadString('assets/users.json'),
//          builder: (context, snapshot) {
//            Container(
//              child: Center(
//                child: Text('Text'),
//              ),
//            );
//          }
//       ),
//      ),
//      bottomNavigationBar: BottomNavigationBar(
//        backgroundColor: Colors.orange,
//        items: <BottomNavigationBarItem>[
//          BottomNavigationBarItem(icon: Icon(Icons.language), title: Text('Network')),
//          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('Add event')),
//          BottomNavigationBarItem(icon: Icon(Icons.notifications), title: Text('events')),
//        ],
//        currentIndex: _selectedIndex,
//        fixedColor: Colors.white,
//        onTap: _onItemTapped,
//      ),
    );
  }

  @override
  void dispose() {
    _meetingBloc.dispose();

    super.dispose();
  }
}