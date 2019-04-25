import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:join_to_eat/app/resources/strings.dart';

class CreateMeetingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateMeetingViewState();
}

class _CreateMeetingViewState extends State<CreateMeetingView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final PlacesSearchResult place = ModalRoute.of(context).settings.arguments;

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
                  decoration: InputDecoration(
                    hintText: Strings.hintMeetingDuration,
                  ),
                ),
              ),
              new RaisedButton(
                child: Text(Strings.buttonCreateMeeting),
                onPressed: _onCreateMeetingButtonPressed,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onCreateMeetingButtonPressed() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }
}