import 'package:cinema/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().user;

    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        title: const Text(
          'Hesap Bilgileri',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(
              title: 'Ad Soyad',
              value: user?.name ?? '-',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),
            _buildInfoSection(
              title: 'E-posta',
              value: user?.email ?? '-',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 20),
            _buildInfoSection(
              title: 'Rol',
              value: user?.roleId == 1 ? 'Super-Admin' : 'Admin',
              icon: Icons.badge_outlined,
            ),
            if (user?.cinemaId != null) ...[
              const SizedBox(height: 20),
              _buildInfoSection(
                title: 'Sinema ID',
                value: user?.cinemaId.toString() ?? '-',
                icon: Icons.movie_outlined,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: buttonColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 