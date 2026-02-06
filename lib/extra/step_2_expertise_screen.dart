import 'package:flutter/material.dart';

class Step2Screen extends StatefulWidget {
  const Step2Screen({super.key});

  @override
  State<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  List<String> skills = [
    'Python',
    'Java',
    'C++',
    'DSA',
    'DBMS',
    'OS',
    'OOP',
    'Algorithms',
  ];

  Set<String> selectedSkills = {'Python', 'Java','C++'};
  bool helpOthers = true;
  int rate = 5;

  // List<String> days = ['M', 'Tu', 'W', 'Th', 'F', 'Sa', 'Su'];
  // Set<int> selectedDays = {0, 2, 4};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// STEP TEXT (FIXED)
              Center(
                child: Text(
                  'STEP 2 OF 2',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 64, 64, 64),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// PROGRESS BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 6,
                    width: 12,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 169, 165, 165),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 6,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 45, 19, 131),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// TITLE
              const Text(
                'Showcase your expertise',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                'Select the skills you can share with peers to\nstart building your profile.',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              /// SEARCH FIELD
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search skills (e.g. Python)',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// SKILLS CHIPS
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: skills.map((skill) {
                  final isSelected = selectedSkills.contains(skill);
                  return ChoiceChip(
                          



                    label: Text(skill),
                    selected: isSelected,
                    selectedColor: Color.fromARGB(255, 45, 19, 131),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onSelected: (_) {
                      setState(() {
                        isSelected
                            ? selectedSkills.remove(skill)
                            : selectedSkills.add(skill);
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 80),

              /// HELP OTHERS SWITCH
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'I want to help others',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Earn credits by teaching',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Switch(
                    value: helpOthers,
                    activeColor: Color.fromARGB(255, 45, 19, 131),
                    onChanged: (v) {
                      setState(() => helpOthers = v);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 100),

              // /// AVAILABILITY
              // const Text(
              //   'Your Availability',
              //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              // ),

              // const SizedBox(height: 10),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: List.generate(days.length, (index) {
              //     final isActive = selectedDays.contains(index);
              //     return GestureDetector(
              //       onTap: () {
              //         setState(() {
              //           isActive
              //               ? selectedDays.remove(index)
              //               : selectedDays.add(index);
              //         });
              //       },
              //       child: CircleAvatar(
              //         backgroundColor: isActive
              //             ? Color.fromARGB(255, 45, 19, 131)
              //             : Colors.grey.shade200,
              //         child: Text(
              //           days[index],
              //           style: TextStyle(
              //             color: isActive ? Colors.white : Colors.black,
              //           ),
              //         ),
              //       ),
              //     );
              //   }),
              // ),

              // const SizedBox(height: 30),

              // /// RATE
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: const [
              //     Text(
              //       '15-minute rate',
              //       style: TextStyle(
              //         fontSize: 16,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     Text(
              //       'Recommended: 10',
              //       style: TextStyle(color: Colors.deepPurple),
              //     ),
              //   ],
              // ),

              // const SizedBox(height: 10),

              // Row(
              //   children: [
              //     IconButton(
              //       icon: const Icon(Icons.remove),
              //       onPressed: () {
              //         if (rate > 1) {
              //           setState(() => rate--);
              //         }
              //       },
              //     ),
              //     Text(
              //       '\$ $rate credits',
              //       style: const TextStyle(fontSize: 18),
              //     ),
              //     IconButton(
              //       icon: const Icon(Icons.add),
              //       onPressed: () {
              //         setState(() => rate++);
              //       },
              //     ),
              //   ],
              // ),

              // const SizedBox(height: 40),

              /// FINISH BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 45, 19, 131),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    //TODO: Navigate or Save Data
                  },
                  child: const Text(
                    'Finish',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
