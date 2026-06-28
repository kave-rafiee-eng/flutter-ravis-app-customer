import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/login/ScreenVerificationCode.dart';
import 'package:flutter_application_1/serverAndStorage/serverConnection.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

const _logoAsset = 'assets/images/ic_launcher-web.png';

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
        content: Text(message, textDirection: TextDirection.rtl),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        _showError(_extractErrorMessage(response));
        return;
      }

      final res = jsonDecode(response.body) as Map<String, dynamic>;

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
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              scheme.primary.withValues(alpha: isDark ? 0.25 : 0.12),
              scheme.surface,
              scheme.secondary.withValues(alpha: isDark ? 0.12 : 0.06),
            ],
            stops: const [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LogoHeader(scheme: scheme),
                      const SizedBox(height: 32),
                      Card(
                        elevation: 0,
                        color: scheme.surfaceContainerLow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: scheme.outlineVariant.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'ورود با شماره موبایل',
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'شماره تلفن خود را وارد کنید تا کد تأیید برایتان ارسال شود',
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 28),
                              Theme(
                                data: theme.copyWith(
                                  canvasColor: scheme.surfaceContainerHighest,
                                ),
                                child: InternationalPhoneNumberInput(
                                  onInputChanged: (value) {
                                    setState(() => _phoneNumber = value);
                                  },
                                  onInputValidated: (isValid) {
                                    setState(() => _isPhoneValid = isValid);
                                  },
                                  selectorConfig: const SelectorConfig(
                                    selectorType:
                                        PhoneInputSelectorType.BOTTOM_SHEET,
                                    showFlags: false,
                                    useEmoji: true,
                                  ),
                                  ignoreBlank: false,
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  selectorTextStyle: TextStyle(
                                    color: scheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  initialValue: _phoneNumber,
                                  textFieldController: _phoneController,
                                  formatInput: true,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        signed: false,
                                        decimal: false,
                                      ),
                                  inputDecoration: InputDecoration(
                                    labelText: 'شماره موبایل',
                                    labelStyle: TextStyle(
                                      color: scheme.onSurfaceVariant,
                                    ),
                                    filled: true,
                                    fillColor: scheme.surfaceContainerHighest,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: scheme.outlineVariant,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: scheme.outlineVariant,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: scheme.primary,
                                        width: 1.5,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  countries: const ['IR', 'US', 'CA'],
                                ),
                              ),
                              const SizedBox(height: 24),
                              FilledButton(
                                onPressed: _isLoading
                                    ? null
                                    : _requestVerificationCode,
                                style: FilledButton.styleFrom(
                                  backgroundColor: scheme.primary,
                                  foregroundColor: scheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: scheme.onPrimary,
                                        ),
                                      )
                                    : const Text(
                                        'دریافت کد تأیید',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Ravis Customers App',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoHeader extends StatelessWidget {
  final ColorScheme scheme;

  const _LogoHeader({required this.scheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              _logoAsset,
              width: 88,
              height: 88,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.elevator_rounded, size: 64, color: scheme.primary),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'راویس',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.primary,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
