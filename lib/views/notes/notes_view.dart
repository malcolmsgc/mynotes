import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    // NB DB is opened automatically by NoteService when methods called
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes'), actions: [
        IconButton(
            onPressed: (() {
              Navigator.of(context).pushNamed(writeNoteRoute);
            }),
            icon: const Icon(Icons.add)),
        PopupMenuButton<MenuAction>(
          onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
            }
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Log out'),
              )
            ];
          },
        )
      ]),
      body: StreamBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                if (allNotes.isNotEmpty) {
                  return NotesListView(
                    notes: allNotes.toList(),
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context)
                          .pushNamed(writeNoteRoute, arguments: note);
                    },
                  );
                } else {
                  return Column(children: [
                    const Text('You have no notes'),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(writeNoteRoute);
                      },
                      child: const Text('Add note'),
                    )
                  ]);
                }
              } else {
                return Column(children: [
                  const Text('You have no notes'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(writeNoteRoute);
                    },
                    child: const Text('Add note'),
                  )
                ]);
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
        stream: _notesService.allNotes(ownerUserId: userId),
      ),
    );
  }
}
