import 'package:flutter/material.dart';
import 'package:join_to_eat/app/presentation/auth/auth_view.dart';
import 'package:join_to_eat/app/presentation/map_view.dart';
import 'package:join_to_eat/app/presentation/splash/splash_view.dart';
import 'package:join_to_eat/app/utils/routes.dart';

import 'presentation/create_meeting_view.dart';
import 'package:join_to_eat/app/presentation/quiz/create_quiz_view.dart';
import 'presentation/list_meetings_view.dart';
import 'presentation/radar_view.dart';
import 'resources/strings.dart';
import 'utils/ScalerHelper.dart';

class MainApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ScalerHelper.setDesignScreenSize(360.0, 640.0);

    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routes: {
        Routes.root: (c) => SplashView(),
        Routes.login: (c) => AuthView(),
        Routes.main: (c) => MapView(),
        Routes.createMeeting: (c) => CreateMeetingView(),
        Routes.listMeetings: (c) => ListMeetingsView(),
        Routes.createQuiz: (c) => CreateQuizView(),
        Routes.radar: (c) => RadarView(),
      },
    );
  }
}
