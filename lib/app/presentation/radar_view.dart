import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:join_to_eat/app/bloc/meeting/meeting_bloc.dart';
import 'package:join_to_eat/app/resources/strings.dart';

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
        //TODO: stream: _bloc.getCurrentMeetings(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
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

          print("******* Data: $snap");

          return ListView.builder(
            itemCount: snap.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return new Text("Item $index");
            },
          );
      }
    });
  }
}
