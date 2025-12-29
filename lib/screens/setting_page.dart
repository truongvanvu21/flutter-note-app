import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';
import 'edit_profile_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    
    // Màu xám nhẹ đồng bộ toàn app
    const Color lightGrayBackground = Color(0xFFF5F7FA);

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
        title: const Text(
          'Cài đặt',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. THÔNG TIN NGƯỜI DÙNG (Card Trắng)
              _buildSectionTitle('Tài khoản'),
              const SizedBox(height: 12),
              _buildCardContainer(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: colorScheme.primary.withOpacity(0.2), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: colorScheme.primaryContainer.withOpacity(0.5),
                          child: Icon(Icons.person_rounded, size: 30, color: colorScheme.primary),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authProvider.currentUser?.displayName ?? 'Người dùng',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              authProvider.currentUserEmail.isNotEmpty
                                  ? authProvider.currentUserEmail
                                  : 'Khách truy cập',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      // Nút chỉnh sửa
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EditProfilePage()),
                          );
                        },
                        icon: Icon(
                          Icons.edit_rounded,
                          color: colorScheme.primary,
                        ),
                        tooltip: 'Chỉnh sửa thông tin',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 2. TÙY CHỌN ỨNG DỤNG (Card Trắng chứa các ListTile)
              _buildSectionTitle('Ứng dụng'),
              const SizedBox(height: 12),
              _buildCardContainer(
                child: Column(
                  children: [
                    _buildSettingTile(
                      icon: Icons.palette_outlined,
                      color: Colors.blue,
                      title: 'Giao diện',
                      subtitle: 'Theo hệ thống',
                      onTap: () {},
                    ),
                    Divider(height: 1, indent: 56, color: Colors.grey.shade100),
                    _buildSettingTile(
                      icon: Icons.info_outline_rounded,
                      color: Colors.green,
                      title: 'Về ứng dụng',
                      subtitle: 'Notes Manager v1.0.0',
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Notes Manager',
                          applicationVersion: '1.0.0',
                          applicationIcon: Icon(Icons.note_alt_rounded, size: 48, color: colorScheme.primary),
                          children: [const Text('Ứng dụng quản lý ghi chú đơn giản và hiệu quả.')],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 3. HÀNH ĐỘNG KHÁC (Đăng xuất)
              _buildSectionTitle('Hành động'),
              const SizedBox(height: 12),
              _buildCardContainer(
                child: _buildSettingTile(
                  icon: Icons.logout_rounded,
                  color: Colors.redAccent,
                  title: 'Đăng xuất',
                  titleColor: Colors.redAccent,
                  subtitle: 'Rời khỏi tài khoản hiện tại',
                  onTap: () => _showLogoutDialog(context, authProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Helpers để đồng bộ UI ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: titleColor ?? Colors.black87),
      ),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Đăng xuất?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Bạn có chắc chắn muốn thoát khỏi tài khoản này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await authProvider.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}