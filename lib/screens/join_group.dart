import 'package:flutter/material.dart';

import 'package:mage_nagoftam/core/app_routes.dart';
import 'package:mage_nagoftam/services/auth_service.dart';
import 'package:mage_nagoftam/services/group_service.dart';

class JoinGroupScreen extends StatefulWidget {
  final String token;

  const JoinGroupScreen({
    super.key,
    required this.token,
  });

  @override
  State<JoinGroupScreen> createState() =>
      _JoinGroupScreenState();
}

class _JoinGroupScreenState
    extends State<JoinGroupScreen> {
  bool _isJoining = false;

  String? _error;

  Future<void> _joinGroup() async {
    if (_isJoining) {
      return;
    }

    setState(() {
      _isJoining = true;
      _error = null;
    });

    try {
      final loggedIn =
          await AuthService.isLoggedIn();

      if (!mounted) {
        return;
      }

      if (!loggedIn) {
        Navigator.pushNamed(
          context,
          AppRoutes.login,
        );

        return;
      }

      final group =
          await GroupService.joinGroup(
        token: widget.token,
      );

      if (!mounted) {
        return;
      }

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
        arguments: group,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      final error = e.toString();

      String message;

      if (error.contains('invalid_invite_token')) {
        message =
            'لینک دعوت معتبر نیست';
      } else if (error.contains('Invite not found')) {
        message =
            'لینک دعوت پیدا نشد یا دیگر معتبر نیست';
      } else if (error.contains('unauthorized')) {
        message =
            'نشست شما منقضی شده است. دوباره وارد حساب شوید';
      } else if (error.contains('server_error')) {
        message =
            'خطایی در سرور رخ داده است';
      } else {
        message =
            'پیوستن به گروه انجام نشد';
      }

      setState(() {
        _isJoining = false;
        _error = message;
      });

      return;
    } finally {
      if (mounted && _isJoining) {
        setState(() {
          _isJoining = false;
        });
      }
    }
  }

  void _goToLogin() {
    Navigator.pushNamed(
      context,
      AppRoutes.login,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'پیوستن به گروه',
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 420,
            ),
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.group_add_outlined,
                      size: 64,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    const Text(
                      'دعوت به عضویت در گروه',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    const Text(
                      'شما با استفاده از این لینک به یک گروه دعوت شده‌اید.',
                      textAlign:
                          TextAlign.center,
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    if (_error != null) ...[
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(12),
                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(
                            5,
                          ),
                        ),
                        child: Text(
                          _error!,
                          textAlign:
                              TextAlign.center,
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),
                    ],

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed:
                            _isJoining
                                ? null
                                : _joinGroup,
                        child: _isJoining
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'پیوستن به گروه',
                              ),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    TextButton(
                      onPressed: _isJoining
                          ? null
                          : _goToLogin,
                      child: const Text(
                        'ورود به حساب کاربری',
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