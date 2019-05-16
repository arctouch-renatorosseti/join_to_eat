import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_to_eat/app/bloc/meeting/radar_card_bloc.dart';
import 'package:join_to_eat/app/model/user.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:join_to_eat/app/utils/ScalerHelper.dart';

class MeetingDetailsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MeetingDetailsViewState();
}

class _MeetingDetailsViewState extends State<MeetingDetailsView> with SingleTickerProviderStateMixin {
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle styleCommonTitle = TextStyle(
      color: const Color(0xff000000),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: ScalerHelper.getScaledFontSize(20.0));

  final TextStyle styleCommonSubtitle = TextStyle(
      color: const Color(0xff000000),
      fontWeight: FontWeight.w300,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: ScalerHelper.getScaledFontSize(10.0));

  RadarCardBloc _bloc;
  final _appForegroundColor = Colors.white;
  final _circleColor = Color.fromARGB(255, 91, 36, 240);

  Animation _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _animation = Matrix4Tween(
            begin: Matrix4.translationValues(0, ScalerHelper.getScaledValue(800), 0),
            end: Matrix4.translationValues(0, 0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0.3, 1.0, curve: Curves.elasticOut)))
          ..addListener(() {
            setState(() {});
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = ModalRoute.of(context).settings.arguments;
    }

    return Scaffold(
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
            width: ScalerHelper.getScaleWidth(720.0),
            height: ScalerHelper.getScaleHeight(720.0),
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _circleColor,
            ),
            transform: Matrix4.translationValues(0, -350, 0),
          ),
        )),
        Positioned.fill(
          child: _buildDetailsMeeting(),
        )
      ],
    );
  }

  Widget _buildDetailsMeeting() {
    return Container(
        transform: _animation.value,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(ScalerHelper.getScaledValue(16.0))),
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  offset: Offset(0.0, ScalerHelper.getScaledValue(10.0)),
                  blurRadius: ScalerHelper.getScaledValue(20.0))
            ]),
        margin: EdgeInsets.all(30.0),
        padding: EdgeInsets.fromLTRB(ScalerHelper.getScaledValue(15), ScalerHelper.getScaledValue(20),
            ScalerHelper.getScaledValue(15), ScalerHelper.getScaledValue(15)),
        child: Stack(children: <Widget>[
          BlocBuilder<RadarCardEvent, RadarCardState>(
            bloc: _bloc,
            builder: (context, state) => Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('${state.title}',
                            style: TextStyle(
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: ScalerHelper.getScaledFontSize(26.0))),
                      ),
                      ListTile(
                        title: Text('${Strings.createdBy}',
                            style: TextStyle(
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: ScalerHelper.getScaledFontSize(12.0))),
                        subtitle: Text(state.creator,
                            style: TextStyle(
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: ScalerHelper.getScaledFontSize(14.0))),
                      ),
                      ListTile(
                        title: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  style: const TextStyle(
                                      color: const Color(0xff303030),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Roboto",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0),
                                  text: "${_bloc.meeting.users.length} "),
                              TextSpan(
                                  style: const TextStyle(
                                      color: const Color(0xff303030),
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Roboto",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0),
                                  text: "${Strings.alreadyJoined}")
                            ])),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _getAvatarProfiles(),
                        ),
                      ),
                      ListTile(
                          title: Divider(
                        indent: ScalerHelper.getScaledValue(14.0),
                        color: Colors.grey,
                        height: 1,
                      )),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(state.placeName, style: styleCommonTitle),
                            Icon(Icons.location_on),
                          ],
                        ),
                        subtitle: Text(state.address, style: styleCommonSubtitle),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(Strings.radarHappeningNow, style: styleCommonTitle),
                            Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ), // Blockbuilder
          Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: _circleColor,
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScalerHelper.getScaledValue(6.0))),
                    textColor: Colors.white,
                    child: Text(Strings.joinThisEvent),
                    onPressed: () {
                      _bloc.dispatch(RadarCardEvent.joinMeeting);
                    },
                  ))),
        ]));
  }

  List<Widget> _getAvatarProfiles() {
    List<Widget> widgets = List<Widget>();
    for (User user in _bloc.meetingUsers) {
      if (user.photo.isNotEmpty) {
        var widget = CircleAvatar(
          backgroundImage: NetworkImage(user.photo),
        );
        widgets.add(Padding(padding: EdgeInsets.only(right: 0), child: widget));
      } else {
        var widget = CircleAvatar(
          backgroundColor: _circleColor,
          child: Text(user.firstName.substring(0, 1)),
        );
        widgets.add(Padding(padding: EdgeInsets.only(right: 0), child: widget));
      }
    }
    return widgets;
  }
}
