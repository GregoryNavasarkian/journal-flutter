import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme.dart';
import '../db/journal_database.dart';
import '../model/journal_entry.dart';
import './JournalEntryPage.dart';
import './EditJournalEntryPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<JournalEntry> journalEntries;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshJournalEntries();
  }

  @override
  void dispose() {
    JournalDatabase.instance.close();
    super.dispose();
  }

  Future refreshJournalEntries() async {
    setState(() => isLoading = true);
    journalEntries = await JournalDatabase.instance.readAllJournalEntries();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Journal"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.brightness_6),
              color: Colors.white,
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).swapTheme();
              },
            )
          ],
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : journalEntries.isEmpty
                  ? const Text(
                      'No Entries',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildJournal(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const JournalEntryPage(),
              ),
            );
            refreshJournalEntries();
          },
          child: const Icon(Icons.add),
        ));
  }

  Widget buildJournal() {
    return ListView.builder(
      itemCount: journalEntries.length,
      itemBuilder: (context, index) {
        final journalEntry = journalEntries[index];
        return Card(
          child: ListTile(
            title: Text(journalEntry.title),
            subtitle: Text(journalEntry.body),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditJournalEntryPage(
                      journalId: journalEntry.id!,
                    ),
                  ),
                );
                refreshJournalEntries();
              },
            ),
          ),
        );
      },
    );
  }
}
