import 'package:cinema/components/components.dart';
import 'package:cinema/core/constants/auth_texts.dart';
import 'package:cinema/core/theme/text_style.dart';
import 'package:cinema/pages/main/cinema_main_screen.dart';
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
                const Text(
                  AuthTexts.registerTitle,
                  style: AppTextStyles.headerLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  AuthTexts.registerSubtitle,
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  label: AuthTexts.usernameLabel,
                  hintText: AuthTexts.usernameHint,
                  controller: _usernameController,
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: AuthTexts.emailLabel,
                  hintText: AuthTexts.emailHint,
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: AuthTexts.passwordLabel,
                  hintText: AuthTexts.passwordHint,
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
                  label: AuthTexts.confirmPasswordLabel,
                  hintText: AuthTexts.confirmPasswordHint,
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
                    text: AuthTexts.registerButton,
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
                    AuthTexts.orOtherMethods,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: AuthTexts.googleRegister,
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
                  text: AuthTexts.facebookRegister,
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