import 'package:flutter/material.dart';
import 'package:notes_manager/screens/add_edit_note_page.dart';
import 'package:notes_manager/screens/setting_page.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/home/notes_search_bar.dart';
import '../widgets/home/tag_filter_list.dart';
import '../widgets/home/note_card.dart';
import '../widgets/home/empty_notes_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      final currentUser = authProvider.currentUser;
      if (currentUser != null) {
        noteProvider.setCurrentUserId(currentUser.id);
      }
    });
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
              automaticallyImplyLeading: false,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: lightGrayBackground,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: Row(
                  children: [
                    Icon(Icons.note_alt, color: colorScheme.primary, size: 28,),
                    const SizedBox(width: 6),
                    Text(
                      'Ghi chú',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24, color: colorScheme.primary,),
                    ),
                  ]
                ) 
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

            // Search Bar
            SliverToBoxAdapter(
              child: NotesSearchBar(
                noteProvider: noteProvider,
                colorScheme: colorScheme,
              ),
            ),

            // Bộ lọc Tag ngang
            SliverToBoxAdapter(
              child: TagFilterList(
                tags: tags,
                noteProvider: noteProvider,
                colorScheme: colorScheme,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Danh sách ghi chú
            notes.isEmpty ? const EmptyNotesState() : SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final note = notes[index];
                    return NoteCard(
                      note: note,
                      noteProvider: noteProvider,
                      index: index,
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
}