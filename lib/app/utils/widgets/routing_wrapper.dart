import 'package:flutter/material.dart';

class RoutingWrapper extends StatelessWidget {
  final Widget child;
  final String route;

  const RoutingWrapper({Key key, this.route, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (route != null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.pushReplacementNamed(context, route));
    }
    return child;
  }
}
