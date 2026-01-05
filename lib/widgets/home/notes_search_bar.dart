import 'package:flutter/material.dart';
import '../../providers/note_provider.dart';

class NotesSearchBar extends StatelessWidget {
  final NoteProvider noteProvider;
  final ColorScheme colorScheme;

  const NotesSearchBar({
    super.key,
    required this.noteProvider,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: noteProvider.setSearchQuery,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm ghi chú của bạn...',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: colorScheme.primary,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }
}
