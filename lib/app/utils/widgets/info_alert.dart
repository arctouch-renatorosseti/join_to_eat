import 'package:flutter/material.dart';
import 'package:join_to_eat/app/resources/strings.dart';

class InfoAlert extends StatelessWidget {
  final Widget child;
  final String title;
  final String content;
  final bool shouldShow;

  const InfoAlert({this.title, this.content, this.shouldShow, this.child});

  @override
  Widget build(BuildContext context) {
    if (shouldShow == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showDialog<void>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text(title),
                  content: Text(content),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(Strings.ok),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
          ));
    }
    return child;
  }
}
