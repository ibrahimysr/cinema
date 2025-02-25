import 'package:cinema/components/components.dart';
import 'package:cinema/core/constants/auth_texts.dart';
import 'package:cinema/core/extension/context_extension.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/core/theme/text_style.dart';
import 'package:cinema/pages/auth/register_screen.dart';
import 'package:cinema/pages/main/cinema_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: context.paddingNormal * 1.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.getDynamicHeight(5)),
                const Text(AuthTexts.loginTitle,
                    style: AppTextStyles.headerLarge),
                SizedBox(height: context.getDynamicHeight(1)),
                const Text(AuthTexts.loginSubtitle,
                    style: AppTextStyles.caption),
                SizedBox(height: context.getDynamicHeight(5)),
                CustomTextField(
                  label: AuthTexts.emailLabel,
                  hintText: AuthTexts.emailHint,
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                ),
                SizedBox(height: context.getDynamicHeight(3)),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: const Text(AuthTexts.forgotPassword,
                        style: AppTextStyles.headerSmall),
                  ),
                ),
                SizedBox(height: context.getDynamicHeight(3)),
                if (authViewModel.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  CustomButton(
                    text: AuthTexts.loginButton,
                    onPressed: () async {
                      try {
                        await authViewModel.login(
                          _emailController.text,
                          _passwordController.text,
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
                SizedBox(height: context.getDynamicHeight(3)),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(AuthTexts.registerLink,
                        style: AppTextStyles.bodyLarge),
                  ),
                ),
                SizedBox(height: context.getDynamicHeight(3)),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: Appcolor.buttonColor, thickness: 2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        AuthTexts.orUseOtherMethod,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: Appcolor.buttonColor, thickness: 2),
                    ),
                  ],
                ),
                SizedBox(height: context.getDynamicHeight(3)),
                CustomButton(
                  text: AuthTexts.googleLogin,
                  onPressed: () {
                    // Handle Google sign in
                  },
                  backgroundColor: Colors.grey[900]!,
                  icon: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqIqkAfkwTLs_JwNYpcLh5fN1yzpG2JTLcwA&s',
                    height: 24,
                  ),
                ),
                SizedBox(height: context.getDynamicHeight(2)),
                CustomButton(
                  text: AuthTexts.facebookLogin,
                  onPressed: () {
                    // Handle Facebook sign in
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
