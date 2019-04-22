import 'package:flutter/material.dart';
import 'package:join_to_eat/app/presentation/form_profile.dart';
import 'package:join_to_eat/app/presentation/list_schedules.dart';
import 'package:join_to_eat/app/presentation/map_view.dart';

class MainView extends StatefulWidget {

  MainView({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  final _widgetOptions = [
    MapView(),
    FormProfile(),
    ListSchedules()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.language), title: Text('Network')),
          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('Add event')),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), title: Text('events')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
//  _widgetOptions.elementAt(_selectedIndex)