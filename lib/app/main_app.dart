import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:join_to_eat/app/presentation/map_view.dart';
import 'package:join_to_eat/app/presentation/auth/auth_view.dart';
import 'package:join_to_eat/app/presentation/splash/splash_view.dart';
import 'package:join_to_eat/app/utils/routes.dart';

import 'presentation/create_event_view.dart';
import 'presentation/list_events_view.dart';
import 'resources/strings.dart';

class MainApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routes: {
        Routes.root: (c) => SplashView(),
        Routes.login: (c) => AuthView(),
        Routes.main: (c) => MapView(),
        Routes.createEvent: (c) => CreateEventView(),
        Routes.listEvents: (c) => ListEventsView(),
      },
    );
  }
}
