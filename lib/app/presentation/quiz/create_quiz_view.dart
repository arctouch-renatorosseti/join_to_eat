import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_to_eat/app/bloc/quiz/quiz_bloc.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:sprintf/sprintf.dart';

class CreateQuizView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateQuizViewState();
}

class _CreateQuizViewState extends State<CreateQuizView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final QuizBloc _quizBloc = QuizBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.createQuizTitle)),
      body: BlocBuilder<QuizEvent, QuizState>(
        bloc: _quizBloc,
        builder: (context, state) => Form(
              key: this._formKey,
              child: ListView.builder(
                padding: EdgeInsets.all(20.0),
                itemCount: state.optionNumbers,
                itemBuilder: (BuildContext context, int index) => optionBuilder(context, index),
              ),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _quizBloc.dispatch(QuizEvent.ADD_QUIZ_OPTION);
        },
      ),
    );
  }

  Widget optionBuilder(BuildContext context, int index) {
    return TextFormField(
      decoration:
          InputDecoration(labelText: sprintf(index == 0 ? Strings.questionTitle : Strings.optionsTitle, [index])),
      validator: (value) {
        if (value.isEmpty) {
          return Strings.optionEmptyError;
        }
      },
    );
  }
}
