// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:journal/model/journal_entry.dart';
import 'package:journal/db/journal_database.dart';

import './JournalEntryPage.dart';

class EditJournalEntryPage extends StatefulWidget {
  final int journalId;

  const EditJournalEntryPage({Key? key, required this.journalId})
      : super(key: key);

  @override
  State<EditJournalEntryPage> createState() => _EditJournalEntryPageState();
}

class _EditJournalEntryPageState extends State<EditJournalEntryPage> {
  late JournalEntry journalEntry =
      const JournalEntry(title: '', body: '', rating: 1, date: '');
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshJournalEntry();
  }

  Future refreshJournalEntry() async {
    setState(() => isLoading = true);
    journalEntry = await JournalDatabase.instance.readJournal(widget.journalId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(journalEntry.date),
          actions: [editButton(), deleteButton()],
        ),
        body: buildJournal(),
      );

  Widget editButton() => ElevatedButton(
      child: const Text('Edit'),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => JournalEntryPage(
            journalEntry: journalEntry,
          ),
        ));

        refreshJournalEntry();
      });

  Widget deleteButton() => ElevatedButton(
        child: const Text('Delete'),
        onPressed: () async {
          await JournalDatabase.instance.delete(widget.journalId);
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        },
      );

  Widget buildJournal() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 4),
              child: Text(
                journalEntry.title,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              journalEntry.body,
              style: const TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text('Rating: ${journalEntry.rating}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
}
