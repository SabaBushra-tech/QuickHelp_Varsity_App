import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LearnerHomePage extends StatefulWidget {
  const LearnerHomePage({super.key});

  @override
  State<LearnerHomePage> createState() => _LearnerHomeState();
}

class _LearnerHomeState extends State<LearnerHomePage> {
  final supabase = Supabase.instance.client;

  // Data
  List<Map<String, dynamic>> helpers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchHelpers();
  }

  // ✅ Fetch from helpers table
  Future<void> fetchHelpers() async {
    setState(() => loading = true);

    try {
      final data = await supabase
          .from('helpers')
          .select('id, name, department, skill, rating, sessions, created_at')
          .order('created_at', ascending: false);

      debugPrint("FETCH HELPERS RESULT: $data");

      if (!mounted) return;

      setState(() {
        helpers = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      debugPrint("FETCH HELPERS ERROR: $e");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        title: const Text("SkillSwap"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: fetchHelpers,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),

      // ✅ Pull to refresh
      body: RefreshIndicator(
        onRefresh: fetchHelpers,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : helpers.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 80),
                      Center(
                        child: Text(
                          "No helpers found",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text(
                        "Top Helpers",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: helpers.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                        itemBuilder: (_, i) => helperCard(helpers[i]),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget helperCard(Map<String, dynamic> h) {
    final id = h['id'].toString();
    final name = (h['name'] ?? '').toString();
    final dept = (h['department'] ?? '').toString();
    final skill = (h['skill'] ?? '').toString();
    final rating = (h['rating'] ?? '').toString();
    final sessions = (h['sessions'] ?? '').toString();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(radius: 28, child: Icon(Icons.person)),
          const SizedBox(height: 6),

          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),

          Text(
            dept,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          Text(
            "Skill: $skill",
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          Text(
            "⭐ $rating • Sessions: $sessions",
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: () => sendRequest(helperId: id),
              child: const Text("Request"),
            ),
          ),
        ],
      ),
    );
  }
}
