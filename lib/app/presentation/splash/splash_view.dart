import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_to_eat/app/bloc/splash/splash_bloc.dart';
import 'package:join_to_eat/app/utils/ScalerHelper.dart';
import 'package:join_to_eat/app/utils/widgets/routing_wrapper.dart';

class SplashView extends StatefulWidget {
  @override
  createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final SplashBloc _splashBloc = SplashBloc();

  @override
  void initState() {
    super.initState();
    _splashBloc.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    ScalerHelper.setCurrentScreenSize(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return BlocBuilder(
        bloc: _splashBloc,
        builder: (context, state) => RoutingWrapper(
            route: state.route?.value,
            child: Container(alignment: Alignment.bottomCenter, child: CircularProgressIndicator())));
  }

  @override
  void dispose() {
    _splashBloc?.dispose();
    super.dispose();
  }
}
