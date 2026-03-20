import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:volcan_pay/features/auth/presentation/providers/auth_provider.dart';

class OtpVerificationPage extends HookConsumerWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpController = useTextEditingController();
    final focusNode = useFocusNode();

    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
        otpController.clear();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Verificación de OTP')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text('Ingresa el codigo OTP enviado a:'),
              Text(email, style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),

              Pinput(
                length: 8,
                controller: otpController,
                focusNode: focusNode,
                defaultPinTheme: PinTheme(
                  width: 42,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onCompleted: (pin) {
                  ref
                      .read(authControllerProvider.notifier)
                      .verifyEmailOTP(email, pin);
                },
              ),

              if (authState.isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () => ref
                      .read(authControllerProvider.notifier)
                      .verifyEmailOTP(email, otpController.text),
                  child: const Text('Verificar'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
