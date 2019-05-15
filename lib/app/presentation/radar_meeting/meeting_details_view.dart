import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:join_to_eat/app/bloc/meeting/meeting_bloc.dart';
import 'package:join_to_eat/app/bloc/meeting/radar_card_bloc.dart';
import 'package:join_to_eat/app/model/meeting.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:join_to_eat/app/utils/ScalerHelper.dart';

class MeetingDetailsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MeetingDetailsViewState();
}

class _MeetingDetailsViewState extends State<MeetingDetailsView> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RadarCardBloc _bloc;
  final _appForegroundColor = Colors.white;
  final _circleColor = Color.fromARGB(255, 91, 36, 240);
  Animation circleAnimation;
  AnimationController circleController;

  @override
  void initState() {
    super.initState();

    circleController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    circleAnimation =
        Matrix4Tween(begin: Matrix4.translationValues(0, -950, 0), end: Matrix4.translationValues(0, -30, 0))
            .animate(CurvedAnimation(parent: circleController, curve: Curves.elasticOut))
              ..addListener(() {
                setState(() {});
              });

    circleController.forward();
  }

  @override
  void dispose() {
    circleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bloc = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: _circleColor,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: _appForegroundColor),
        title: Text(Strings.meetingTitle, style: TextStyle(color: _appForegroundColor)),
        backgroundColor: _circleColor,
      ),
      body: _buildMeetingDetailsFrame(),
    );
  }

  Widget _buildMeetingDetailsFrame() {
    return Stack(
      children: <Widget>[
        Positioned.fill(
            child: UnconstrainedBox(
          alignment: Alignment.center,
          child: Container(
            width: 620,
            height: 620,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _circleColor,
            ),
            transform: circleAnimation.value,
          ),
        )),
        Positioned.fill(
          child: _buildDetailsMeeting(),
        )
      ],
    );
  }

  Widget _buildDetailsMeeting() {
    return
      Container(
      transform: circleAnimation.value,
      padding: EdgeInsets.all(60.0),
      child: BlocBuilder<RadarCardEvent, RadarCardState>(
        bloc: _bloc,
        builder: (context, state) => Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ListTile(
                    title: Text('${Strings.lunchAt} ${state.placeName}', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    title: Text('${Strings.createdBy}'),
                    subtitle: Text(state.creator),
                  ),
                  Padding(
                    padding: EdgeInsets.all(14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('${_bloc.meeting.users.length} ${Strings.alreadyJoined}'),
                        IconButton(
                          icon: Icon(Icons.list),
                          onPressed: () => {_bloc.dispatch(RadarCardEvent.showDetails)},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.meetingUsers.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        Text("User ${state.meetingUsers.first.firstName}");
                      },
                    ),
                  ),

                  Divider(
                    indent: 14,
                    color: Colors.grey,
                    height: 1,
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(state.placeName, style: TextStyle(fontWeight: FontWeight.bold)),
                            Icon(Icons.location_on),
                          ],
                        ),
                      ),
                      ListTile(
                        subtitle: Text('Rod SC 401 km 4 - Saco Grande,\nFlorianópolis-SC'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        padding: EdgeInsets.only(left: 60, right: 60, top: 10, bottom: 10),
                        color: _circleColor,
                        textColor: Colors.white,
                        onPressed: () {
                          _bloc.dispatch(RadarCardEvent.joinMeeting);
                        },
                        child: Text('${Strings.joinThisEvent}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
