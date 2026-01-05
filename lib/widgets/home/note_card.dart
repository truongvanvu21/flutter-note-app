import 'package:flutter/material.dart';
import '../../models/note.dart';
import '../../providers/note_provider.dart';
import '../../screens/add_edit_note_page.dart';
import '../../utils/tag_color_helper.dart';
import '../dialogs/delete_note_dialog.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final NoteProvider noteProvider;
  final int index;

  const NoteCard({
    super.key,
    required this.note,
    required this.noteProvider,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = MaterialLocalizations.of(
      context,
    ).formatShortDate(note.date);

    // Lấy màu thanh bên dựa trên tag đầu tiên hoặc mặc định
    final Color sideBarColor = note.tags.isNotEmpty
        ? TagColorHelper.getTagColor(note.tags.first)
        : TagColorHelper.getColorByIndex(index);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddEditNotePage(note: note)),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Thanh màu trang trí bên trái
                  Container(width: 6, color: sideBarColor),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildNoteHeader(context),
                          _buildNoteContent(),
                          const SizedBox(height: 16),
                          if (note.tags.isNotEmpty)
                            Column(
                              children: [
                                _buildTagsSection(),
                                const SizedBox(height: 12),
                              ],
                            ),
                          _buildNoteDateInfo(dateText),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            note.title.isEmpty ? '(Không tiêu đề)' : note.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_rounded, size: 22),
          color: const Color.fromARGB(255, 218, 61, 59),
          onPressed: () => _showDeleteDialog(context),
        ),
      ],
    );
  }

  Widget _buildNoteContent() {
    return Text(
      note.content,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Colors.grey.shade600, height: 1.4, fontSize: 14),
    );
  }

  Widget _buildTagsSection() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final tag in note.tags)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: TagColorHelper.getTagColor(tag),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNoteDateInfo(String dateText) {
    return Row(
      children: [
        Icon(
          Icons.access_time_filled_rounded,
          size: 14,
          color: Colors.grey.shade400,
        ),
        const SizedBox(width: 4),
        Text(
          dateText,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          DeleteNoteDialog(noteProvider: noteProvider, note: note),
    );
  }
}
