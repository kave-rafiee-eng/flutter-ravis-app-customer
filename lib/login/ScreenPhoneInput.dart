import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/login/ScreenVerificationCode.dart';
import 'package:flutter_application_1/serverAndStorage/serverConnection.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'IR');
  bool _isLoading = false;
  bool _isPhoneValid = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _requestVerificationCode() async {
    if (_formKey.currentState?.validate() != true) return;

    final phone = _phoneNumber.phoneNumber;
    if (phone == null || phone.isEmpty) {
      _showError('شماره تلفن معتبر نیست');
      return;
    }

    if (!_isPhoneValid) {
      _showError('لطفاً یک شماره تلفن معتبر وارد کنید');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http
          .post(
            Uri.parse('$serverBaseUrl/verification'),
            body: {'phone': phone},
          )
          .timeout(const Duration(seconds: 20));

      if (!mounted) return;

      if (response.statusCode != 201) {
        final message = _extractErrorMessage(response);
        _showError(message);
        return;
      }

      Map<String, dynamic> res = jsonDecode(response.body);

      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              VerificationCodeScreen(phone: phone, code: res['code']),
        ),
      );
    } on FormatException {
      _showError('پاسخ سرور نامعتبر است');
    } catch (_) {
      _showError('خطا در اتصال به سرور');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _extractErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
    } catch (_) {}

    return 'خطای HTTP ${response.statusCode}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Theme(
              data: theme.copyWith(canvasColor: theme.colorScheme.surface),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Text(
                    'ورود با شماره موبایل',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'شماره تلفن خود را وارد کنید تا کد تأیید برایتان ارسال شود',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  InternationalPhoneNumberInput(
                    onInputChanged: (value) {
                      setState(() => _phoneNumber = value);
                    },
                    onInputValidated: (isValid) {
                      setState(() => _isPhoneValid = isValid);
                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DIALOG,
                      showFlags: false,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    selectorTextStyle: TextStyle(
                      color: theme.colorScheme.onSurface,
                    ),
                    initialValue: _phoneNumber,
                    textFieldController: _phoneController,
                    formatInput: true,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                    inputDecoration: const InputDecoration(
                      labelText: 'شماره موبایل',
                      border: OutlineInputBorder(),
                    ),
                    countries: const ['IR', 'US', 'CA'],
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _isLoading ? null : _requestVerificationCode,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : const Text('دریافت کد تأیید'),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
