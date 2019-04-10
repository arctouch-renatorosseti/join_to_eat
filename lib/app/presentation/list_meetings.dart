import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_to_eat/app/meeting/meeting_bloc.dart';
import 'package:join_to_eat/app/meeting/meeting_event.dart';

class ListMeetings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MeetingBloc _counterBloc = BlocProvider.of<MeetingBloc>(context);
    List<String> items = ["100","200","800","1.2"];

    return Scaffold(
      appBar: AppBar(title: Text('Join To Eat'), backgroundColor: Colors.orange),
      backgroundColor: Colors.white70,
      body: BlocBuilder<MeetingEvent, int>(
        bloc: _counterBloc,
        builder: (BuildContext context, int count) {
          items.add("$count");

          return ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext _context, int i) {


                return _buildRow(items[i]);
              }
          );
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _counterBloc.dispatch(MeetingEvent.increment);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.remove),
              onPressed: () {
                _counterBloc.dispatch(MeetingEvent.decrement);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String text) {
    return Card(
      semanticContainer: true,
      color: Colors.white,
      clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/meal_01.jpg'),
                radius: 70,

              ),
            ),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text("Renato Aquiles Rosseti", style: TextStyle(color: Colors.grey, fontSize: 20)),
                      Text("$text m", style: TextStyle(color: Colors.grey, fontSize: 20))
                    ]

                )
            )
          ],
        ),
        
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
    );
  }
}