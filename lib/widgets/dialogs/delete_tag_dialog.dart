import 'package:flutter/material.dart';
import '../../providers/note_provider.dart';

class DeleteTagDialog extends StatelessWidget {
  final NoteProvider noteProvider;
  final String tag;

  const DeleteTagDialog({
    super.key,
    required this.noteProvider,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Xóa thẻ'),
      content: Text('Bạn có chắc chắn muốn xóa thẻ "$tag" không?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: () {
            noteProvider.removeCustomTag(tag);
            Navigator.pop(context);
          },
          child: const Text('Xóa'),
        ),
      ],
    );
  }
}
