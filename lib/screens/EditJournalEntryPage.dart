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
  late JournalEntry journalEntry;
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

  // @override
  // Widget build(BuildContext context) {
  //   return (Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Edit Entry'),
  //     ),
  //     body: Column(
  //       children: <Widget>[
  //         Text(journalEntry.title),
  //         Text(journalEntry.body),
  //         Text(journalEntry.rating.toString()),
  //       ],
  //     ),
  //   ));
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      journalEntry.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      journalEntry.body,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 18),
                    )
                  ],
                ),
              ),
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
          Navigator.of(context).pop();
        },
      );
}
