import 'dart:convert';
import 'dart:io';
import 'package:cinema/core/services/auth/auth_service.dart';
import 'package:cinema/core/services/storage/storage_service.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/core/theme/text_style.dart';
import 'package:cinema/models/ticket_model.dart';
import 'package:cinema/pages/main/cinema_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final TicketCreationResponse ticketResponse;

  const PaymentConfirmationScreen({required this.ticketResponse, super.key});

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _customerPhone = '';
  String _paymentMethod = 'credit_card';
  bool _isLoading = false;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    final storageService = HiveStorageService();
    storageService.init();
    _authService = AuthService(storageService: storageService);
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      final result = await _performPayment();
      if (!mounted) return; 

      _showSnackBar(result['message'], isError: result['isError']);
      if (!result['isError']) {
        _navigateToMainScreen();
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Bilinmeyen hata oluştu: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<Map<String, dynamic>> _performPayment() async {
    final token = await _authService.getToken();
    if (token == null) {
      return {
        'isError': true,
        'message': 'Kimlik doğrulama hatası: Token bulunamadı',
      };
    }

    final ticketId = widget.ticketResponse.data.tickets.firstOrNull?.ticketId;
    if (ticketId == null) {
      return {
        'isError': true,
        'message': 'Bilet ID\'si bulunamadı',
      };
    }

    if (_customerPhone.isEmpty) {
      return {
        'isError': true,
        'message': 'Telefon numarası zorunludur',
      };
    }

    final body = {
      'ticket_id': ticketId,
      'customer_phone': _customerPhone,
      'payment_method': _paymentMethod,
    };

    final client = http.Client();
    try {
      final response = await retry(
        () => client.post(
          Uri.parse('http://10.10.27.21:8000/api/sales'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        ),
        retryIf: (e) => e is SocketException || e is HttpException,
        maxAttempts: 3,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'isError': false,
          'message': 'Ödeme başarıyla tamamlandı',
        };
      } else {
        return {
          'isError': true,
          'message': 'Ödeme hatası: ${response.statusCode} - ${response.body}',
        };
      }
    } on SocketException catch (e) {
      return {
        'isError': true,
        'message': 'Ağ bağlantı hatası: $e',
      };
    } on HttpException catch (e) {
      return {
        'isError': true,
        'message': 'HTTP hatası: $e',
      };
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void _navigateToMainScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CinemaMainScreen()),
    );
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
          ? const Center(
              child: CircularProgressIndicator(color: Appcolor.buttonColor),
            )
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
                        style: AppTextStyles.headerSmall
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Film: ${widget.ticketResponse.data.movieTitle}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'Salon: ${widget.ticketResponse.data.hallName}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'Başlangıç Saati: ${widget.ticketResponse.data.startTime}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'Toplam Tutar: ${widget.ticketResponse.data.totalAmount}₺',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Müşteri Bilgileri',
                        style: AppTextStyles.headerSmall
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: _buildInputDecoration(
                            labelText: 'Telefon Numarası (Zorunlu)'),
                        style: const TextStyle(color: Colors.white),
                        onSaved: (value) => _customerPhone = value ?? '',
                        validator: _validatePhoneNumber,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        decoration:
                            _buildInputDecoration(labelText: 'Ödeme Yöntemi'),
                        value: _paymentMethod,
                        style: const TextStyle(color: Colors.white),
                        dropdownColor: Appcolor.appBackgroundColor,
                        items: _buildPaymentMethodItems(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() => _paymentMethod = newValue);
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitPayment,
                          style: _buildButtonStyle(),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(color: Colors.white),
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

  InputDecoration _buildInputDecoration({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
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
      errorStyle: const TextStyle(color: Colors.red),
    );
  }

  List<DropdownMenuItem<String>> _buildPaymentMethodItems() {
    return ['credit_card', 'cash'].map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value == 'credit_card' ? 'Kredi Kartı' : 'Nakit',
          style: const TextStyle(color: Colors.white),
        ),
      );
    }).toList();
  }

  ButtonStyle _buildButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Appcolor.buttonColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefon numarası zorunludur';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Lütfen geçerli bir telefon numarası girin (sadece rakamlardan oluşmalı)';
    }
    return null;
  }
}