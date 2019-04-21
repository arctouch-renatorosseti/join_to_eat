import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:join_to_eat/app/bloc/user_bloc.dart';

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
        child: Form(
          key: this._formKey,
          child: StreamBuilder (
            stream: _bloc.email,
            builder: (context, snapshot) {
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
          )
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
//      onPressed: () => _bloc.counter_event_sink.add(IncrementEvent()),
    );
  }

}