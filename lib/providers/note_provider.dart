import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/note.dart';

class NoteProvider with ChangeNotifier {
  final Box<Note> _noteBox = Hive.box<Note>('notes_box');
  late Box<List<String>> _tagsBox;

  static const List<String> defaultTags = [
    'Công việc',
    'Cá nhân',
    'Học tập',
    'Mua sắm',
    'Quan trọng',
    'Ý tưởng',
  ];

  String _searchQuery = '';
  String _selectedTag = 'Tất cả';
  List<String> _customTags = [];

  String get selectedTag {
    return _selectedTag;
  }

  // Khởi tạo tags box
  Future<void> initTagsBox() async {
    _tagsBox = await Hive.openBox<List<String>>('tags_box');

    List<String>? savedTags = _tagsBox.get('custom_tags');
    
    if(savedTags == null) {
      _customTags = [];
    }
    else {
      _customTags = List<String>.from(savedTags);
    }

    notifyListeners();
  }

  // Lấy tất cả thẻ (mặc định + tự thêm)
  List<String> get availableTags {
    Set<String> tags = {};

    for(String tag in defaultTags) {
      tags.add(tag);
    }
    for(String tag in _customTags) {
      tags.add(tag);
    }
    List<String> result = tags.toList();
    result.sort();
    return result;
  }

  // Thêm thẻ tùy chỉnh
  Future<void> addCustomTag(String tag) async {
    final nameTag = tag.trim();
    if (nameTag.isEmpty) return;
    if (defaultTags.contains(nameTag) || _customTags.contains(nameTag)) return;
    
    _customTags.add(nameTag);
    await _tagsBox.put('custom_tags', _customTags);
    notifyListeners();
  }

  // Xóa thẻ tùy chỉnh
  Future<void> removeCustomTag(String tag) async {
    if (!_customTags.contains(tag)) return;
    
    _customTags.remove(tag);
    await _tagsBox.put('custom_tags', _customTags);

    if (_selectedTag == tag) {
      _selectedTag = 'Tất cả';
    }
    notifyListeners();
  }

  // Kiểm tra xem thẻ có phải là thẻ tùy chỉnh không
  bool isCustomTag(String tag) {
    return _customTags.contains(tag);
  }

  // Lấy danh sách ghi chú từ Hive và lọc
  List<Note> get notes {
    List<Note> allNotes = _noteBox.values.toList();
    allNotes.sort((a, b) {
      return b.date.compareTo(a.date);
    });

    List<Note> result = [];
    for(Note note in allNotes) {

      bool matchSearch = false;
      if(note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
         note.content.toLowerCase().contains(_searchQuery.toLowerCase())) {
        matchSearch = true;
      }

      bool matchTag = false;
      if(_selectedTag == 'Tất cả' || note.tags.contains(_selectedTag)) {
        matchTag = true;
      }

      if(matchTag && matchSearch) {
        result.add(note);
      }
    }

    return result;
  }

  List<String> get allTags {
    Set<String> tags = {'Tất cả'};
    // Thêm tất cả thẻ có sẵn
    for(var tag in availableTags) {
      tags.add(tag);
    }

    // Thêm thẻ từ các ghi chú
    for (var note in _noteBox.values) {
      tags.addAll(note.tags);
    }

    List<String> tagList = tags.toList();
    // Giữ 'Tất cả' ở đầu, sắp xếp phần còn lại
    tagList.remove('Tất cả');
    tagList.sort();
    
    return ['Tất cả', ...tagList];
  }

  // THÊM
  void addNote(Note note) {
    _noteBox.add(note); // Hive tự sinh key hoặc bạn có thể dùng .put(id, note)
    notifyListeners();
  }

  // SỬA
  void updateNote(Note note) {
    note.save(); // Nhờ kế thừa HiveObject nên chỉ cần gọi save()
    notifyListeners();
  }

  // XÓA
  void deleteNote(Note note) {
    note.delete(); // Xóa trực tiếp khỏi Hive
    notifyListeners();
  }

  // TÌM KIẾM & LỌC
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedTag(String tag) {
    _selectedTag = tag;
    notifyListeners();
  }
}
