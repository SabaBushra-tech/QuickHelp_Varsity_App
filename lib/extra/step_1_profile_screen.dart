import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Step1Screen extends StatefulWidget {
  const Step1Screen({super.key});

  @override
  State<Step1Screen> createState() => _Step1screenState();
}

class _Step1screenState extends State<Step1Screen> {
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  Future<void> pickImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _profileImage = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Basic Info",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 6,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5A2DFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 6,
                      width: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  "Let's set up your profile",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Add your details so others can find you.",
                  style: TextStyle(color: Colors.black54),
                ),

                const SizedBox(height: 30),

                // Profile image
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage:
                            _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF5A2DFF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Center(
                  child: TextButton(
                    onPressed: pickImage,
                    child: const Text(
                      "Upload Photo (Optional)",
                      style: TextStyle(
                        color: Color(0xFF5A2DFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Full name"),
                const SizedBox(height: 6),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "e.g. MST Sadiya Islam",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Department"),
                const SizedBox(height: 6),
                TextField(
                  controller: departmentController,
                  decoration: InputDecoration(
                    hintText: "CSE",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A2DFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
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
