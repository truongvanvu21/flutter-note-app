import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  const AddEditNotePage({super.key, this.note});

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> _selectedTags = [];

  final List<Color> pastelColors = [
    Colors.blue.shade200,
    Colors.orange.shade200,
    Colors.green.shade200,
    Colors.purple.shade200,
    Colors.pink.shade200,
    Colors.teal.shade200,
  ];

  @override
  void initState() {
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedTags = List.from(widget.note!.tags);
    }
    super.initState();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    if (widget.note == null) {
      noteProvider.addNote(
        Note(
          id: DateTime.now().toString(),
          title: title,
          content: content,
          tags: _selectedTags,
          date: DateTime.now(),
        ),
      );
    } else {
      widget.note!.title = title;
      widget.note!.content = content;
      widget.note!.tags = _selectedTags;
      widget.note!.date = DateTime.now();
      noteProvider.updateNote(widget.note!);
    }
    Navigator.pop(context);
  }

  // Hiển thị hộp thoại chọn thẻ
  void _showTagSelectionDialog() {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final newTagController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final availableTags = noteProvider.availableTags;
          
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text('Chọn thẻ', style: TextStyle(fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: newTagController,
                    decoration: InputDecoration(
                      hintText: 'Thêm thẻ mới...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: () {
                          if (newTagController.text.trim().isNotEmpty) {
                            noteProvider.addCustomTag(newTagController.text.trim());
                            setDialogState(() {});
                            newTagController.clear();
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: availableTags.map((tag) {
                          final isSelected = _selectedTags.contains(tag);
                          return FilterChip(
                            label: Text(tag),
                            selected: isSelected,
                            selectedColor: Theme.of(context).colorScheme.primary,
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            backgroundColor: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            onSelected: (selected) {
                              setDialogState(() {
                                if (selected) {
                                  _selectedTags.add(tag);
                                } else {
                                  _selectedTags.remove(tag);
                                }
                              });
                              setState(() {});
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Xong')),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color lightGrayBackground = Color(0xFFF5F7FA);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: lightGrayBackground,
      appBar: AppBar(
        backgroundColor: lightGrayBackground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.note == null ? 'Ghi chú mới' : 'Chỉnh sửa',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _save,
              child: Text('Lưu', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Tiêu đề
                _buildCardContainer(
                  child: TextFormField(
                    controller: _titleController,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: 'Tiêu đề ghi chú...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    validator: (v) => v!.trim().isEmpty ? 'Tiêu đề không được để trống' : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Input Nội dung
                _buildCardContainer(
                  child: TextFormField(
                    controller: _contentController,
                    minLines: 10,
                    maxLines: null,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                    decoration: const InputDecoration(
                      hintText: 'Hãy viết điều gì đó...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Chọn thẻ (Tags)
                const Text('Thẻ ghi chú', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _showTagSelectionDialog,
                  borderRadius: BorderRadius.circular(16),
                  child: _buildCardContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: _selectedTags.isEmpty
                          ? Row(
                              children: [
                                Icon(Icons.sell_outlined, size: 20, color: Colors.grey.shade400),
                                const SizedBox(width: 8),
                                Text('Chưa có thẻ nào', style: TextStyle(color: Colors.grey.shade400)),
                                const Spacer(),
                                const Icon(Icons.add_circle_outline, color: Colors.blue),
                              ],
                            )
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _selectedTags.asMap().entries.map((entry) {
                                int idx = entry.key;
                                String tag = entry.value;
                                Color color = pastelColors[idx % pastelColors.length];
                                
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(tag, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () => setState(() => _selectedTags.remove(tag)),
                                        child: const Icon(Icons.close, size: 14, color: Color.fromARGB(137, 16, 16, 16)),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Nút lưu ghi chú
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _save,
                    icon: const Icon(Icons.check_circle_rounded),
                    label: const Text('Hoàn tất ghi chú', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper để tạo container trắng 
  Widget _buildCardContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}