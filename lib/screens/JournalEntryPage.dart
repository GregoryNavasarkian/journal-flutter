import 'package:flutter/material.dart';
import 'package:journal/model/journal_entry.dart';
import 'package:journal/db/journal_database.dart';

class JournalEntryPage extends StatefulWidget {
  final JournalEntry? journalEntry;

  const JournalEntryPage({Key? key, this.journalEntry}) : super(key: key);

  @override
  State<JournalEntryPage> createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends State<JournalEntryPage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String body;
  late int rating;

  @override
  void initState() {
    super.initState();
    title = widget.journalEntry?.title ?? '';
    body = widget.journalEntry?.body ?? '';
    rating = widget.journalEntry?.rating ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.journalEntry == null ? 'New Entry' : 'Edit Entry'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  title = value ?? '';
                },
              ),
              TextFormField(
                initialValue: body,
                decoration: const InputDecoration(
                  labelText: 'Body',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a body';
                  }
                  return null;
                },
                onSaved: (value) {
                  body = value ?? '';
                },
              ),
              TextFormField(
                initialValue: rating.toString(),
                decoration: const InputDecoration(
                  labelText: 'Rating',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  return null;
                },
                onSaved: (value) {
                  rating = int.parse(value ?? '0');
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.journalEntry == null) {
                      JournalDatabase.instance.create(
                        JournalEntry(
                          title: title,
                          body: body,
                          rating: rating,
                        ),
                      );
                    } else {
                      JournalDatabase.instance.update(
                        JournalEntry(
                          id: widget.journalEntry!.id,
                          title: title,
                          body: body,
                          rating: rating,
                        ),
                      );
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
