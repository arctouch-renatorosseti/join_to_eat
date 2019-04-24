import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_to_eat/app/bloc/auth_bloc.dart';
import 'package:join_to_eat/app/bloc/auth_event.dart';
import 'package:join_to_eat/app/resources/strings.dart';

import '../map_view.dart';

class SignInWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInForm();
}

class _SignInForm extends State<SignInWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _bloc = AuthBloc();

  TextEditingController _textFieldController;

  @override
  void initState() {
    _textFieldController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Strings.appName)),
        body: BlocListener(
            bloc: _bloc,
            listener: (context, state) {
              if (state.field == FormMode.mainScreen) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapView()),
                );
              }
            },
            child: BlocBuilder<UserEvent, AuthState>(
              bloc: _bloc,
              builder: (context, state) => Container(
                      child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.all(16.0),
                      shrinkWrap: true,
                      children: <Widget>[
                        CustomFieldSignIn(
                            validator: _bloc.validateField,
                            onSaved: (state.field == FormMode.email) ? _bloc.onEmailSaved : _bloc.onSecurityKeySaved,
                            state: state,
                            textFieldController: _textFieldController),
                        _getButton(state),
                      ],
                    ),
                  )),
            )));
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  _getButton(AuthState state) {
    if (state.field == FormMode.securityKey) {
      _textFieldController.clear();
    }
    return RaisedButton(
        color: Colors.orange,
        child: Text(Strings.submit),
        onPressed: () {
          final form = _formKey.currentState;
          if (form.validate()) {
            form.save();
            _bloc.dispatch(UserEvent.submit);
          }
        });
  }
}

class CustomFieldSignIn extends StatelessWidget {
  final Function(String) validator;
  final Function(String) onSaved;
  final AuthState state;
  final TextEditingController textFieldController;

  const CustomFieldSignIn(
      {Key key, @required this.validator, @required this.onSaved, @required this.state, this.textFieldController})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          controller: textFieldController,
          decoration: InputDecoration(
              hintText: (state.field == FormMode.email) ? Strings.email : Strings.securityKey,
              icon: Icon((state.field == FormMode.email) ? Icons.mail : Icons.lock, color: Colors.grey),
              errorText: state.errorMessage),
          validator: validator,
          onSaved: onSaved,
        ),
      );
}
