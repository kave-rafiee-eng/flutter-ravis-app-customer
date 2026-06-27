import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/login/login_api.dart';
import 'package:flutter_application_1/serverAndStorage/serverConnection.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String phone;
  final int code; //for test

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
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
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

      // await _storage.saveUserIdAfterLogin(userId);

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

    return Scaffold(
      appBar: AppBar(title: const Text('Verification Code')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.code.toString()),
                const Spacer(),
                Text(
                  'کد تأیید',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'کد ارسال‌شده به ${widget.phone} را وارد کنید',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: 'کد تأیید',
                    border: OutlineInputBorder(),
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
                      : const Text('تأیید'),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
