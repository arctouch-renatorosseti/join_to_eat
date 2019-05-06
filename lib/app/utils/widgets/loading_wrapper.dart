import 'package:flutter/material.dart';

class LoadingWrapper extends StatelessWidget {
  LoadingWrapper({@required this.isLoading, @required this.child});

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          child,
          _showCircularProgress(),
        ],
      );

  Widget _showCircularProgress() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}
