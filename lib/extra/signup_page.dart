import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 30),

                // Logo + title
                Center(
                  child: Column(
                    children: const [
                      Icon(Icons.school, size: 50,  color:  Color.fromARGB(255, 45, 19, 131),),
                      SizedBox(height: 12),
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Exchange skills with students on campus.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Full Name
                const Text(
                  "Full Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Jane Doe",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.person),
                  ),
                ),

                const SizedBox(height: 20),

                // University Email
                const Text(
                  "University Email",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextField(
                  decoration: const InputDecoration(
                    hintText: "jane@university.edu",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.email),
                  ),
                ),

                const SizedBox(height: 20),

                // Password
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextField(
                  obscureText: !hidePassword,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Create Account button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:   Color.fromARGB(255, 45, 19, 131),
                    ),
                    child: const Text(
                      "Create Account",
                      style: TextStyle(fontSize: 16, color:  Color.fromARGB(255, 255, 255, 255),),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Already have account
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          // future: go to login page
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                            color:  Color.fromARGB(255, 45, 19, 131),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
