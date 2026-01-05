import 'package:flutter/material.dart';
import '../../providers/note_provider.dart';

class AddTagDialog extends StatelessWidget {
  final NoteProvider noteProvider;

  const AddTagDialog({
    super.key,
    required this.noteProvider,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Thêm thẻ mới',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Tên thẻ',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              noteProvider.addCustomTag(controller.text.trim());
              Navigator.pop(context);
            }
          },
          child: const Text('Thêm'),
        ),
      ],
    );
  }
}
