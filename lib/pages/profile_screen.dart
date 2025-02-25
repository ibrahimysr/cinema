import 'package:cinema/components/components.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'account_details_screen.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().refreshProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.user;

    return Scaffold(
      backgroundColor: Appcolor.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: Appcolor.appBackgroundColor,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Appcolor.buttonColor),
            onPressed: () {
              // Profil bilgilerini yenile
              authViewModel.refreshProfile();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Appcolor.buttonColor),
            onPressed: () {
              // Profil düzenleme sayfasına git
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => authViewModel.refreshProfile(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Appcolor.buttonColor,
                  child: Text(
                    user?.name.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Kullanıcı Adı
                Text(
                  user?.name ?? 'Kullanıcı',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Email
                Text(
                  user?.email ?? 'email@example.com',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),
                // Profil Menüsü
                 buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Hesap Bilgileri',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountDetailsScreen(),
                      ),
                    );
                  },
                ),
                buildMenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Bildirimler',
                  onTap: () {
                    // Bildirimler sayfasına git
                  },
                ),
                buildMenuItem(
                  icon: Icons.movie_outlined,
                  title: 'İzleme Geçmişi',
                  onTap: () {
                    // İzleme geçmişi sayfasına git
                  },
                ),
                buildMenuItem(
                  icon: Icons.favorite_border,
                  title: 'Favori Filmler',
                  onTap: () {
                    // Favori filmler sayfasına git
                  },
                ),
                buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Ayarlar',
                  onTap: () {
                    // Ayarlar sayfasına git
                  },
                ),
                const SizedBox(height: 40),
                if (authViewModel.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  CustomButton(
                    text: 'Çıkış Yap',
                    onPressed: () async {
                      try {
                        await authViewModel.logout();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Çıkış yapılırken hata oluştu: $e')),
                          );
                        }
                      }
                    },
                    backgroundColor: Colors.red,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
} 