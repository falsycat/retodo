import 'package:flutter/material.dart';
import 'package:todo/model/occurrence.dart';
import 'package:todo/model/task.dart';
import 'package:todo/widget/duration_form_field.dart';
import 'package:todo/widget/occurrence_form_field/occurrence_form_field.dart';

class TaskEditPage extends StatefulWidget {
  final Task? initial;

  const TaskEditPage({
    super.key,
    this.initial,
  });

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  final _form = GlobalKey<FormState>();

  final _title = TextEditingController();
  late Occurrence _occurrence;
  late Duration _duration;

  @override
  void initState() {
    super.initState();

    final initial = widget.initial;
    if (null != initial) {
      _title.text = initial.title;
      _occurrence = initial.occurrence;
      _duration = initial.duration;
    } else {
      _title.text = "";
      _occurrence = OccurrenceOneshot(DateTime.now());
      _duration = const Duration(days: 1);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Edit Task"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  controller: _title,
                  validator: (v) => v == "" ? "empty title" : null,
                ),
                OccurrenceFormField(
                  initial: _occurrence,
                  onChanged: (a) => _occurrence = a,
                ),
                DurationFormField(
                  initial: _duration,
                  onChanged: (a) => _duration = a,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _save,
          child: const Icon(Icons.save),
        ),
      );

  void _save() {
    final form = _form.currentState;
    if (null == form || !form.validate()) {
      return;
    }
    Navigator.of(context).pop(
      Task(
        title: _title.text,
        occurrence: _occurrence,
        duration: _duration,
      ),
    );
  }
}
