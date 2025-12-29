import 'package:flutter/material.dart';
import 'package:notes_manager/screens/add_edit_note_page.dart';
import 'package:notes_manager/screens/setting_page.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Bảng màu shade200 theo yêu cầu của bạn
  static final List<Color> tagPalette = [
    Colors.blue.shade200,
    Colors.orange.shade200,
    Colors.green.shade200,
    Colors.purple.shade200,
    Colors.pink.shade200,
    Colors.teal.shade200,
  ];

  // Hàm helper để lấy màu cố định cho mỗi tag dựa trên nội dung chữ
  Color _getTagColor(String tag) {
    int hash = 0;
    for (int i = 0; i < tag.length; i++) {
      hash = tag.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return tagPalette[hash.abs() % tagPalette.length];
  }

  // --- Các hàm Dialog giữ nguyên logic thiết kế ---
  void _showAddTagDialog(BuildContext context, NoteProvider noteProvider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Thêm thẻ mới', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Tên thẻ', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                noteProvider.addCustomTag(controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _showDeleteTagDialog(BuildContext context, NoteProvider noteProvider, String tag) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Xóa thẻ'),
        content: Text('Bạn có chắc muốn xóa thẻ "$tag" không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              noteProvider.removeCustomTag(tag);
              Navigator.pop(ctx);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showDeleteNoteDialog(BuildContext context, NoteProvider noteProvider, note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Xóa ghi chú'),
        content: const Text('Ghi chú này sẽ bị xóa vĩnh viễn.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              noteProvider.deleteNote(note);
              Navigator.pop(ctx);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final notes = noteProvider.notes;
    final tags = noteProvider.allTags;
    final colorScheme = Theme.of(context).colorScheme;

    const Color lightGrayBackground = Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: lightGrayBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Sliver App Bar
            SliverAppBar(
              expandedHeight: 100,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: lightGrayBackground,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: Text(
                  'Ghi chú',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingPage()),
                    ),
                  ),
                ),
              ],
            ),

            // Search Bar TRẮNG nổi bật trên nền xám
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: noteProvider.setSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm ghi chú của bạn...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
            ),

            // Bộ lọc Tag ngang
            SliverToBoxAdapter(
              child: SizedBox(
                height: 46,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: tags.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    if (index == tags.length) {
                      return ActionChip(
                        avatar: Icon(Icons.add_rounded, size: 16, color: colorScheme.primary),
                        label: const Text('Thêm thẻ'),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        onPressed: () => _showAddTagDialog(context, noteProvider),
                      );
                    }
                    final tag = tags[index];
                    final selected = tag == noteProvider.selectedTag;
                    return InputChip(
                      label: Text(tag),
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: colorScheme.primary,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : colorScheme.onSurfaceVariant,
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: selected ? colorScheme.primary : Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onSelected: (_) => noteProvider.setSelectedTag(tag),
                      onDeleted: noteProvider.isCustomTag(tag)
                          ? () => _showDeleteTagDialog(context, noteProvider, tag)
                          : null,
                      deleteIcon: Icon(Icons.cancel, size: 16, color: selected ? Colors.white70 : Colors.grey),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Danh sách ghi chú (Card Trắng + Nhiều Tag màu Shade200)
            notes.isEmpty
                ? _buildEmptyState()
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final note = notes[index];
                          final dateText = MaterialLocalizations.of(context).formatShortDate(note.date);
                          
                          // Lấy màu thanh bên dựa trên tag đầu tiên hoặc mặc định
                          final Color sideBarColor = note.tags.isNotEmpty 
                              ? _getTagColor(note.tags.first) 
                              : tagPalette[index % tagPalette.length];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
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
                                                Row(
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
                                                      icon: const Icon(Icons.delete_outline_rounded, size: 20),
                                                      color: Colors.grey.shade400,
                                                      onPressed: () => _showDeleteNoteDialog(context, noteProvider, note),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  note.content,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: Colors.grey.shade600, height: 1.4, fontSize: 14),
                                                ),
                                                const SizedBox(height: 16),
                                                
                                                // HIỂN THỊ NHIỀU TAG VỚI MÀU SHADE 200
                                                if (note.tags.isNotEmpty) ...[
                                                  Wrap(
                                                    spacing: 6,
                                                    runSpacing: 6,
                                                    children: note.tags.map((tag) {
                                                      return Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                        decoration: BoxDecoration(
                                                          color: _getTagColor(tag), // Màu nền shade200
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          tag,
                                                          style: const TextStyle(
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black, // Chữ đen nổi bật
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                  const SizedBox(height: 12),
                                                ],

                                                Row(
                                                  children: [
                                                    Icon(Icons.access_time_filled_rounded, size: 14, color: Colors.grey.shade400),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      dateText,
                                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
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
                        },
                        childCount: notes.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddEditNotePage()),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Ghi chú mới', style: TextStyle(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.note_alt_outlined, size: 80, color: Colors.grey.shade200),
            const SizedBox(height: 16),
            Text(
              'Ghi chú trống',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}