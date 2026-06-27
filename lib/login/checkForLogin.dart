import 'package:flutter/material.dart';
import 'package:flutter_application_1/login/ScreenPhoneInput.dart';
import 'package:flutter_application_1/serverAndStorage/serverConnection.dart';
import 'package:flutter_application_1/serverAndStorage/widgets/SyncLoadingView.dart';

class CheckForLogin extends StatefulWidget {
  const CheckForLogin({super.key});

  @override
  State<CheckForLogin> createState() => _CheckForLoginState();
}

class _CheckForLoginState extends State<CheckForLogin> {
  final ServerAndStorage _storage = ServerAndStorage();
  late final Future<bool> _loginCheckFuture;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _loginCheckFuture = _storage.checkForLogin();
  }

  void _navigateTo(Widget screen) {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void _retry() {
    setState(() {
      _navigated = false;
      _loginCheckFuture = _storage.checkForLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loginCheckFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SyncLoadingView();
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('خطا در بررسی وضعیت ورود'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _retry,
                    child: const Text('تلاش مجدد'),
                  ),
                ],
              ),
            ),
          );
        }

        final hasAppData = snapshot.data ?? false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateTo(
            hasAppData
                ? const ServerconnectionStart()
                : const PhoneInputScreen(),
          );
        });

        return const SyncLoadingView(
          title: 'Starting app...',
          subtitle: 'Checking login status',
        );
      },
    );
  }
}
