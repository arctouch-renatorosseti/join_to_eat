import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_to_eat/app/bloc/user_bloc.dart';
import 'package:join_to_eat/app/bloc/user_event.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:join_to_eat/app/utils/widgets/info_alert.dart';
import 'package:join_to_eat/app/utils/widgets/loading_wrapper.dart';
import 'package:join_to_eat/app/utils/widgets/routing_wrapper.dart';

class SignInWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInForm();
}

class _SignInForm extends State<SignInWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _bloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.0),
          child: BlocBuilder<UserEvent, int>(
              bloc: _bloc,
              builder: (context, state) => RoutingWrapper(
//                  route: state.route?.value,
                  child: InfoAlert(
                      title: Strings.email,
                      content: Strings.email,
                      child: Scaffold(
                          body: LoadingWrapper(
                            isLoading: false,
                            child: Container(
                                padding: EdgeInsets.all(16.0),
                                child: Form(
                                  key: _formKey,
                                  child: ListView(
                                    children: <Widget>[
                                      ListTile(
                                        leading: const Icon(Icons.email),
                                        title: TextFormField (
                                          decoration: InputDecoration(
                                            hintText: "Email",
                                          ),
                                          validator: _bloc.validateEmail,
                                        ),
                                      ),
                                      _getButton(),
                                    ],
                                  ),
                                )),
                          )))

          ),
        ),
    );
  }

  _getFormSignIn() {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.access_time),
          title: TextField(
            decoration: InputDecoration(
              hintText: "Time",
            ),
          ),
        ),
        _getButton(),
      ],
    );
  }



  _getButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
//      onPressed: () => _bloc.su,
    );
  }

}