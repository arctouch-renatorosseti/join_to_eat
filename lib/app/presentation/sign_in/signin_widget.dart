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
          child: BlocBuilder<UserEvent, UserState>(
              bloc: _bloc,
              builder: (context, state) => Container(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        CustomFieldSignIn(
                            validator: _bloc.validateEmail,
                            onSaved: _bloc.onEmailSaved,
                            state: state),
//                          title: TextFormField (
//                            maxLines: 1,
//                            keyboardType: TextInputType.emailAddress,
//                            autofocus: false,
//                            decoration: InputDecoration(
//                              hintText: "Email from PingBoard",
//                              errorText: "Email ${state.message}",
//                            ),
//                            validator: _bloc.validateEmail,
//                            onSaved: (String email) {
//                              print('saved $email');
//                              _bloc.onEmailSaved(email);
//                            },
//                          ),

                        _getButton(),
                      ],
                    ),
                  ))
          ),
    );
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  _getButton() {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final form = _formKey.currentState;
          if (form.validate()) {
            form.save();
            _bloc.dispatch(UserEvent.submit);
          }
        }
    );
  }
}

class CustomFieldSignIn extends StatelessWidget {
  final Function(String) validator;
  final Function(String) onSaved;
  final UserState state;

  const CustomFieldSignIn({Key key, @required this.validator, @required this.onSaved, @required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
    child: TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
          hintText: (state.field == FormMode.email) ?  Strings.email : Strings.securityKey,
          icon: Icon((state.field == FormMode.email) ? Icons.mail : Icons.lock, color: Colors.grey),
          errorText: state.errorMessage

      ),
      validator: validator,
      onSaved: onSaved,
    ),
  );
}