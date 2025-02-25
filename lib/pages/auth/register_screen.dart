import 'package:cinema/components/components.dart';
import 'package:cinema/const.dart';
import 'package:cinema/pages/auth/login_screen.dart';
import 'package:cinema/pages/cinema_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(); 
    final _passwordConfirmController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Kayıt Ol',
                  style: AppTextStyles.headerLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Devam etmek için lütfen bir hesap oluşturun',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  label: 'Kullanıcı Adı',
                  hintText: 'Kullanıcı Adınızı Giriniz',
                  controller: _usernameController,
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Email',
                  hintText: 'Emailinizi Giriniz',
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Şifre',
                  hintText: 'Şifrenizi Giriniz',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  isPasswordVisible: _isPasswordVisible,
                  onVisibilityToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ), 
                  const SizedBox(height: 24),
                CustomTextField(
                  label: 'Şifrenizi Onaylayınız',
                  hintText: 'Şifrenizi Tekrar Giriniz',
                  controller: _passwordConfirmController,
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  isPasswordVisible: _isPasswordVisible,
                  onVisibilityToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 40),
                if (authViewModel.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  CustomButton(
                    text: 'Kayıt Ol',
                    onPressed: () async {
                      try {
                        await authViewModel.register(
                          _usernameController.text,
                          _emailController.text,
                          _passwordController.text,
                          _passwordConfirmController.text,
                        );
                        if (mounted && authViewModel.isLoggedIn) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CinemaMainScreen(),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                  ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Veya Diğer Yöntemler',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Google İle Kayıt Ol',
                  onPressed: () {
                    // Handle Google sign up
                  },
                  backgroundColor: Colors.grey[900]!,
                  icon: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqIqkAfkwTLs_JwNYpcLh5fN1yzpG2JTLcwA&s',
                    height: 24,
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Facebook İle Kayıt Ol',
                  onPressed: () {
                    // Handle Facebook sign up
                  },
                  backgroundColor: Colors.grey[900]!,
                  icon: const Icon(
                    Icons.facebook,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}