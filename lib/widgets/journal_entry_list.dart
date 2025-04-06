import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/journal_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class JournalEntryList extends StatelessWidget {
  const JournalEntryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JournalProvider>(
      builder: (context, journalProvider, child) {
        if (journalProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (journalProvider.error.isNotEmpty) {
          return Center(
            child: Text(
              journalProvider.error,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (journalProvider.entries.isEmpty) {
          return const Center(
            child: Text('No journal entries yet. Start writing!'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => journalProvider.fetchEntries(),
          child: ListView.builder(
            itemCount: journalProvider.entries.length,
            itemBuilder: (context, index) {
              final entry = journalProvider.entries[index];
              return Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) => journalProvider.deleteEntry(entry.id),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    entry.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Row(
                    children: [
                      Text(DateFormat('MMM d, y').format(entry.date)),
                      const SizedBox(width: 8),
                      Text(entry.mood),
                    ],
                  ),
                  trailing: entry.tags.isNotEmpty
                      ? Chip(
                          label: Text(entry.tags.first),
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        )
                      : null,
                  onTap: () {
                    // TODO: Navigate to entry details screen
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
} 