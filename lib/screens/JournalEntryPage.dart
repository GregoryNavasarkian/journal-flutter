// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:journal/model/journal_entry.dart';
import 'package:journal/db/journal_database.dart';
import 'package:intl/intl.dart';

import 'HomePage.dart';

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
  late String date = formatDate(DateTime.now());
  String formatDate(DateTime date) => DateFormat("yyyy-MM-dd").format(date);

  @override
  void initState() {
    super.initState();
    title = widget.journalEntry?.title ?? '';
    body = widget.journalEntry?.body ?? '';
    rating = widget.journalEntry?.rating ?? 1;
    date = widget.journalEntry?.date ?? formatDate(DateTime.now());
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
                  labelText: 'Rating 1-4',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value)! > 4 ||
                      int.tryParse(value)! < 1) {
                    return 'Please enter a rating between 1 and 4';
                  }
                  return null;
                },
                onSaved: (value) {
                  rating = int.parse(value ?? '1');
                },
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        minimumSize: const Size(90, 40),
                        maximumSize: const Size(90, 40),
                      ),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      child: const Text('Back'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(90, 40),
                        maximumSize: const Size(90, 40),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if (widget.journalEntry == null) {
                            JournalDatabase.instance.create(
                              JournalEntry(
                                title: title,
                                body: body,
                                rating: rating,
                                date: date,
                              ),
                            );
                          } else {
                            JournalDatabase.instance.update(
                              JournalEntry(
                                id: widget.journalEntry!.id,
                                title: title,
                                body: body,
                                rating: rating,
                                date: date,
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
            ],
          ),
        ),
      ),
    );
  }
}
