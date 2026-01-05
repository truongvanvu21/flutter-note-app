import 'package:flutter/material.dart';
import '../../providers/note_provider.dart';
import '../dialogs/add_tag_dialog.dart';
import '../dialogs/delete_tag_dialog.dart';

class TagFilterList extends StatelessWidget {
  final List<String> tags;
  final NoteProvider noteProvider;
  final ColorScheme colorScheme;

  const TagFilterList({
    super.key,
    required this.tags,
    required this.noteProvider,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: tags.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == tags.length) {
            return _buildAddTagButton(context);
          }
          return _buildTagChip(context, tags[index]);
        },
      ),
    );
  }

  // Tạo chip thêm thẻ
  Widget _buildAddTagButton(BuildContext context) {
    return ActionChip(
      avatar: Icon(Icons.add_rounded,size: 16,color: colorScheme.primary,),
      label: const Text('Thêm thẻ'),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.grey.shade300),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onPressed: () => _showAddTagDialog(context),
    );
  }

  Widget _buildTagChip(BuildContext context, String tag) {
    final selected = tag == noteProvider.selectedTag;

    return InputChip(
      label: Text(tag),
      selected: selected,
      showCheckmark: false,
      selectedColor: colorScheme.primary,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.grey[800],
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.white,
      side: BorderSide(
        color: selected ? colorScheme.primary : Colors.grey.shade300,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (_) => noteProvider.setSelectedTag(tag),
      onDeleted: noteProvider.isCustomTag(tag)
          ? () => _showDeleteTagDialog(context, tag)
          : null,
      deleteIcon: Icon(Icons.cancel, size: 16,color: selected ? Colors.white70 : Colors.grey,),
    );
  }

  void _showAddTagDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTagDialog(noteProvider: noteProvider),
    );
  }

  void _showDeleteTagDialog(BuildContext context, String tag) {
    showDialog(
      context: context,
      builder: (context) => DeleteTagDialog(noteProvider: noteProvider, tag: tag,),
    );
  }
}
