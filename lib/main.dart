import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_manager/screens/home_page.dart';
import 'package:notes_manager/screens/login_page.dart';
import 'models/note.dart';
import 'models/user.dart';
import 'package:provider/provider.dart';
import 'providers/note_provider.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Khởi tạo Hive
  await Hive.initFlutter();

  // 2. Đăng ký Adapter
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(UserAdapter());

  // 3. Mở Box (giống như mở một cái bảng/database)
  await Hive.openBox<Note>('notes_box');
  await Hive.openBox<User>('users_box'); // Box lưu thông tin users
  await Hive.openBox('settings_box'); // Box riêng cho cài đặt và auth

  // Khởi tạo NoteProvider và tags box
  final noteProvider = NoteProvider();
  await noteProvider.initTagsBox();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider.value(value: noteProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;

    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}
