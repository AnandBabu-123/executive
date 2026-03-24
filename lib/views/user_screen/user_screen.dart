import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/user_bloc/user_bloc.dart';
import '../../bloc/user_bloc/user_event.dart';
import '../../bloc/user_bloc/user_state.dart';
import '../../config/session_manager/session_manager.dart';
import '../../model/user_model/blood_group_model.dart';
import '../../network/dio_network/dio_client.dart';
import '../../repository/user_repo/blood_groop_repository.dart';
import '../../repository/user_repo/category_repository.dart';


class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserBloc>();
    userBloc.add(FetchUsers());

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        final state = userBloc.state;
        if (state is UserLoaded && state.currentPage <= state.lastPage) {
          userBloc.add(FetchUsers());
        }
      }
    });
  }

  void _openAddUserBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddUserBottomSheet(userBloc: userBloc),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
        title: const Text("User List", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Users...",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              onChanged: (value) => userBloc.add(FetchUsers(search: value, reset: true)),
            ),
          ),
        ),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading && state is! UserLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else if (state is UserLoaded) {
            if (state.users.isEmpty) return const Center(child: Text("No Users Found"));

            return ListView.builder(
              controller: scrollController,
              itemCount: state.users.length,
              itemBuilder: (_, index) {
                final user = state.users[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 2))]),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(user.image),
                        backgroundColor: Colors.grey[300],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(user.email),
                            Text(user.mobile),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddUserBottomSheet,
        icon: const Icon(Icons.add),
        label: const Text("Add User"),
      ),
    );
  }
}
class AddUserBottomSheet extends StatefulWidget {
  final UserBloc userBloc;
  const AddUserBottomSheet({super.key, required this.userBloc});

  @override
  State<AddUserBottomSheet> createState() => _AddUserBottomSheetState();
}

class _AddUserBottomSheetState extends State<AddUserBottomSheet> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController dob = TextEditingController();
  String? gender;
  int? selectedBloodGroupId;
  int? selectedCategoryId;
  XFile? pickedImage;
  final ImagePicker _picker = ImagePicker();

  List<BloodGroup> bloodGroups = [];
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchDropdowns();
  }

  Future<void> _fetchDropdowns() async {
    try {
      final dioClient = widget.userBloc.userRepository.dioClient; // get DioClient from repository

      bloodGroups = await BloodGroupRepository(dioClient).getBloodGroups();
      categories = await CategoryRepository(dioClient).getCategories();

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Select Image Source"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, ImageSource.camera), child: const Text("Camera")),
          TextButton(onPressed: () => Navigator.pop(ctx, ImageSource.gallery), child: const Text("Gallery")),
        ],
      ),
    );
    if (source == null) return;

    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      final file = File(picked.path);
      final sizeInMB = await file.length() / (1024 * 1024);
      if (sizeInMB > 2) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Image should be less than 2MB"), backgroundColor: Colors.red));
        return;
      }
      setState(() => pickedImage = picked);
    }
  }

  Widget _input(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Add User", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: pickedImage != null ? FileImage(File(pickedImage!.path)) : null,
                    child: pickedImage == null ? const Icon(Icons.camera_alt, size: 40) : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _input("Name", name),
              _input("Email", email, keyboardType: TextInputType.emailAddress),
              _input("Mobile", mobile, keyboardType: TextInputType.phone),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DropdownButtonFormField<String>(
                  value: gender,
                  decoration: InputDecoration(labelText: "Gender", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  items: ["male", "female", "other"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() => gender = val),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DropdownButtonFormField<int>(
                  value: selectedBloodGroupId,
                  decoration: InputDecoration(labelText: "Blood Group", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  items: bloodGroups.map((bg) => DropdownMenuItem(value: bg.id, child: Text(bg.name))).toList(),
                  onChanged: (val) => setState(() => selectedBloodGroupId = val),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DropdownButtonFormField<int>(
                  value: selectedCategoryId,
                  decoration: InputDecoration(labelText: "Category", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  items: categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                  onChanged: (val) => setState(() => selectedCategoryId = val),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: dob,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "Date of Birth", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) dob.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                  },
                ),
              ),
              const SizedBox(height: 20),
              BlocConsumer<UserBloc, UserState>(
                bloc: widget.userBloc,
                listener: (context, state) {
                  if (state is UserAdded || state is UserAddError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state is UserAdded ? "User Added Successfully" : (state as UserAddError).message), backgroundColor: state is UserAdded ? Colors.green : Colors.red));
                    Navigator.pop(context); // 🔥 dismiss bottom sheet on success/failure
                  }
                },
                builder: (context, state) {
                  final loading = state is UserAdding;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () async {
                        if (name.text.isEmpty || email.text.isEmpty || mobile.text.isEmpty || gender == null || dob.text.isEmpty || selectedBloodGroupId == null || selectedCategoryId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please fill all required fields"), backgroundColor: Colors.red));
                          return;
                        }
                        final userId = await SessionManager.getUserId();
                        widget.userBloc.add(AddUser(
                          name: name.text,
                          email: email.text,
                          mobile: mobile.text,
                          gender: gender!,
                          dob: dob.text,
                          bloodGroupId: selectedBloodGroupId!,
                          coverageCategoryId: selectedCategoryId!,
                          userId: userId!,
                          image: pickedImage != null ? File(pickedImage!.path) : null,
                        ));
                      },
                      child: loading
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text("Save"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}