import 'package:cinema/components/components.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/viewmodels/cinema_hall_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EnhancedDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const EnhancedDatePicker({
    Key? key, 
    required this.initialDate, 
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _EnhancedDatePickerState createState() => _EnhancedDatePickerState();
}

class _EnhancedDatePickerState extends State<EnhancedDatePicker> {
  late DateTime _selectedDate;
  final List<String> _weekdays = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }


  void _selectDateFromList(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateSelected(date);
  }

  Widget _buildDateChips() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        itemBuilder: (context, index) {
          DateTime date = DateTime.now().add(Duration(days: index));
          bool isSelected = _selectedDate.year == date.year && 
                            _selectedDate.month == date.month && 
                            _selectedDate.day == date.day;

          return GestureDetector(
            onTap: () => _selectDateFromList(date),
            child: Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: isSelected ? Appcolor.buttonColor : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? Appcolor.buttonColor : Appcolor.grey,
                  width: 1.5
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekdays[date.weekday - 1],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Appcolor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Appcolor.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Appcolor.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Tarih Seçin',
            style: TextStyle(
              color: Appcolor.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildDateChips(),
        const SizedBox(height: 20),
      ],
    );
  }
}

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
      duration: const Duration(milliseconds: 800),
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
                  viewModel.cinema?.cinemaName ?? 'Cinemarine Adana',
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
