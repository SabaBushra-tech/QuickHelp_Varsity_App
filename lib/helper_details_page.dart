import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HelperDetailsPage extends StatelessWidget {
  final Map<String, dynamic> helper;
  const HelperDetailsPage({super.key, required this.helper});

  Color _skillColor(String skill) {
    final s = skill.trim().toLowerCase();
    if (s.contains("python")) return const Color(0xFF2563EB);
    if (s.contains("dsa")) return const Color(0xFF7E57C2);
    if (s.contains("dbms")) return const Color(0xFFFF7043);
    if (s.contains("java") && !s.contains("javascript")) return const Color(0xFF10B981);
    if (s.contains("javascript")) return const Color(0xFFF59E0B);
    if (s.contains("flutter")) return const Color(0xFF0EA5E9);
    if (s.contains("c++") || s.contains("cpp")) return const Color(0xFF111827);
    return const Color(0xFF64748B);
  }

  Future<void> _sendRequest(BuildContext context) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      return;
    }

    final helperId = helper['id'].toString();

    try {
      final existing = await supabase
          .from('requests')
          .select('id')
          .eq('learner_id', user.id)
          .eq('helper_id', helperId)
          .eq('status', 'pending')
          .maybeSingle();

      if (existing != null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Already requested (pending) ✅")),
        );
        return;
      }

      await supabase.from('requests').insert({
        'learner_id': user.id,
        'helper_id': helperId,
        'status': 'pending',
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request sent ✅")),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = (helper['name'] ?? '').toString();
    final dept = (helper['department'] ?? '').toString();
    final skill = (helper['skill'] ?? '').toString();
    final rating = double.tryParse((helper['rating'] ?? '0').toString()) ?? 0;
    final sessions = int.tryParse((helper['sessions'] ?? '0').toString()) ?? 0;

    final skillClr = _skillColor(skill);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Helper Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const CircleAvatar(
                radius: 54,
                backgroundColor: Color(0xFFEFF6FF),
                child: Icon(Icons.person, size: 54, color: Color(0xFF2563EB)),
              ),
              const SizedBox(height: 14),
              Text(
                name,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                dept,
                style: const TextStyle(fontSize: 16, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(child: _statCard("Rating", "${rating.toStringAsFixed(1)} ⭐")),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard("Sessions", "$sessions")),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard("Skill", skill, valueColor: skillClr)),
                ],
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Expertise",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _pill(skill, skillClr),
                  _pill("Problem Solving", const Color(0xFF2563EB)),
                  _pill("Concept Review", const Color(0xFF2563EB)),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _sendRequest(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB), // ✅ same blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                  ),
                  icon: const Icon(Icons.waving_hand_rounded, color: Colors.white),
                  label: const Text(
                    "Request Help",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, {Color valueColor = const Color(0xFF111827)}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF0)),
        color: Colors.white,
        boxShadow: const [BoxShadow(blurRadius: 16, color: Color(0x0F000000))],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: valueColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _pill(String text, Color clr) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EAF0)),
        color: Colors.white,
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w800, color: clr),
      ),
    );
  }
}
