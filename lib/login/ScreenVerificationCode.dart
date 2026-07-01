import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/login/login_api.dart';
import 'package:flutter_application_1/serverAndStorage/serverConnection.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String phone;
  final int code; // for test

  const VerificationCodeScreen({
    super.key,
    required this.phone,
    required this.code,
  });

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _storage = ServerAndStorage();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
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

  Future<void> _verifyCode() async {
    if (_formKey.currentState?.validate() != true) return;

    final code = int.tryParse(_codeController.text.trim());
    if (code == null) {
      _showError('کد باید عددی باشد');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await LoginApi.verifyCode(phone: widget.phone, code: code);
      final user = await LoginApi.findOrCreateUser(widget.phone);
      final userId = user['id']?.toString();

      if (!mounted) return;

      if (userId == null || userId.isEmpty) {
        _showError('شناسه کاربر از سرور دریافت نشد');
        return;
      }

      await _storage.saveUserIdAfterLogin(userId);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ServerconnectionStart()),
      );
    } on LoginApiException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('خطا در اتصال به سرور');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // _VerificationHeader(scheme: scheme),
                      // const SizedBox(height: 28),
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
                                'کد تأیید',
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'کد ارسال‌شده را وارد کنید',
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: scheme.primaryContainer.withValues(
                                    alpha: 0.45,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.phone_android_rounded,
                                      size: 18,
                                      color: scheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.phone,
                                      textDirection: TextDirection.ltr,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: scheme.onSurface,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              // if (kDebugMode) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: scheme.tertiaryContainer.withValues(
                                    alpha: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: scheme.outlineVariant,
                                  ),
                                ),
                                child: Text(
                                  'کد تست: ${widget.code}',
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              // ],
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _codeController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 8,
                                ),
                                decoration: InputDecoration(
                                  hintText: '• • • • • •',
                                  hintStyle: TextStyle(
                                    color: scheme.onSurfaceVariant.withValues(
                                      alpha: 0.4,
                                    ),
                                    letterSpacing: 4,
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
                                    vertical: 18,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'کد را وارد کنید';
                                  }
                                  if (int.tryParse(value.trim()) == null) {
                                    return 'کد باید عددی باشد';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              FilledButton(
                                onPressed: _isLoading ? null : _verifyCode,
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
                                        'تأیید و ورود',
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

// class _VerificationHeader extends StatelessWidget {
//   final ColorScheme scheme;

//   const _VerificationHeader({required this.scheme});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Column(
//       children: [
//         Container(
//           width: 72,
//           height: 72,
//           decoration: BoxDecoration(
//             color: scheme.surface,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: scheme.primary.withValues(alpha: 0.15),
//                 blurRadius: 20,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//             border: Border.all(
//               color: scheme.outlineVariant.withValues(alpha: 0.4),
//             ),
//           ),
//           child: Icon(Icons.sms_outlined, size: 36, color: scheme.primary),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           'تأیید شماره موبایل',
//           textDirection: TextDirection.rtl,
//           style: theme.textTheme.titleMedium?.copyWith(
//             fontWeight: FontWeight.w700,
//             color: scheme.primary,
//           ),
//         ),
//       ],
//     );
//   }
// }
