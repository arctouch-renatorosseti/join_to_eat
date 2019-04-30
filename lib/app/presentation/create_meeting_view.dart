import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:join_to_eat/app/bloc/meeting/meeting_bloc.dart';
import 'package:join_to_eat/app/model/meeting.dart';
import 'package:join_to_eat/app/resources/strings.dart';

class CreateMeetingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateMeetingViewState();
}

class _CreateMeetingViewState extends State<CreateMeetingView> {
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

    _meeting.idMapPlace = place.id;
    _meeting.startTime = Timestamp.now();

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: this._formKey,
          child: ListView(
            children: <Widget>[
              ListTile(leading: const Icon(Icons.location_on), title: new Text(place.name)),
              ListTile(
                leading: const Icon(Icons.description),
                title: TextFormField(
                  onSaved: (value) {
                    _meeting.description = value;
                  },
                  decoration: InputDecoration(
                    hintText: Strings.hintMeetingDescription,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.timer),
                title: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return Strings.meetingDurationEmpty;
                    }
                    var duration = int.parse(value);
                    if (duration < 1 || duration > 24) {
                      return Strings.meetingDurationInvalid;
                    }
                  },
                  onSaved: (value) {
                    _meeting.endTime = Timestamp.fromMillisecondsSinceEpoch(
                        (Timestamp.now().millisecondsSinceEpoch + int.parse(value) * 3600 * 1000));
                    _bloc.onSave(_meeting);
                  },
                  decoration: InputDecoration(
                    hintText: Strings.hintMeetingDuration,
                  ),
                ),
              ),
              RaisedButton(
                child: Text(Strings.buttonCreateMeeting),
                onPressed: _onCreateMeetingButtonPressed,
              ),
            ],
          ),
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
