import 'package:cinema/components/drawer/custom_drawer.dart';
import 'package:cinema/core/extension/context_extension.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/core/theme/text_style.dart';
import 'package:cinema/models/user_model.dart';
import 'package:cinema/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TicketsDetailsScreen extends StatefulWidget {
  const TicketsDetailsScreen({super.key});

  @override
  State<TicketsDetailsScreen> createState() => _TicketsDetailsScreenState();
}

class _TicketsDetailsScreenState extends State<TicketsDetailsScreen> {
  bool _isInitialized = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeDateFormatting();
    _loadUserData();
  }

  Future<void> _initializeDateFormatting() async {
    await initializeDateFormatting('tr_TR', null);
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    
    final authViewModel = context.read<AuthViewModel>();
    try {
      await authViewModel.refreshProfile();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Biletler yüklenirken hata oluştu: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().user;

    return Scaffold(
      backgroundColor: Appcolor.appBackgroundColor,
            drawer: const CinemaDrawer(),

      appBar: AppBar(
        backgroundColor: Appcolor.appBackgroundColor,
        title: const Text(
          'Biletlerim',
          style: AppTextStyles.headerLarge,
        ),
        
      ),
      body: Padding(
        padding: context.paddingNormal,
        child: !_isInitialized || _isLoading
            ? const Center(child: CircularProgressIndicator())
            : (user?.ticketItems.isEmpty ?? true)
                ? const Center(
                    child: Text(
                      'Henüz biletiniz bulunmamaktadır',
                      style: AppTextStyles.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    itemCount: user?.ticketItems.length ?? 0,
                    itemBuilder: (context, index) {
                      final ticket = user!.ticketItems[index];
                      return _buildTicketCard(context, ticket);
                    },
                  ),
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, TicketItem ticket) {
    final dateFormat = DateFormat('dd MMMM yyyy HH:mm', 'tr');
    final purchaseDate = DateTime.parse(ticket.purchaseDate);
    final showtimeDate = DateTime.parse(ticket.showtime);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Appcolor.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  ticket.movieTitle,
                  style: AppTextStyles.headerMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${ticket.price} TL',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Appcolor.buttonColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          _buildSectionTitle('Bilet Detayları'),
          _buildTicketInfoRow(
            icon: Icons.movie,
            title: 'Film',
            value: ticket.movieTitle,
          ),
          _buildTicketInfoRow(
            icon: Icons.calendar_today,
            title: 'Seans',
            value: dateFormat.format(showtimeDate),
          ),
          _buildTicketInfoRow(
            icon: Icons.location_on,
            title: 'Sinema',
            value: ticket.cinemaName,
          ),
          _buildTicketInfoRow(
            icon: Icons.meeting_room,
            title: 'Salon',
            value: ticket.hallName,
          ),
          _buildTicketInfoRow(
            icon: Icons.event_seat,
            title: 'Koltuk',
            value: ticket.seatCode,
          ),
          
          const SizedBox(height: 12),
          
          _buildSectionTitle('Ödeme ve Durum'),
          _buildTicketInfoRow(
            icon: Icons.credit_card,
            title: 'Ödeme Yöntemi',
            value: _formatPaymentMethod(ticket.paymentMethod),
          ),
          _buildTicketInfoRow(
            icon: Icons.receipt,
            title: 'Satın Alma',
            value: dateFormat.format(purchaseDate),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusChip(
                text: _formatStatus(ticket.status),
                color: ticket.status == 'sold' ? Colors.green : Colors.orange,
              ),
              _buildStatusChip(
                text: _formatPaymentStatus(ticket.paymentStatus),
                color: ticket.paymentStatus == 'pending'
                    ? Colors.orange
                    : Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: Appcolor.buttonColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTicketInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Appcolor.buttonColor),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              '$title:',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[400]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha:  0.2), 
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
        ),
      ),
    );
  }

  String _formatPaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'credit_card':
        return 'Kredi Kartı';
      case 'debit_card':
        return 'Banka Kartı';
      case 'cash':
        return 'Nakit';
      default:
        return method;
    }
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'sold':
        return 'Satıldı';
      case 'reserved':
        return 'Rezerve';
      default:
        return status;
    }
  }

  String _formatPaymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Beklemede';
      case 'completed':
        return 'Tamamlandı';
      case 'failed':
        return 'Başarısız';
      default:
        return status;
    }
  }
}