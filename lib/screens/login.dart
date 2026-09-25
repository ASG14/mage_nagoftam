import 'package:flutter/material.dart';

import 'package:mage_nagoftam/core/app_routes.dart';
import 'package:mage_nagoftam/services/auth_service.dart';
import 'package:mage_nagoftam/style/color.dart';

class Login extends StatefulWidget {
  final String? redirectRoute;

  const Login({
    super.key,
    this.redirectRoute,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController =
      TextEditingController();

  final TextEditingController _codeController =
      TextEditingController();

  bool _isCodeSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'شماره موبایل را وارد کنید';
    }

    if (!RegExp(r'^09\d{9}$').hasMatch(phone)) {
      return 'شماره موبایل معتبر نیست';
    }

    return null;
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.sendOtp(
        phone: _phoneController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isCodeSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'کد تأیید برای شما ارسال شد',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _verifyCode() async {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'کد تأیید را وارد کنید',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.verifyOtp(
        phone: _phoneController.text.trim(),
        code: code,
      );

      if (!mounted) {
        return;
      }

      if (result.isNewUser) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.register,
          arguments: widget.redirectRoute,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          widget.redirectRoute ?? AppRoutes.groups,
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _changePhone() {
    setState(() {
      _isCodeSent = false;
      _codeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('ورود'),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(
                maxWidth: 600,
                minWidth: 200,
              ),
              decoration: BoxDecoration(
                color: AppColors.white1,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 0.5,
                  color: AppColors.gray4,
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _isCodeSent
                          ? 'کد تأیید را وارد کنید'
                          : 'شماره موبایل خود را وارد کنید',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    if (!_isCodeSent) ...[
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.center,
                        maxLength: 11,
                        decoration: const InputDecoration(
                          hintText: 'شماره موبایل',
                          counterText: '',
                          suffixIcon: Icon(
                            Icons.phone_android_rounded,
                          ),
                        ),
                        validator: _validatePhone,
                      ),

                      const SizedBox(height: 40),

                      FilledButton(
                        onPressed:
                            _isLoading ? null : _sendCode,
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('دریافت کد تأیید'),
                      ),
                    ] else ...[
                      TextFormField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 6,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'کد تأیید',
                          counterText: '',
                          suffixIcon: Icon(
                            Icons.sms_rounded,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      FilledButton(
                        onPressed:
                            _isLoading ? null : _verifyCode,
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('تأیید و ورود'),
                      ),

                      const SizedBox(height: 8),

                      TextButton(
                        onPressed:
                            _isLoading ? null : _changePhone,
                        child: const Text(
                          'تغییر شماره موبایل',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}