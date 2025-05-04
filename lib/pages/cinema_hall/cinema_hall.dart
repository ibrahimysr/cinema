import 'package:cinema/components/components.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/viewmodels/cinema_hall_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';



class CinemaHallsScreen extends StatefulWidget {
  final int movieId;
  const CinemaHallsScreen({super.key, required this.movieId});

  @override
  State<CinemaHallsScreen> createState() => _CinemaHallsScreenState();
}

class _CinemaHallsScreenState extends State<CinemaHallsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late CinemaHallsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<CinemaHallsViewModel>(context, listen: false);
      _viewModel.fetchCinemaData(movieId: widget.movieId).then((_) {
        if (_viewModel.error == null && _viewModel.cinema != null) {
          _controller.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _viewModel.disposeService();
    super.dispose();
  }

  void _showEnhancedDatePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Appcolor.appBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return EnhancedDatePicker(
          initialDate: DateTime.parse(_viewModel.selectedDate),
          onDateSelected: (selectedDate) {
            final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
            _viewModel.updateDate(formattedDate);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CinemaHallsViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Appcolor.appBackgroundColor,
          appBar: AppBar(
            backgroundColor: Appcolor.appBackgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Appcolor.buttonColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.cinema?.cinemaName ?? 'Sinema Bulunamadı',
                  style: const TextStyle(
                    color: Appcolor.white, 
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Seçilen Tarih: ${DateFormat('dd MMM yyyy').format(DateTime.parse(viewModel.selectedDate))}',
                  style: const TextStyle(
                    color: Appcolor.buttonColor, 
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Appcolor.buttonColor),
                onPressed: _showEnhancedDatePicker,
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: viewModel.isLoading
                      ? const CinemaHallsLoader()
                      : viewModel.error != null
                          ? CinemaHallsError(error: viewModel.error!)
                          : CinemaHallsContent(
                              viewModel: viewModel,
                              fadeAnimation: _fadeAnimation,
                              slideAnimation: _slideAnimation,
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
