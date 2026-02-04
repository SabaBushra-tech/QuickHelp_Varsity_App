import 'package:flutter/material.dart';
class ShowcaseSkills extends StatefulWidget {
  const ShowcaseSkills({super.key});

  @override
  State<ShowcaseSkills> createState() => _ShowcaseSkillsState();
}

class _ShowcaseSkillsState extends State<ShowcaseSkills> {
  final List<String> skills = [
    "Python",
    "Java",
    "C++",
    "DSA",
    "DBMS",
    "OS",
    "OOP",
    "Algorithms",
  ];

  final List<String> selectedSkills = [];
  bool helpOthers = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress Bar
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "STEP 2 OF 2",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 40,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 40,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Showcase your\nexpertise",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Select the skills you can share with peers to\nstart building your profile.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Search Bar
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Search skills (e.g. Python)...",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Skill Chips
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: skills.map((skill) {
                          final isSelected = selectedSkills.contains(skill);

                          return ChoiceChip(
                            label: Text(skill),
                            selected: isSelected,
                            selectedColor: Colors.deepPurple,
                            backgroundColor: Colors.grey.shade100,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            onSelected: (_) {
                              setState(() {
                                if (isSelected) {
                                  selectedSkills.remove(skill);
                                } else {
                                  selectedSkills.add(skill);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 30),

                      // Toggle Card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            // <-- key fix: allow text to wrap instead of forcing overflow
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "I want to help others",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Open your profile for peer requests",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: helpOthers,
                              activeColor: Colors.deepPurple,
                              onChanged: (value) {
                                setState(() => helpOthers = value);
                              },
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Finish Button
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Skills: ${selectedSkills.join(", ")} | Help: $helpOthers",
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Finish",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}