import 'package:flutter/material.dart';
import 'package:my_app/helper/helper_details_page.dart';
import 'package:my_app/learner/notification_screen.dart';
import 'package:my_app/learner/profile/learner_profile_page.dart';
import 'package:my_app/screen/chats_screen.dart';
import 'package:my_app/screen/requests_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_app/helper/all_helper_view_page.dart';

class LearnerHome extends StatefulWidget {
  const LearnerHome({super.key});

  @override
  State<LearnerHome> createState() => _LearnerHomeState();
}

class _LearnerHomeState extends State<LearnerHome> {
  final supabase = Supabase.instance.client;

  int currentIndex = 0;

  List helpers = [];
  List allHelpers = [];

  String selectedFilter = "All";
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchHelpers();
  }

  Future<void> fetchHelpers() async {
    final data = await supabase
        .from('profiles')
        .select()
        .eq('role', 'helper')
        .eq('open_for_requests', true);

    if (!mounted) return;

    setState(() {
      allHelpers = data;
      helpers = data;
    });
  }

  void applyFilter() {
    List filtered = allHelpers;

    if (selectedFilter != "All") {
      filtered = filtered.where((h) {
        final skills = (h['skills'] as List?) ?? [];
        return skills.any(
          (s) => s.toString().toLowerCase() == selectedFilter.toLowerCase(),
        );
      }).toList();
    }

    if (searchController.text.isNotEmpty) {
      final query = searchController.text.toLowerCase();
      filtered = filtered.where((h) {
        final name = (h['full_name'] ?? '').toString().toLowerCase();
        final skills = (h['skills'] as List?) ?? [];
        final skillMatch = skills.any(
          (s) => s.toString().toLowerCase().contains(query),
        );
        return name.contains(query) || skillMatch;
      }).toList();
    }

    setState(() => helpers = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      body: IndexedStack(
        index: currentIndex,
        children: [
          homeScreen(),
          const RequestsPage(),
          const ChatsPage(),
          const Learner_Profile_Page(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: "Requests",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  // ================= HOME =================

  Widget homeScreen() {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          // APP BAR
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "SkillSwap",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationPage(),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // SEARCH
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: searchController,
                  onSubmitted: (value) {
                    final query = value.toLowerCase();

                    final filtered = allHelpers.where((h) {
                      final name =
                          (h['full_name'] ?? '').toString().toLowerCase();
                      final skills = (h['skills'] as List?) ?? [];

                      final skillMatch = skills.any(
                        (s) => s.toString().toLowerCase().contains(query),
                      );

                      return name.contains(query) || skillMatch;
                    }).toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AllHelpersPage(helpers: filtered),
                      ),
                    );
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    hintText: "Search Python, DSA, DBMS...",
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // FILTER CHIPS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    filterChip("All"),
                    filterChip("Python"),
                    filterChip("DSA"),
                    filterChip("DBMS"),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // TOP HELPERS TITLE
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Top Helpers",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllHelpersPage(helpers: helpers),
                        ),
                      );
                    },
                    child: const Text(
                      "View all",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // HORIZONTAL HELPERS
          SliverToBoxAdapter(
            child: SizedBox(
              height: 310,
              child: helpers.isEmpty
                  ? const Center(child: Text("No helpers found"))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
                      itemCount: helpers.length,
                      itemBuilder: (context, i) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: helperCard(helpers[i]),
                        );
                      },
                    ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // RECENTLY ACTIVE TITLE
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Recently Active",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // RECENTLY ACTIVE LIST
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  recentTile("Mike T.", "DBMS", true),
                  recentTile("Emily R.", "OS Design", false),
                  recentTile("John D.", "ReactJS", false),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= COMPONENTS =================

  Widget filterChip(String text) {
    final bool active = selectedFilter == text;

    return GestureDetector(
      onTap: () {
        setState(() => selectedFilter = text);
        applyFilter();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(color: active ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget helperCard(Map h) {
    final batch = h['batch']?.toString() ?? '';
    final skillsList = (h['skills'] as List?) ?? [];
    final skills = skillsList.isNotEmpty ? skillsList.join(", ") : "No skills";

    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HelperDetailsPage(helperId: h['id']),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.purple],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 26,
                            backgroundImage: (h['avatar_url'] != null &&
                                    h['avatar_url'].toString().isNotEmpty)
                                ? NetworkImage(h['avatar_url'])
                                : null,
                            child: (h['avatar_url'] == null ||
                                    h['avatar_url'].toString().isEmpty)
                                ? const Icon(Icons.person, size: 24)
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        h['full_name'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${h['department']} · Batch $batch",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          // ✅ MUST be 1 line so card height never grows
                          skills,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    debugPrint("Send request to helper ${h['id']}");
                  },
                  child: const Text(
                    "Request",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget recentTile(String name, String skill, bool online) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(radius: 22, child: Icon(Icons.person)),
              if (online)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  "Helping with $skill",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Request")),
        ],
      ),
    );
  }
}
