import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreateEventView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: this._formKey,
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.access_time),
                title: new TextField(
                  decoration: InputDecoration(
                    hintText: "Time",
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: TextField(
                  decoration: InputDecoration(
                    hintText: "Restaurant name",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
