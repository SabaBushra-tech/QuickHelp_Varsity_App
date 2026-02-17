import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HelperAdminHome extends StatefulWidget {
  const HelperAdminHome({super.key});

  @override
  State<HelperAdminHome> createState() => _HelperAdminHomePageState();
}

class _HelperAdminHomePageState extends State<HelperAdminHome> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Helper Admin Home")),
    );
  }
}
