import 'package:flutter/material.dart';
import 'package:join_to_eat/app/main_app.dart';
import 'package:join_to_eat/app/meeting/meeting_bloc.dart';
import 'package:join_to_eat/app/meeting/meeting_event.dart';
import 'package:join_to_eat/app/presentation/map_view.dart';
import 'package:join_to_eat/app/presentation/list_schedules.dart';
import 'package:join_to_eat/app/presentation/form_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  /// Notify out MeetingBloc of events by calling dispatch like so:
  final _meetingBloc = MeetingBloc();
  _meetingBloc.dispatch(MeetingEvent.decrement);
  _meetingBloc.dispatch(MeetingEvent.decrement);
  runApp(MainApp());
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
  int _selectedIndex = 0;
  final _widgetOptions = [
    MapView(),
    FormProfile(),
    ListSchedules()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join To Eat'),
      ),
      body: BlocProvider<MeetingBloc>(
        bloc: _meetingBloc,
        child: _widgetOptions.elementAt(_selectedIndex),


      ),
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

  @override
  void dispose() {
    _meetingBloc.dispose();
    super.dispose();
  }
}