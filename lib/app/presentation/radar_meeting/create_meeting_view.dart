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

class _CreateMeetingViewState extends State<CreateMeetingView> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _bloc = MeetingBloc();
  final Meeting _meeting = Meeting();

  final _appForegroundColor = Colors.black;
  final _appBackgroundColor = Colors.white;

  final TextStyle styleTitle = TextStyle(
      color: const Color(0xff000000),
      fontWeight: FontWeight.w300,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 14.0);
  final TextStyle styleSmallData = TextStyle(
      color: const Color(0xff303030),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 18.0);
  final TextStyle styleLargeData = TextStyle(
      color: const Color(0xff000000),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 26.0);
  final TextStyle styleTinyData = TextStyle(
      color: const Color(0xff000000),
      fontWeight: FontWeight.w300,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 12.0);

  Animation _animationWhat;
  Animation _animationWhere;
  Animation _animationWhen;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    setupData();

    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _animationWhat = _getAnimation(0.0);
    _animationWhere = _getAnimation(0.33);
    _animationWhen = _getAnimation(0.66);

    _controller.forward();
  }

  Animation _getAnimation(double start) {
    return Matrix4Tween(begin: Matrix4.translationValues(400, 0, 0), end: Matrix4.translationValues(0, 0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Interval(start, start + 0.33, curve: Curves.elasticOut)))
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    final PlacesSearchResult place = ModalRoute.of(context).settings.arguments;

    _meeting.idMapPlace = place.placeId;
    _meeting.startTime = Timestamp.now();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: _appForegroundColor),
        title: Text(Strings.createMeetingPageTitle, style: TextStyle(color: _appForegroundColor)),
        backgroundColor: _appBackgroundColor,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
            key: this._formKey,
            child: Stack(children: <Widget>[
              ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 26.0),
                  ),
                  Container(
                    transform: _animationWhat.value,
                    child: Text(Strings.createMeetingDescriptionTitle, style: styleTitle),
                  ),
                  Container(
                      transform: _animationWhat.value,
                      child: ListTile(
                        trailing: const Icon(Icons.description),
                        title: TextFormField(
                          onSaved: (value) {
                            _meeting.description = value;
                          },
                          decoration: InputDecoration(
                            hintText: Strings.createMeetingDescriptionHint,
                            labelStyle: styleSmallData,
                            hintStyle: styleSmallData,
                          ),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 26.0),
                  ),
                  Container(
                      transform: _animationWhere.value,
                      child: Text(Strings.createMeetingWhereTitle, style: styleTitle)),
                  Container(
                      transform: _animationWhere.value,
                      child: ListTile(
                          trailing: const Icon(Icons.location_on),
                          title: Text(place.name, style: styleLargeData),
                          subtitle: Text(place.vicinity == null ? "" : place.vicinity, style: styleTinyData))),
                  Padding(
                    padding: EdgeInsets.only(top: 26.0),
                  ),
                  Container(
                      transform: _animationWhen.value,
                      child: Text(Strings.createMeetingDurationTitle, style: styleTitle)),
                  Container(
                      transform: _animationWhen.value,
                      child: ListTile(
                        trailing: const Icon(Icons.timer),
                        title: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return Strings.createMeetingDurationEmpty;
                            }
                            var duration = int.parse(value);
                            if (duration < 1 || duration > 24) {
                              return Strings.createMeetingDurationInvalid;
                            }
                          },
                          onSaved: (value) {
                            _meeting.endTime = Timestamp.fromMillisecondsSinceEpoch(
                                (Timestamp.now().millisecondsSinceEpoch + int.parse(value) * 3600 * 1000));
                            _bloc.onSave(_meeting);
                          },
                          decoration: InputDecoration(
                            hintText: Strings.createMeetingDurationHint,
                            labelStyle: styleLargeData,
                            hintStyle: styleSmallData,
                          ),
                        ),
                      )),
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Color.fromARGB(255, 240, 173, 36),
                        child: Text(Strings.createMeetingButton),
                        onPressed: _onCreateMeetingButtonPressed,
                      ))),
            ])),
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
