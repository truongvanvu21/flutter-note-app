import 'package:flutter/material.dart';
import '../../providers/note_provider.dart';
import '../../models/note.dart';

class DeleteNoteDialog extends StatelessWidget {
  final NoteProvider noteProvider;
  final Note note;

  const DeleteNoteDialog({
    super.key,
    required this.noteProvider,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Xóa ghi chú'),
      content: const Text('Ghi chú này sẽ bị xóa vĩnh viễn.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: () {
            noteProvider.deleteNote(note);
            Navigator.pop(context);
          },
          child: const Text('Xóa'),
        ),
      ],
    );
  }
}
