import 'package:flutter/material.dart';

import 'package:mage_nagoftam/core/app_routes.dart';
import 'package:mage_nagoftam/services/auth_service.dart';
import 'package:mage_nagoftam/style/color.dart';

class Register extends StatefulWidget {
  final String? redirectRoute;

  const Register({
    super.key,
    this.redirectRoute,
  });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();

    super.dispose();
  }

  String? _required(
    String? value,
    String message,
  ) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  }

  Future<void> _completeProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(
        context,
        widget.redirectRoute ?? AppRoutes.groups,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('تکمیل اطلاعات'),
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
                    const Text(
                      'برای تکمیل حساب کاربری، نام و نام خانوادگی خود را وارد کنید.',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    TextFormField(
                      controller: _firstNameController,
                      textAlign: TextAlign.center,
                      textInputAction:
                          TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'نام',
                      ),
                      validator: (value) => _required(
                        value,
                        'نام را وارد کنید',
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _lastNameController,
                      textAlign: TextAlign.center,
                      textInputAction:
                          TextInputAction.done,
                      decoration: const InputDecoration(
                        hintText: 'نام خانوادگی',
                      ),
                      validator: (value) => _required(
                        value,
                        'نام خانوادگی را وارد کنید',
                      ),
                      onFieldSubmitted: (_) {
                        if (!_isLoading) {
                          _completeProfile();
                        }
                      },
                    ),

                    const SizedBox(height: 40),

                    FilledButton(
                      onPressed: _isLoading
                          ? null
                          : _completeProfile,
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'تکمیل اطلاعات',
                            ),
                    ),

                    const SizedBox(height: 8),

                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: const Text('بازگشت'),
                    ),
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

