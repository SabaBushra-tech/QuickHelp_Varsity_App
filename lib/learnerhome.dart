import 'package:flutter/material.dart';
import 'package:my_app/page/chats_page.dart';
import 'package:my_app/page/profile_page.dart';
import 'package:my_app/page/requests_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:my_app/helper_details_page.dart';


class LearnerHomePage extends StatefulWidget {
  const LearnerHomePage({super.key});

  @override
  State<LearnerHomePage> createState() => _LearnerHomePageState();
}

class _LearnerHomePageState extends State<LearnerHomePage> {
  final supabase = Supabase.instance.client;

  int currentIndex = 0;

  final TextEditingController _searchCtrl = TextEditingController();
  String selectedChip = "All";

  bool loading = true;
  List<Map<String, dynamic>> helpers = [];

  @override
  void initState() {
    super.initState();
    fetchHelpers();
    _searchCtrl.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ✅ Fetch helpers from helpers table
  Future<void> fetchHelpers() async {
    setState(() => loading = true);
    try {
      final data = await supabase
          .from('helpers')
          .select('id, name, department, skill, rating, sessions, created_at')
          .order('created_at', ascending: false);

      if (!mounted) return;
      setState(() {
        helpers = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fetch error: $e")),
      );
    }
  }

  // ✅ Send request into requests table
  Future<void> sendRequest({required String helperId}) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      return;
    }

    try {
      final existing = await supabase
          .from('requests')
          .select('id')
          .eq('learner_id', user.id)
          .eq('helper_id', helperId)
          .eq('status', 'pending')
          .maybeSingle();

      if (existing != null) {
        if (!mounted) return;
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

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request sent ✅")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request failed: $e")),
      );
    }
  }

  // ✅ Skill → Color map (add more if you need)
  Color _skillColor(String skill) {
    final s = skill.trim().toLowerCase();
    if (s.contains("python")) return const Color(0xFF2563EB);
    if (s.contains("dsa")) return const Color(0xFF7E57C2);
    if (s.contains("dbms")) return const Color(0xFFFF7043);
    if (s.contains("java") && !s.contains("javascript")) return const Color(0xFF10B981);
    if (s.contains("javascript")) return const Color(0xFFF59E0B);
    if (s.contains("flutter")) return const Color(0xFF0EA5E9);
    if (s.contains("c++") || s.contains("cpp")) return const Color(0xFF111827);
    return const Color(0xFF64748B); // default grey-blue
  }

  List<Map<String, dynamic>> get filteredHelpers {
    final q = _searchCtrl.text.trim().toLowerCase();

    return helpers.where((h) {
      final name = (h['name'] ?? '').toString().toLowerCase();
      final dept = (h['department'] ?? '').toString().toLowerCase();
      final skill = (h['skill'] ?? '').toString().toLowerCase();

      final matchSearch =
          q.isEmpty || name.contains(q) || dept.contains(q) || skill.contains(q);

      final matchChip = selectedChip == "All" ||
          skill == selectedChip.toLowerCase() ||
          skill.contains(selectedChip.toLowerCase());

      return matchSearch && matchChip;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: IndexedStack(
        index: currentIndex,
        children: [
          _homeScreen(),
          const RequestsPage(),
          const ChatsPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 18, color: Color(0x14000000))],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => setState(() => currentIndex = i),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2563EB),
          unselectedItemColor: const Color(0xFF94A3B8),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Requests"),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Chats"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _homeScreen() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: fetchHelpers,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          children: [
            _header(),
            const SizedBox(height: 16),
            _searchBar(),
            const SizedBox(height: 14),
            _chipRow(),
            const SizedBox(height: 22),
            _sectionTitle("Top Helpers", actionText: "Refresh", onTap: fetchHelpers),
            const SizedBox(height: 12),

            if (loading)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              _topHelpersList(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Text(
          "SkillSwap",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        Stack(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, size: 28),
            ),
            Positioned(
              right: 10,
              top: 12,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(blurRadius: 14, color: Color(0x11000000)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: "Search Python, DSA, DBMS...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipRow() {
    final chips = const [
      _ChipItem("All", null),
      _ChipItem("Python", Color(0xFFF6D365)),
      _ChipItem("DSA", Color(0xFF7E57C2)),
      _ChipItem("DBMS", Color(0xFFFF7043)),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final item = chips[i];
          final selected = item.label == selectedChip;

          return InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => setState(() => selectedChip = item.label),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF2563EB) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE6EAF0)),
                boxShadow: selected
                    ? const [BoxShadow(blurRadius: 14, color: Color(0x22000000))]
                    : null,
              ),
              child: Row(
                children: [
                  if (!selected && item.dotColor != null) ...[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: item.dotColor!,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    item.label,
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF111827),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(
    String title, {
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              color: Color(0xFF2563EB),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _topHelpersList() {
    final list = filteredHelpers;

    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            "No helpers found",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return SizedBox(
      height: 330,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) => _helperCard(list[i]),
      ),
    );
  }

  Widget _helperCard(Map<String, dynamic> h) {
    final helperId = h['id'].toString();
    final name = (h['name'] ?? '').toString();
    final subtitle = (h['department'] ?? '').toString();
    final skill = (h['skill'] ?? '').toString();
    final sessions = int.tryParse((h['sessions'] ?? '0').toString()) ?? 0;
    final rating = double.tryParse((h['rating'] ?? '0').toString()) ?? 0;

    final skillClr = _skillColor(skill);

    return Container(
      width: 230,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6EAF0)),
        boxShadow: const [BoxShadow(blurRadius: 18, color: Color(0x14000000))],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4D6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.orange),
                  const SizedBox(width: 6),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF60A5FA)],
              ),
            ),
            child: const CircleAvatar(
              radius: 34,
              backgroundColor: Color(0xFFEFF6FF),
              child: Icon(Icons.person, size: 34, color: Color(0xFF2563EB)),
            ),
          ),

          const SizedBox(height: 10),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(child: _miniStatSkill("SKILL", skill, skillClr)),
              const SizedBox(width: 10),
              Expanded(child: _miniStat("SESSIONS", "$sessions")),
            ],
          ),

          const Spacer(),

          // ✅ Colored Request button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () => sendRequest(helperId: helperId),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB), // button color depends on skill
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Request",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Skill box with colored chip style
  Widget _miniStatSkill(String title, String value, Color skillColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: skillColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: skillColor.withOpacity(0.35)),
            ),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: skillColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipItem {
  final String label;
  final Color? dotColor;
  const _ChipItem(this.label, this.dotColor);
}
