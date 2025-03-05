import 'dart:convert';

import 'package:cinema/core/services/auth/auth_service.dart';
import 'package:cinema/core/services/storage/storage_service.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/core/theme/text_style.dart';
import 'package:cinema/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentConfirmationScreen extends StatefulWidget {
  final TicketCreationResponse ticketResponse;

  const PaymentConfirmationScreen({required this.ticketResponse, super.key});

  @override
  State<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _customerName = '';
  String? _customerEmail = '';
  String? _customerPhone = '';
  String _paymentMethod = 'credit_card';
  bool _isLoading = false;

  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    final storageService = HiveStorageService();
    _authService = AuthService(storageService: storageService);
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Kimlik doğrulama hatası: Token bulunamadı');
      }

      final ticketId = widget.ticketResponse.data.tickets.first.ticketId;
      final response = await http.post(
        Uri.parse('http://192.168.8.113:8000/api/sales'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Token'ı ekle
        },
        body: jsonEncode({
          'ticket_id': ticketId,
          'customer_name': _customerName,
          'customer_email': _customerEmail?.isNotEmpty == true ? _customerEmail : null,
          'customer_phone': _customerPhone?.isNotEmpty == true ? _customerPhone : null,
          'payment_method': _paymentMethod,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ödeme başarıyla tamamlandı')),
        );
        Navigator.pushReplacementNamed(context, '/cinema_main');
      } else {
        throw Exception('Ödeme hatası: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          "Ödeme Onayı",
          style: AppTextStyles.headerMedium,
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Appcolor.buttonColor))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bilet Detayları',
                        style: AppTextStyles.headerSmall.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Film: ${widget.ticketResponse.data.movieTitle}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'Salon: ${widget.ticketResponse.data.hallName}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'Başlangıç Saati: ${widget.ticketResponse.data.startTime}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'Toplam Tutar: ${widget.ticketResponse.data.totalAmount}₺',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Müşteri Bilgileri',
                        style: AppTextStyles.headerSmall.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Müşteri Adı',
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Appcolor.buttonColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Müşteri adı gereklidir';
                          }
                          return null;
                        },
                        onSaved: (value) => _customerName = value!,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'E-posta (Opsiyonel)',
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Appcolor.buttonColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onSaved: (value) => _customerEmail = value,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Telefon (Opsiyonel)',
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Appcolor.buttonColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onSaved: (value) => _customerPhone = value,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Ödeme Yöntemi',
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Appcolor.buttonColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        value: _paymentMethod,
                        style: const TextStyle(color: Colors.white),
                        dropdownColor: Appcolor.appBackgroundColor,
                        items: ['credit_card', 'cash'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value == 'credit_card' ? 'Kredi Kartı' : 'Nakit',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _paymentMethod = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolor.buttonColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white),
                                )
                              : const Text(
                                  'Ödemeyi Onayla',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}