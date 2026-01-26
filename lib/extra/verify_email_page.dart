import 'package:flutter/material.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Warning Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.warning_amber_rounded,
                        color: Color(0xFF856404)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "You cannot proceed until verified.",
                        style: TextStyle(
                          color: Color(0xFF856404),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Email Icon
              Center(
                child: Container(
                  height: 90,
                  width: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEDE7FF),
                  ),
                  child: const Icon(
                    Icons.email_outlined,
                    size: 40,
                      color:  Color.fromARGB(255, 45, 19, 131),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Title
              const Text(
                "Verify your university\nemail to continue",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Description
              const Text(
                "We've sent a verification link to your university email address. "
                "Please check your inbox and click the link to activate your account.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 40),

              // Send Verification Button
                   SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:   Color.fromARGB(255, 45, 19, 131),
                    ),
                    child: const Text(
                      "Send Verification Email",
                      style: TextStyle(fontSize: 16, color:  Color.fromARGB(255, 255, 255, 255),),
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // I have verified button
                  SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:   Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: const Text(
                      "I have verified",
                      style: TextStyle(fontSize: 16, color:  Color.fromARGB(255, 0, 0, 0),),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Change Email
                   Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Wrong email? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          // future: go to login page
                        },
                        child: const Text(
                          "Change address",
                          style: TextStyle(
                            color:  Color.fromARGB(255, 45, 19, 131),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
