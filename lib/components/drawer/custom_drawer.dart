import 'package:cinema/core/extension/context_extension.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/core/theme/text_style.dart';
import 'package:cinema/pages/auth/login_screen.dart';
import 'package:cinema/pages/home/home_page_cinema.dart';
import 'package:cinema/pages/main/cinema_main_screen.dart';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class CinemaDrawer extends StatefulWidget {
  final int currentIndex;

  const CinemaDrawer({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  State<CinemaDrawer> createState() => _CinemaDrawerState();
}

class _CinemaDrawerState extends State<CinemaDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToPage(BuildContext context, int index) {
    if (index == _selectedIndex) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    Navigator.pop(context);

    switch (index) {
      case 0:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const CinemaMainScreen()));
        break;
      case 1:
        final authViewModel =
            Provider.of<AuthViewModel>(context, listen: false);
        if (!authViewModel.isLoggedIn) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
          return;
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomePageCinema()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomePageCinema()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomePageCinema()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomePageCinema()));
        break;
      case 5:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomePageCinema()));
        break;
      case 6:
        final authViewModel =
            Provider.of<AuthViewModel>(context, listen: false);
        if (!authViewModel.isLoggedIn) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
          return;
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomePageCinema()));
        break;
      case 7:
        final authViewModel =
            Provider.of<AuthViewModel>(context, listen: false);
        if (!authViewModel.isLoggedIn) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
          return;
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomePageCinema()));
        break;
      case 8:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomePageCinema()));
        break;
      case 9:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomePageCinema()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 280,
          decoration: const BoxDecoration(
            color: Appcolor.appBackgroundColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Appcolor.buttonColor,
                blurRadius: 35,
                offset: Offset(5, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildUserProfile(),
                    const SizedBox(height: 30),
                    ..._buildMenuItems().map(
                      (item) => FadeTransition(
                        opacity: _animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(-1, 0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _controller,
                            curve: Interval(
                              0.4 + (_buildMenuItems().indexOf(item) * 0.1),
                              1.0,
                              curve: Curves.easeOut,
                            ),
                          )),
                          child: item,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: context.paddingNormalVertical *
          2,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Appcolor.buttonColor, Appcolor.appBackgroundColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          ScaleTransition(
            scale: _animation,
            child: Text("Cinema Plus",
                style: AppTextStyles.headerLarge.copyWith(fontSize: 26)),
          ),
          SizedBox(height: context.getDynamicHeight(1)),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(_animation),
            child: const Text("Film Randevu Sistemi",
                style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        final user = authViewModel.user;

        return Padding(
          padding: context.paddingNormalHorizontal,
          child: Row(
            children: [
              ScaleTransition(
                scale: _animation,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Appcolor.buttonColor, width: 2),
                      color: Appcolor.buttonColor),
                  child: Center(
                    child: Text(user?.userName.substring(0, 1).toUpperCase() ?? 'U',
                        style:
                            AppTextStyles.headerLarge.copyWith(fontSize: 24)),
                  ),
                ),
              ),
              SizedBox(width: context.getDynamicWidth(4)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeTransition(
                      opacity: _animation,
                      child: Text(user?.userName ?? "Misafir Kullanıcı",
                          style: AppTextStyles.headerMedium),
                    ),
                    SizedBox(height: context.getDynamicHeight(1)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white70),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildMenuItems() {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.home_outlined, 'title': "Ana Sayfa", 'index': 0},
      {'icon': Icons.event_available, 'title': "Randevularım", 'index': 1},
      {'icon': Icons.movie_outlined, 'title': "Vizyondaki Filmler", 'index': 2},
      {'icon': Icons.upcoming, 'title': "Yakında Gelecekler", 'index': 3},
      {'icon': Icons.theater_comedy, 'title': "Sinemalar", 'index': 4},
      {
        'icon': Icons.local_activity_outlined,
        'title': "Promosyonlar",
        'index': 5
      },
      {'icon': Icons.favorite_border, 'title': "Favorilerim", 'index': 6},
      {'icon': Icons.history, 'title': "İzleme Geçmişim", 'index': 7},
      {
        'icon': Icons.notifications_outlined,
        'title': "Bildirimler",
        'index': 8
      },
      {'icon': Icons.help_outline, 'title': "Yardım & Destek", 'index': 9},
    ];

    return items
        .map((item) => _buildMenuItem(item['icon'], item['title'],
            item['index'], item['index'] == _selectedIndex))
        .toList();
  }

  Widget _buildMenuItem(
      IconData icon, String title, int index, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: isSelected
              ? [Appcolor.buttonColor.withValues(alpha:0.5), Appcolor.grey]
              : [Appcolor.grey, Appcolor.grey],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToPage(context, index),
        borderRadius: BorderRadius.circular(10),
        highlightColor: Appcolor.buttonColor,
        splashColor: Appcolor.buttonColor,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: context.normalValue, vertical:  context.normalValue * 0.8),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Appcolor.buttonColor : Colors.white,
                size: 22,
              ),
               SizedBox(width: context.getDynamicWidth(4)),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected ? Appcolor.buttonColor : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: (isSelected ? Appcolor.buttonColor : Colors.white)
                    .withValues(alpha:0.5),
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return InkWell(
          onTap: () async {
            if (authViewModel.isLoggedIn) {
              try {
                await authViewModel.logout();
                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (route) => false);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Çıkış yapılırken hata oluştu: $e')),
                  );
                }
              }
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [Appcolor.buttonColor, Appcolor.appBackgroundColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: FadeTransition(
              opacity: _animation,
              child: Row(
                children: [
                  Icon(
                    authViewModel.isLoggedIn ? Icons.logout : Icons.login,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    authViewModel.isLoggedIn ? "Çıkış Yap" : "Giriş Yap",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
