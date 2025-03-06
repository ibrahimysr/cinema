import 'package:cinema/components/components.dart';
import 'package:cinema/core/extension/context_extension.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/core/theme/text_style.dart';
import 'package:cinema/pages/profile/ticket_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'account_details_screen.dart';
import '../auth/login_screen.dart';

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
          style: AppTextStyles.headerLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Appcolor.buttonColor),
            onPressed: () {
              authViewModel.refreshProfile();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Appcolor.buttonColor),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => authViewModel.refreshProfile(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: context.paddingNormal,
            child: Column(
              children: [
                SizedBox(height: context.getDynamicHeight(3)),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Appcolor.buttonColor,
                  child: Text(
                    user?.userName.substring(0, 1).toUpperCase() ?? 'U',
                    style: AppTextStyles.headerLarge,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  user?.userName ?? 'Kullanıcı',
                  style: AppTextStyles.headerLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  user?.userEmail ?? 'email@example.com',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 16),
                ),
                SizedBox(height: context.getDynamicHeight(3)),
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
                  context: context,
                ),
                buildMenuItem(
                  icon: Icons.confirmation_number_outlined,
                  title: 'Biletlerim (${user?.ticketTotalCount ?? 0})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TicketsDetailsScreen(),
                      ),
                    );
                  },
                  context: context,
                ),
                buildMenuItem(
                  icon: Icons.movie_outlined,
                  title: 'İzleme Geçmişi',
                  onTap: () {},
                  context: context,
                ),
                buildMenuItem(
                  icon: Icons.favorite_border,
                  title: 'Favori Filmler',
                  onTap: () {},
                  context: context,
                ),
                buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Ayarlar',
                  onTap: () {},
                  context: context,
                ),
                SizedBox(height: context.getDynamicHeight(3)),
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
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Çıkış yapılırken hata oluştu: $e'),
                            ),
                          );
                        }
                      }
                    },
                    backgroundColor: Appcolor.buttonColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
