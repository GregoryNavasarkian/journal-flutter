// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    journalEntries = [];
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
          title: const Center(child: Text("Journal Entries")),
        ),
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Row(
                  children: [
                    Expanded(
                      child: journalEntries.isEmpty ? empty() : buildJournal(),
                    ),
                  ],
                );
              } else {
                return journalEntries.isEmpty ? empty() : buildJournalWide();
              }
            },
          ),
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // ignore: sized_box_for_whitespace
              Container(
                height: 110,
                child: const DrawerHeader(
                  child: Text('Settings', style: TextStyle(fontSize: 17)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: SwitchListTile(
                  title:
                      const Text('Dark Theme', style: TextStyle(fontSize: 16)),
                  value: Provider.of<ThemeProvider>(context).getThemeMode(),
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .swapTheme();
                  },
                ),
              ),
            ],
          ),
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
          child: GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditJournalEntryPage(
                    journalId: journalEntry.id!,
                  ),
                ),
              );
              refreshJournalEntries();
            },
            child: ListTile(
              title: Text(journalEntry.title),
              subtitle: formattedDate(journalEntry.date),
            ),
          ),
        );
      },
    );
  }

  Widget buildJournalWide() {
    return ListView.builder(
      itemCount: journalEntries.length,
      itemBuilder: (context, index) {
        final journalEntry = journalEntries[index];
        return Card(
          child: GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditJournalEntryPage(
                    journalId: journalEntry.id!,
                  ),
                ),
              );
              refreshJournalEntries();
            },
            child: ListTile(
              isThreeLine: true,
              title: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(journalEntry.title,
                    style: const TextStyle(fontSize: 20)),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: formattedDate(journalEntry.date),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  children: [
                    Text(journalEntry.title,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(journalEntry.body,
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget formattedDate(String date) {
    DateTime tempDate = DateTime.parse(date);
    return Text(DateFormat('EEEE, MMMM d, yyyy').format(tempDate));
  }

  Widget empty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Icon(
            Icons.book,
            size: 150,
            color: Color.fromARGB(255, 73, 73, 73),
          ),
        ),
        const Text("No Journal Entries",
            style: TextStyle(
                fontSize: 20, color: Color.fromARGB(255, 29, 29, 29))),
      ],
    );
  }
}
