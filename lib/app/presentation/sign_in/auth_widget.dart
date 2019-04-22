import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_to_eat/app/bloc/auth_bloc.dart';
import 'package:join_to_eat/app/bloc/auth_event.dart';
import 'package:join_to_eat/app/presentation/main_view.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:join_to_eat/app/utils/widgets/routing_wrapper.dart';

class SignInWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInForm();
}

class _SignInForm extends State<SignInWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _bloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Join To Eat.')),
      body: BlocBuilder<UserEvent, AuthState>(
        bloc: _bloc,
        builder: (context, state) => Container(

            child: (state.field != FormMode.mainScreen) ? Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                shrinkWrap: true,
                children: <Widget>[
                  CustomFieldSignIn(
                      validator: _bloc.validateEmail,
                      onSaved: _bloc.onEmailSaved,
                      state: state),
                  _getButton(),
                ],
              ),
            ) : MainView()
        ),
      ),
    );
  }

  Widget _navigateToMainScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainView()),
    );
    return Text("MainView");
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
  final AuthState state;

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