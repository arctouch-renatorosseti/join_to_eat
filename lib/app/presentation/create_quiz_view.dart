import 'package:flutter/material.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:sprintf/sprintf.dart';

class CreateQuizView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateQuizViewState();
}

class _CreateQuizViewState extends State<CreateQuizView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _options = new List<String>(6);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.createQuizTitle)),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
              key: this._formKey,
              child: ListView.builder(
                itemCount: _options.length,
                itemBuilder: (BuildContext context, int index) => optionBuilder(context, index),
              ))),
    );
  }

  Widget optionBuilder(BuildContext context, int index) {
    return TextFormField(
      decoration: InputDecoration(labelText: sprintf(Strings.optionsTitle, [index])),
      validator: (value) {
        if (value.isEmpty) {
          return Strings.optionEmptyError;
        }
      },
    );
  }
}
