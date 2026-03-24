import 'dart:io';

import 'package:executive/config/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../bloc/profile_bloc/profile_event.dart';
import '../../bloc/profile_bloc/profile_state.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final occupation = TextEditingController();
  final uniqueId = TextEditingController();

  String? selectedGender;

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> genderList = ["male", "female"];

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  /// ================= IMAGE PICK DIALOG =================
  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Select Image"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// ================= PICK IMAGE WITH 2MB VALIDATION =================
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      /// 🔥 SIZE CHECK (2MB)
      final sizeInBytes = await file.length();
      final sizeInMB = sizeInBytes / (1024 * 1024);

      if (sizeInMB > 2) {
        _showMsg("Image should be less than 2MB", isError: true);
        return;
      }

      setState(() {
        selectedImage = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Profile", style: TextStyle(color: Colors.white)),

        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return IconButton(
                  icon: Icon(
                    state.isEditable ? Icons.check : Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    context.read<ProfileBloc>().add(ToggleEditEvent());
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),

      /// ================= UPDATE BUTTON =================
      bottomNavigationBar: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          bool showButton =
              state is ProfileLoaded && state.isEditable;

          return showButton
              ? SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    context.read<ProfileBloc>().add(
                      UpdateProfileEvent(
                        name: nameController.text.trim(),
                        gender: selectedGender ?? "",
                        occupation: occupation.text.trim(),
                        dob: dobController.text.trim(),
                        image: selectedImage,
                      ),
                    );
                  },
                  child: const Text(
                    "Update Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
              : const SizedBox();
        },
      ),

      /// ================= BODY =================
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {

          /// ✅ SUCCESS MESSAGE
          if (state is ProfileLoaded && state.message != null) {
            _showMsg(state.message!, isSuccess: true);
          }

          /// ❌ ERROR MESSAGE
          if (state is ProfileError) {
            _showMsg(state.message, isError: true);
          }
        },

        builder: (context, state) {

          /// 🔥 LOADING (only first time full screen)
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          /// 🔥 UPDATING (DO NOT BLANK SCREEN)
          if (state is ProfileUpdating) {
            return Stack(
              children: [
                _buildForm(), // 👈 keep old UI visible
                const Center(child: CircularProgressIndicator()), // loader overlay
              ],
            );
          }

          /// ✅ LOADED
          if (state is ProfileLoaded) {
            final data = state.profile;
            final isEditable = state.isEditable;

            /// 🔥 SET DATA ONLY ONCE
            if (nameController.text.isEmpty) {
              nameController.text = data.name;
              mobileController.text = data.mobile;
              emailController.text = data.email;
              occupation.text = data.occupation ?? "";
              dobController.text = data.dob ?? "";
              uniqueId.text = data.uniqueId ?? "";
              selectedGender = data.gender;
            }

            return _buildForm(isEditable: isEditable);
          }

          /// ❌ ERROR UI (NO BLANK)
          if (state is ProfileError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          /// 🔥 DEFAULT (NO BLANK SCREEN)
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildForm({bool isEditable = false}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE
          Center(
            child: GestureDetector(
              onTap: isEditable ? _showImagePickerDialog : null,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!)
                        : const AssetImage("assets/icon.png")
                    as ImageProvider,
                  ),

                  if (isEditable)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          _label("Name"),
          _textField(
            controller: nameController,
            hint: "Enter name",
            enabled: isEditable,
          ),

          const SizedBox(height: 15),

          _label("Mobile"),
          _textField(
            controller: mobileController,
            hint: "Enter mobile",
            enabled: false,
          ),

          const SizedBox(height: 15),

          _label("Email"),
          _textField(
            controller: emailController,
            hint: "Enter email",
            enabled: false,
          ),


          const SizedBox(height: 15),
          _label("Gender"),
          DropdownButtonFormField<String>(
            value: selectedGender,

            items: genderList.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(color: Colors.black), // 🔥 always black
                ),
              );
            }).toList(),

            /// 🔥 THIS = enabled: false
            onChanged: isEditable
                ? (value) {
              setState(() {
                selectedGender = value;
              });
            }
                : null,

            decoration: InputDecoration(
              filled: true,
              fillColor: isEditable
                  ? Colors.grey.shade100
                  : Colors.grey.shade300, // 🔥 disabled look

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 14,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 15),

          _label("Date Of Birth"),
          GestureDetector(
            onTap: isEditable ? _selectDate : null,
            child: AbsorbPointer(
              child: _textField(
                controller: dobController,
                hint: "Select Date Of Birth",
                enabled: isEditable,
              ),
            ),
          ),

          const SizedBox(height: 15),
          const SizedBox(height: 15),

          _label("Occupation"),
          _textField(
            controller: occupation,
            hint: "Enter Occupation",
            enabled: isEditable,
          ),

          const SizedBox(height: 15),

          _label("Referral ID"),
          _textField(
            controller: uniqueId,
            hint: "",
            enabled: false,
          ),
        ],
      ),
    );
  }
  /// ================= COMMON =================

  void _showMsg(String msg,
      {bool isError = false, bool isSuccess = false}) {

    Color bgColor = Colors.grey.shade800;
    if (isError) bgColor = Colors.red;
    if (isSuccess) bgColor = Colors.green;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: bgColor,
          content: Text(msg,
              style: const TextStyle(color: Colors.white)),
        ),
      );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text,
        style: const TextStyle(fontWeight: FontWeight.w500)),
  );

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor:
        enabled ? Colors.grey.shade100 : Colors.grey.shade300,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  InputDecoration _dropDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dobController.text =
      "${picked.day}-${picked.month}-${picked.year}";
      setState(() {});
    }
  }
}
