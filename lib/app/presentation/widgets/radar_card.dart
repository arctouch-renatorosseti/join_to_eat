import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:join_to_eat/app/bloc/meeting/radar_card_bloc.dart';
import 'package:join_to_eat/app/model/meeting.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:join_to_eat/app/utils/ScalerHelper.dart';
import 'package:sprintf/sprintf.dart';

class RadarCard extends StatefulWidget {
  final Meeting meeting;
  final int cardIndex;
  final int totalCards;

  const RadarCard({Key key, this.meeting, this.cardIndex, this.totalCards}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RadarCardState(this.meeting, this.cardIndex, this.totalCards);
}

class _RadarCardState extends State<RadarCard> with SingleTickerProviderStateMixin {
  final RadarCardBloc _bloc;
  final int animationDuration;

  final titleStyle = TextStyle(fontFamily: "Roboto-Regular", fontSize: ScalerHelper.getScaledFontSize(16.0));
  final infoStyle = TextStyle(fontFamily: "Roboto-Light", fontSize: ScalerHelper.getScaledFontSize(12.0));
  final dateStyle = TextStyle(fontFamily: "Roboto-Light", fontSize: ScalerHelper.getScaledFontSize(14.0));
  final distanceStyle =
      TextStyle(fontFamily: "Roboto-Regular", fontSize: ScalerHelper.getScaledFontSize(20.0)); // Used to be 24.0

  final outCardMargin = EdgeInsets.fromLTRB(
      ScalerHelper.getScaledValue(12.0), ScalerHelper.getScaledValue(4.0), ScalerHelper.getScaledValue(12.0), 0.0);
  final inCardMargin = EdgeInsets.fromLTRB(ScalerHelper.getScaledValue(11.0), ScalerHelper.getScaledValue(10.0),
      ScalerHelper.getScaledValue(15.0), ScalerHelper.getScaledValue(8.0));

  AnimationController _controller;
  Animation _animation;

  _RadarCardState(Meeting meeting, int cardIndex, int totalCards)
      : _bloc = RadarCardBloc(meeting: meeting),
        animationDuration = (totalCards - cardIndex) * 200 + 1800;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: Duration(milliseconds: this.animationDuration), vsync: this);

    _animation = Matrix4Tween(begin: Matrix4.translationValues(0, -330, 0), end: Matrix4.translationValues(0, 0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0.3, 1.0, curve: Curves.elasticOut)))
          ..addListener(() {
            setState(() {});
          });

    _controller.forward();

    _bloc.dispatch(RadarCardEvent.load);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();

    return BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, RadarCardState state) {
          String whenText = "";
          String happeningNow = "";

          if (state.date != null) {
            if (state.date.isBefore(DateTime.now())) {
              happeningNow = Strings.radarHappeningNow;
            }

            whenText = DateFormat.yMd(locale).format(state.date);
          }

          return Container(
              transform: _animation.value,
              child: Card(
                  margin: outCardMargin,
                  child: Padding(
                      padding: inCardMargin,
                      child: Row(
                        children: <Widget>[
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                            Text(
                              state?.title ?? Strings.radarLoadingCard,
                              style: titleStyle,
                            ),
                            Row(
                              children: <Widget>[
                                Opacity(
                                    opacity: 0.5,
                                    child: Text(
                                      Strings.radarCreator,
                                      style: infoStyle,
                                    )),
                                Text(
                                  state?.creator ?? Strings.radarLoadingCard,
                                  style: infoStyle,
                                )
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: ScalerHelper.getScaledValue(7.0)),
                                child: Text(
                                  sprintf(Strings.radarPartySize, [state?.partySize]),
                                  style: infoStyle,
                                )),
                          ]),
                          Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(bottom: ScalerHelper.getScaledValue(11.0)),
                                child: Text(
                                  whenText,
                                  style: dateStyle,
                                )),
                            Text(
                              //TODO: Calculate distance and then use this: state.distance == 0 ? "" : sprintf(Strings.radarDistance, [state.distance]),
                              happeningNow,
                              style: distanceStyle,
                            ),
                          ])),
                        ],
                      ))));
        });
  }
}
