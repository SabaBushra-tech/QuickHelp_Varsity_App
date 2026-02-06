import 'package:flutter/material.dart';
import 'package:my_app/basic_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String fullName;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.fullName,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final supabase = Supabase.instance.client;
  bool loading = false;

  Future<void> checkVerification() async {
    setState(() => loading = true);

    try {
      await supabase.auth.refreshSession();
      final user = supabase.auth.currentUser;

      if (user != null && user.emailConfirmedAt != null) {
        // ✅ SAVE full_name into profiles table
        await supabase.from('profiles').upsert({
          'id': user.id,
          'full_name': widget.fullName.trim(),
          'updated_at': DateTime.now().toIso8601String(),
        }, onConflict: 'id');

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const BasicInfo()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email not verified yet")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> resendEmail() async {
    await supabase.auth.resend(type: OtpType.signup, email: widget.email);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Verification email sent")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),

            const Text(
              "Verify your university email to continue",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              "We’ve sent a verification link to\n${widget.email}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: resendEmail,
              child: const Text("Send Verification Email"),
            ),

            const SizedBox(height: 15),

            loading
                ? const CircularProgressIndicator()
                : OutlinedButton(
                    onPressed: checkVerification,
                    child: const Text("I have verified"),
                  ),
          ],
        ),
      ),
    );
  }
}
