import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  const ProfileScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _profileHeader(),
          const SizedBox(height: 20),
          _menuSection(context),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // 👤 AVATAR
          Stack(
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundImage:
                    NetworkImage("https://i.pravatar.cc/300"),
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.edit, size: 18),
                  ),
                ),
              )
            ],
          ).animate().scale(duration: 400.ms),

          const SizedBox(height: 12),

          // 👤 NAME
          Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "user@email.com",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  // ================= MENU =================
  Widget _menuSection(BuildContext context) {
    return Column(
      children: [
        _menuItem(
          icon: Icons.edit,
          title: "Edit Profile",
          onTap: () {
            _showEditDialog(context);
          },
        ),
        _menuItem(
          icon: Icons.security,
          title: "Security",
          onTap: () {},
        ),
        _menuItem(
          icon: Icons.help_outline,
          title: "Help Center",
          onTap: () {},
        ),
        _menuItem(
          icon: Icons.logout,
          title: "Logout",
          color: Colors.red,
          onTap: () {},
        ),
      ],
    );
  }

  // ================= MENU ITEM =================
  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: color ?? Colors.orange),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.2);
  }

  // ================= EDIT DIALOG =================
  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: userName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Name"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter your name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Name updated!")),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}