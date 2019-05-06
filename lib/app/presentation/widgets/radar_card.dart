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

  const RadarCard({Key key, this.meeting}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RadarCardState(this.meeting);
}

class _RadarCardState extends State<RadarCard> {
  final RadarCardBloc _bloc;

  final titleStyle = TextStyle(fontFamily: "Roboto-Regular", fontSize: ScalerHelper.getScaledFontSize(16.0));
  final infoStyle = TextStyle(fontFamily: "Roboto-Light", fontSize: ScalerHelper.getScaledFontSize(12.0));
  final dateStyle = TextStyle(fontFamily: "Roboto-Light", fontSize: ScalerHelper.getScaledFontSize(14.0));
  final distanceStyle = TextStyle(fontFamily: "Roboto-Regular", fontSize: ScalerHelper.getScaledFontSize(24.0));

  final outCardMargin = EdgeInsets.fromLTRB(
      ScalerHelper.getScaledValue(12.0), ScalerHelper.getScaledValue(4.0), ScalerHelper.getScaledValue(12.0), 0.0);
  final inCardMargin = EdgeInsets.fromLTRB(ScalerHelper.getScaledValue(11.0), ScalerHelper.getScaledValue(10.0),
      ScalerHelper.getScaledValue(15.0), ScalerHelper.getScaledValue(8.0));

  _RadarCardState(Meeting meeting) : _bloc = RadarCardBloc(meeting: meeting);

  @override
  void initState() {
    super.initState();

    _bloc.dispatch(RadarCardEvent.load);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();

    return BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, RadarCardState state) {
          if (state.date == null) {
            return Card(margin: outCardMargin, child: Text(Strings.radarLoadingCard, style: titleStyle));
          }

          return Card(
              margin: outCardMargin,
              child: Padding(
                  padding: inCardMargin,
                  child: Row(
                    children: <Widget>[
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                        Text(
                          state.title,
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
                              state.creator,
                              style: infoStyle,
                            )
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: ScalerHelper.getScaledValue(7.0)),
                            child: Text(
                              sprintf(Strings.radarPartySize, [state.partySize]),
                              style: infoStyle,
                            )),
                      ]),
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(bottom: ScalerHelper.getScaledValue(11.0)),
                            child: Text(
                              DateFormat.yMd(locale).format(state.date),
                              style: dateStyle,
                            )),
                        Text(
                          sprintf(Strings.radarDistance, [state.distance]),
                          style: distanceStyle,
                        ),
                      ])),
                    ],
                  )));
        });
  }
}
