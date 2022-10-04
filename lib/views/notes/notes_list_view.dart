import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final List<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;
  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: notes.length,
      itemBuilder: ((context, index) {
        final note = notes.elementAt(index);
        return ListTile(
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
            color: Colors.pink,
          ),
          tileColor: const Color.fromARGB(255, 247, 223, 242),
          onTap: () {
            onTap(note);
          },
        );
      }),
      separatorBuilder: (context, index) => const Divider(
        indent: 0,
        endIndent: 0,
        height: 5,
        thickness: 1,
        color: Colors.purple,
      ),
    );
  }
}
