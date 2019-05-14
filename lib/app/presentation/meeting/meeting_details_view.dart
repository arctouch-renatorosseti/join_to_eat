import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:join_to_eat/app/bloc/meeting/meeting_bloc.dart';
import 'package:join_to_eat/app/model/meeting.dart';
import 'package:join_to_eat/app/resources/strings.dart';

class MeetingDetailsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MeetingDetailsViewState();
}

class _MeetingDetailsViewState extends State<MeetingDetailsView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _bloc = MeetingBloc();
  final Meeting _meeting = Meeting();

  @override
  void initState() {
    super.initState();

    setupData();
  }

  @override
  Widget build(BuildContext context) {
    final PlacesSearchResult place = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(90.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ListTile(
              title: Text('Lunch at Madero'),
            ),
            ListTile(
              title: Text('Create by'),
              subtitle: Text('Joao da Silva'),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('12 already joined'),
                Icon(Icons.list),
              ],
            ),
            Divider(
              color: Colors.grey,
              height: 1,
            ),
            ListTile(
              title: Text('Madero Container'),
              subtitle: Text('Rod SC 401 km 4 - Saco Grande,\nFlorianópolis-SC'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {},
                  child: Text('JOIN THIS EVENT'),
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }

  void setupData() async {
    _meeting.users.add(await _bloc.getSignedUser());
  }

  Future<void> _onCreateMeetingButtonPressed() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _bloc.dispatch(MeetingEvent.createMeeting);

      Navigator.pop(context);
    }
  }
}
