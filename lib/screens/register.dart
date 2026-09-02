import 'package:begir/core/app_routes.dart';
import 'package:begir/services/auth_service.dart';
import 'package:begir/style/color.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AuthService.register(
        phone: _phoneController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.home,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ثبت نام انجام نشد'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ارتباط با سرور برقرار نشد'),
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

  String? _required(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ثبت نام'),
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

                    TextFormField(
                      controller: _firstNameController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'نام',
                      ),
                      validator: (value) =>
                          _required(value, 'نام را وارد کنید'),
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _lastNameController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'نام خانوادگی',
                      ),
                      validator: (value) =>
                          _required(
                            value,
                            'نام خانوادگی را وارد کنید',
                          ),
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'شماره موبایل',
                      ),
                      validator: (value) {
                        if (value == null ||
                            !RegExp(
                              r'^09\d{9}$',
                            ).hasMatch(value.trim())) {
                          return 'شماره موبایل معتبر وارد کنید';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _usernameController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'نام کاربری',
                      ),
                      validator: (value) {
                        if (value == null ||
                            !RegExp(
                              r'^[a-zA-Z0-9_]{3,50}$',
                            ).hasMatch(value.trim())) {
                          return 'نام کاربری معتبر وارد کنید';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'کلمه عبور',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.length < 6) {
                          return 'کلمه عبور حداقل ۶ کاراکتر باشد';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    FilledButton(
                      onPressed:
                          _isLoading ? null : _register,
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('ثبت نام'),
                    ),

                    const SizedBox(height: 8),

                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: const Text(
                        'قبلاً حساب دارید؟ ورود',
                      ),
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