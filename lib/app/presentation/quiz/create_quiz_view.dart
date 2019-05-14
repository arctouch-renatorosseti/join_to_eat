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
  final int INDEX_QUESTION = 0;
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
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              heroTag: "addFloating",
              child: Icon(Icons.add),
              onPressed: () {
                _quizBloc.dispatch(QuizEvent.ADD_QUIZ_OPTION);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              heroTag: "saveFloation",
              child: Icon(Icons.save),
              onPressed: () {
                _quizBloc.dispatch(QuizEvent.SAVE_QUIZ);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget optionBuilder(BuildContext context, int index) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: sprintf(index == INDEX_QUESTION ? Strings.questionTitle : Strings.optionsTitle, [index])),
      onSaved: (value) {
        (index == INDEX_QUESTION) ? _quizBloc.onSaveQuestion(value) : _quizBloc.onSaveOptionAnswers(value, index);
      },
      validator: (value) {
        if (value.isEmpty) {
          return Strings.optionEmptyError;
        }
      },
    );
  }
}
