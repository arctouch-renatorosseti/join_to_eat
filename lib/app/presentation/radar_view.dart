import 'package:flutter/material.dart';
import 'package:join_to_eat/app/bloc/meeting/meeting_bloc.dart';
import 'package:join_to_eat/app/model/meeting.dart';
import 'package:join_to_eat/app/resources/strings.dart';

import 'widgets/radar_card.dart';

class RadarView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RadarViewState();
}

class _RadarViewState extends State<RadarView> {
  final _bloc = MeetingBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(Strings.radarTitle)), body: _buildMeetingsList());
  }

  Widget _buildMeetingsList() {
    return new StreamBuilder(
        stream: _bloc.getCurrentMeetings(),
        builder: (BuildContext context, AsyncSnapshot<Iterable<Meeting>> snap) {
          if (snap.hasError) {
            return Text("Error: ${snap.error}");
          }

          switch (snap.connectionState) {
            case ConnectionState.waiting:
              return const Text("Loading...");
            default:
              if (snap.data == null) {
                return const Text("NO DATA");
              }

              List<Meeting> meetings = snap.data.toList();

              return ListView.builder(
                  itemCount: meetings.length,
                  itemBuilder: (BuildContext context, int index) => RadarCard(meeting: meetings[index]));
          }
        });
  }
}
