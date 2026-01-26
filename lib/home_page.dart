// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   TextEditingController searchController = TextEditingController();
  

//   // ORIGINAL DATA
//   List<Map<String, String>> helpers = [
//     {"name": "Alex C.", "skill": "Python", "sessions": "42", "rating": "4.9"},
//     {"name": "Sarah J.", "skill": "DSA", "sessions": "35", "rating": "4.8"},
//     {"name": "Mike T.", "skill": "DBMS", "sessions": "28", "rating": "4.7"},
//     {"name": "Emily R.", "skill": "OS Design", "sessions": "20", "rating": "4.6"},
//     {"name": "John D.", "skill": "ReactJS", "sessions": "30", "rating": "4.8"},
//   ];

//   // SEARCH RESULT
//   List<Map<String, String>> filteredHelpers = [];

//   @override
//   void initState() {
//     super.initState();
//     filteredHelpers = helpers; // start with all data
//   }

//   void searchHelper(String query) {
//     final result = helpers.where((helper) {
//       final skill = helper['skill']!.toLowerCase();
//       final name = helper['name']!.toLowerCase();
//       return skill.contains(query.toLowerCase()) ||
//           name.contains(query.toLowerCase());
//     }).toList();

//     setState(() {
//       filteredHelpers = result;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF6F8FB),

//       // ================= APP BAR =================
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           "SkillSwap",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: Stack(
//               children: [
//                 const Icon(Icons.notifications_none, color: Colors.black),
//                 Positioned(
//                   right: 0,
//                   top: 0,
//                   child: Container(
//                     height: 8,
//                     width: 8,
//                     decoration: const BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),

//       // ================= BODY =================
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             // ================= SEARCH BAR =================
//             TextField(
//               controller: searchController,
//               onChanged: searchHelper,
//               decoration: InputDecoration(
//                 hintText: 'Search Python, DSA, DBMS...',
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.grey.shade100,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 25),

//             // ================= TOP HELPERS =================
//             const Text(
//               "Top Helpers",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 15),

//             SizedBox(
//               height: 260,
//               child: filteredHelpers.isEmpty
//                   ? const Center(child: Text("No result found"))
//                   : ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: filteredHelpers.length,
//                       itemBuilder: (context, index) {
//                         final helper = filteredHelpers[index];
//                         return helperCard(
//                           name: helper['name']!,
//                           skill: helper['skill']!,
//                           sessions: helper['sessions']!,
//                           rating: helper['rating']!,
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

  

//   // ================= HELPER CARD =================
//   Widget helperCard({
//     required String name,
//     required String skill,
//     required String sessions,
//     required String rating,
//   }) {
//     return Container(
//       width: 180,
//       margin: const EdgeInsets.only(right: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           const CircleAvatar(radius: 35),
//           const SizedBox(height: 10),
//           Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
//           Text(skill, style: const TextStyle(color: Colors.grey)),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Column(
//                 children: [
//                   const Text("Skill"),
//                   Text(skill, style: const TextStyle(color: Colors.blue)),
//                 ],
//               ),
//               Column(
//                 children: [
//                   const Text("Sessions"),
//                   Text(sessions),
//                 ],
//               ),
//             ],
//           ),
//           const Spacer(),
//           ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.grey.shade200,
//               elevation: 0,
//             ),
//             child: const Text("Request", style: TextStyle(color: Colors.black)),
//           )
//         ],
//       ),
      
//     );
    
//   }
// }































// // class HomePage extends StatelessWidget {
// //   const HomePage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xffF6F8FB),

// //       // ================= APP BAR =================
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         title: const Text(
// //           "SkillSwap",
// //           style: TextStyle(
// //             color: Colors.black,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         actions: [
// //           Padding(
// //             padding: const EdgeInsets.only(right: 16),
// //             child: Stack(
// //               children: [
// //                 const Icon(Icons.notifications_none, color: Colors.black),
// //                 Positioned(
// //                   right: 0,
// //                   top: 0,
// //                   child: Container(
// //                     height: 8,
// //                     width: 8,
// //                     decoration: const BoxDecoration(
// //                       color: Colors.red,
// //                       shape: BoxShape.circle,
// //                     ),
// //                   ),
// //                 )
// //               ],
// //             ),
// //           )
// //         ],
// //       ),

// //       // ================= BODY =================
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [

// //             // ================= SEARCH BAR =================
// //          TextField(
// //                 decoration: InputDecoration(
// //                   hintText: 'Search Python, DSA, DBMS...',
// //                   prefixIcon: const Icon(Icons.search),
// //                   filled: true,
// //                   fillColor: Colors.grey.shade100,
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                     borderSide: BorderSide.none,
// //                   ),
// //                 ),
// //               ),

// //             const SizedBox(height: 20),

// //             // ================= SKILL CHIPS =================
// //             SizedBox(
// //               height: 40,
// //               child: ListView(
// //                 scrollDirection: Axis.horizontal,
// //                 children: [
// //                   skillChip("All", true),
// //                   skillChip("Python", false),
// //                   skillChip("DSA", false),
// //                   skillChip("DBMS", false),
// //                 ],
// //               ),
// //             ),

// //             const SizedBox(height: 25),

// //             // ================= TOP HELPERS =================
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: const [
// //                 Text(
// //                   "Top Helpers",
// //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                 ),
// //                 Text(
// //                   "View all",
// //                   style: TextStyle(color: Colors.blue),
// //                 ),
// //               ],
// //             ),

// //             const SizedBox(height: 15),

// //             SizedBox(
// //               height: 260,
// //               child: ListView(
// //                 scrollDirection: Axis.horizontal,
// //                 children: [
// //                   helperCard(
// //                     name: "Alex C.",
// //                     skill: "Python",
// //                     sessions: "42",
// //                     rating: "4.9",
// //                   ),
// //                   helperCard(
// //                     name: "Sarah J.",
// //                     skill: "DSA",
// //                     sessions: "35",
// //                     rating: "4.8",
// //                   ),
// //                     helperCard(
// //                     name: "Sarah J.",
// //                     skill: "DSA",
// //                     sessions: "35",
// //                     rating: "4.8",
// //                   ),
// //                     helperCard(
// //                     name: "Sarah J.",
// //                     skill: "DSA",
// //                     sessions: "35",
// //                     rating: "4.8",
// //                   ),
// //                     helperCard(
// //                     name: "Sarah J.",
// //                     skill: "DSA",
// //                     sessions: "35",
// //                     rating: "4.8",
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             const SizedBox(height: 20),

// //             // ================= RECENTLY ACTIVE =================
// //             const Text(
// //               "Recently Active",
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),

// //             const SizedBox(height: 10),

// //             recentTile("Mike T.", "DBMS", "Online", true),
// //             recentTile("Emily R.", "OS Design", "5m ago", false),
// //             recentTile("John D.", "ReactJS", "15m ago", false),
// //           ],
// //         ),
// //       ),

// //       // ================= BOTTOM NAV =================
// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: 0,
// //         selectedItemColor: Colors.blue,
// //         unselectedItemColor: Colors.grey,
// //         items: const [
// //           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
// //           BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Requests"),
// //           BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Chats"),
// //           BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
// //         ],
// //       ),
// //     );
// //   }

// //   // ================= WIDGETS =================

// //   static Widget skillChip(String text, bool selected) {
// //     return Container(
// //       margin: const EdgeInsets.only(right: 10),
// //       padding: const EdgeInsets.symmetric(horizontal: 20),
// //       alignment: Alignment.center,
// //       decoration: BoxDecoration(
// //         color: selected ? Colors.blue : Colors.white,
// //         borderRadius: BorderRadius.circular(30),
// //       ),
// //       child: Text(
// //         text,
// //         style: TextStyle(
// //           color: selected ? Colors.white : Colors.black,
// //         ),
// //       ),
// //     );
// //   }

// //   static Widget helperCard({
// //     required String name,
// //     required String skill,
// //     required String sessions,
// //     required String rating,
// //   }) {
// //     return Container(
// //       width: 180,
// //       margin: const EdgeInsets.only(right: 16),
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //       ),
// //       child: Column(
// //         children: [
// //           CircleAvatar(radius: 35),
// //           const SizedBox(height: 10),
// //           Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
// //           Text(skill, style: const TextStyle(color: Colors.grey)),
// //           const SizedBox(height: 10),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceAround,
// //             children: [
// //               Column(
// //                 children: [
// //                   const Text("Skill"),
// //                   Text(skill, style: const TextStyle(color: Colors.blue)),
// //                 ],
// //               ),
// //               Column(
// //                 children: [
// //                   const Text("Sessions"),
// //                   Text(sessions),
// //                 ],
// //               ),
// //             ],
// //           ),
// //           const Spacer(),
// //           ElevatedButton(
// //             onPressed: () {},
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.grey.shade200,
// //               elevation: 0,
// //             ),
// //             child: const Text("Request", style: TextStyle(color: Colors.black)),
// //           )
// //         ],
// //       ),
// //     );
// //   }

// //   static Widget recentTile(String name, String skill, String time, bool online) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 10),
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Row(
// //         children: [
// //           Stack(
// //             children: [
// //               const CircleAvatar(radius: 22),
// //               if (online)
// //                 const Positioned(
// //                   right: 0,
// //                   bottom: 0,
// //                   child: CircleAvatar(
// //                     radius: 5,
// //                     backgroundColor: Colors.green,
// //                   ),
// //                 ),
// //             ],
// //           ),
// //           const SizedBox(width: 10),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
// //                 Text("Helping with $skill"),
// //               ],
// //             ),
// //           ),
// //           Text(time, style: const TextStyle(color: Colors.grey)),
// //           const SizedBox(width: 10),
// //           ElevatedButton(
// //             onPressed: () {},
// //             child: const Text("REQUEST"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:my_app/auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(
                builder: (context) => LoginScreen()            //cheacking for logut
                ), (value) => false);
          }, 
          child: Text('Logout'),
          ),
      ),
    );
  }
}





