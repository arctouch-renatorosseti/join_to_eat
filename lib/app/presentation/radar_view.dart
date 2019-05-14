import 'package:flutter/material.dart';
import 'package:join_to_eat/app/bloc/meeting/meeting_bloc.dart';
import 'package:join_to_eat/app/model/meeting.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:join_to_eat/app/utils/ScalerHelper.dart';

import 'widgets/radar_card.dart';

class RadarView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RadarViewState();
}

class _RadarViewState extends State<RadarView> with SingleTickerProviderStateMixin {
  final _bloc = MeetingBloc();
  final _appForegroundColor = Colors.white;
  final _circleColor = Color.fromARGB(255, 91, 36, 240);

  Animation circleAnimation;
  AnimationController circleController;

  @override
  void initState() {
    super.initState();

    circleController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    circleAnimation =
        Matrix4Tween(begin: Matrix4.translationValues(0, -950, 0), end: Matrix4.translationValues(0, -350, 0))
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
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: _appForegroundColor),
          title: Text(Strings.radarTitle, style: TextStyle(color: _appForegroundColor)),
          toolbarOpacity: 0.0,
          backgroundColor: _circleColor,
        ),
        body: _buildMeetingsList());
  }

  Widget _buildMeetingsList() {
    return Stack(
      children: <Widget>[
        Positioned.fill(
            child: UnconstrainedBox(
          alignment: Alignment.center,
          child: Container(
            width: ScalerHelper.getScaleWidth(720.0),
            height: ScalerHelper.getScaleHeight(720.0),
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
            child: StreamBuilder(
                stream: _bloc.getCurrentMeetings(),
                builder: (BuildContext context, AsyncSnapshot<Iterable<Meeting>> snap) {
                  if (snap.hasError) {
                    return Text("Error: ${snap.error}");
                  }

                  switch (snap.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                          alignment: Alignment.bottomCenter,
                          child: new CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(this._circleColor)));

                    default:
                      if (snap.data == null) {
                        return Card(child: Text(Strings.radarEmpty));
                      }

                      List<Meeting> meetings = snap.data.toList();

                      return ListView.builder(
                          itemCount: meetings.length,
                          itemBuilder: (BuildContext context, int index) => RadarCard(
                                meeting: meetings[index],
                                cardIndex: index,
                                totalCards: meetings.length,
                              ));
                  }
                }))
      ],
    );
  }
}
