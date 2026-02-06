import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_app/showcase_skills.dart';

class BasicInfo extends StatefulWidget {
  const BasicInfo({super.key});

  @override
  State<BasicInfo> createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final deptController = TextEditingController();
  final batchController = TextEditingController();

  final supabase = Supabase.instance.client;

  Uint8List? imageBytes;
  XFile? pickedFile;

  bool loading = false;
  bool loadingUserInfo = true;

  @override
  void initState() {
    super.initState();
    loadProfile(); // ✅ only one initState
  }

  Future<void> loadProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // ✅ email from auth
      emailController.text = user.email ?? '';

      // ✅ get full_name + department from profiles
      final res = await supabase
          .from('profiles')
          .select('full_name, department')
          .eq('id', user.id)
          .maybeSingle();

      nameController.text = (res?['full_name'] ?? '').toString();
      deptController.text = (res?['department'] ?? '').toString();
    } catch (e) {
      debugPrint("loadProfile error: $e");
    } finally {
      if (mounted) setState(() => loadingUserInfo = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    deptController.dispose();
    batchController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? result = await picker.pickImage(source: ImageSource.gallery);

    if (result != null) {
      final bytes = await result.readAsBytes();
      setState(() {
        pickedFile = result;
        imageBytes = bytes;
      });
    }
  }

  Future<String?> uploadImage() async {
    if (pickedFile == null || imageBytes == null) return null;

    try {
      final user = supabase.auth.currentUser;
      final uid = user?.id ?? 'anon';
      final fileName = "$uid/profile_${DateTime.now().millisecondsSinceEpoch}.jpg";

      await supabase.storage.from('Bucket1').uploadBinary(
            fileName,
            imageBytes!,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      return supabase.storage.from('Bucket1').getPublicUrl(fileName);
    } catch (e) {
      debugPrint("Upload Error: $e");
      return null;
    }
  }

  Future<bool> submitData() async {
    setState(() => loading = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw "User not logged in";

      final dept = deptController.text.trim();
      final batchText = batchController.text.trim();

      if (dept.isEmpty || batchText.isEmpty) {
        throw "Fill all fields";
      }

      final batchInt = int.tryParse(batchText);
      if (batchInt == null) throw "Batch must be a number";

      final imageUrl = await uploadImage();

      // ✅ Save only what you want in profiles
      await supabase.from('profiles').upsert({
        'id': user.id,
        'department': dept,
        'avatar_url': imageUrl,
        'updated_at': DateTime.now().toIso8601String(),
        // যদি profiles এ batch column add করো, তখন save করো:
        // 'batch': batchInt,
      }, onConflict: 'id');

      if (!mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated Successfully")),
      );

      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
      return false;
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Basic Info", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: loadingUserInfo
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // profile image
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                              imageBytes != null ? MemoryImage(imageBytes!) : null,
                          child: imageBytes == null
                              ? const Icon(Icons.person, size: 60, color: Colors.grey)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.deepPurple,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ✅ fixed fields (read-only)
                  buildField(controller: nameController, hint: "Full Name", readOnly: true),
                  const SizedBox(height: 15),
                  buildField(controller: emailController, hint: "Email", readOnly: true),
                  const SizedBox(height: 15),

                  // ✅ user input fields
                  buildField(controller: deptController, hint: "Department"),
                  const SizedBox(height: 15),
                  buildField(controller: batchController, hint: "Batch (Number)", isNumber: true),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () async {
                              final ok = await submitData();
                              if (!ok) return;
                              if (!mounted) return;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ShowcaseSkillsPage(),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Next",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String hint,
    bool isNumber = false,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        filled: readOnly,
        fillColor: readOnly ? Colors.grey.shade100 : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
      ),
    );
  }
}
