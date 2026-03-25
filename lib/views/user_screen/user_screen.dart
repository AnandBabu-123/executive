import 'package:executive/config/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../bloc/user_bloc/user_event.dart';
import '../../bloc/user_bloc/user_state.dart';
import '../../config/session_manager/session_manager.dart';
import '../../model/user_model/blood_group_model.dart';
import '../../model/user_model/user_model.dart';
import '../../repository/user_repo/blood_groop_repository.dart';
import '../../repository/user_repo/category_repository.dart';


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

// Assume your UserBloc, UserState, User, AddUser event, SessionManager, BloodGroup, Category, Repositories are already imported

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late UserBloc userBloc;

  List<User> allUsers = [];       // Store all users for local search
  List<User> displayedUsers = []; // Users filtered by search

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
      builder: (_) => AddUserBottomSheet(userBloc: userBloc,rootContext: context),
    );
  }

  void _filterUsers(String query) {
    if (query.isEmpty) {
      setState(() => displayedUsers = List.from(allUsers));
    } else {
      final filtered = allUsers.where((user) {
        final lowerQuery = query.toLowerCase();
        return user.name.toLowerCase().contains(lowerQuery) ||
            user.email.toLowerCase().contains(lowerQuery) ||
            user.mobile.toLowerCase().contains(lowerQuery);
      }).toList();

      setState(() => displayedUsers = filtered);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "User List",
          style: TextStyle(fontSize: 19, color: Colors.white, fontWeight: FontWeight.w500),
        ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _filterUsers,
            ),
          ),
        ),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            allUsers = state.users;
            displayedUsers = List.from(allUsers);
          }
        },
        builder: (context, state) {
          if (state is UserLoading && state is! UserLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return const Center(child: Text("No Data found"));
          } else if (state is UserLoaded) {
            if (displayedUsers.isEmpty) return const Center(child: Text("No Users Found"));

            return ListView.builder(
              controller: scrollController,
              itemCount: displayedUsers.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (_, index) {
                final user = displayedUsers[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 2))],
                  ),
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

// AddUserBottomSheet
class AddUserBottomSheet extends StatefulWidget {
  final UserBloc userBloc;
  final BuildContext rootContext;

  const AddUserBottomSheet({
    super.key,
    required this.userBloc,
    required this.rootContext,
  });

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

  String? buttonMessage;

  @override
  void initState() {
    super.initState();
    _fetchDropdowns();
  }

  // ================= FETCH DROPDOWNS =================
  Future<void> _fetchDropdowns() async {
    try {
      final dioClient = widget.userBloc.userRepository.dioClient;

      bloodGroups = await BloodGroupRepository(dioClient).getBloodGroups();
      categories = await CategoryRepository(dioClient).getCategories();

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ================= AUTO DISMISS MESSAGE =================
  void _setMessage(String msg) {
    setState(() => buttonMessage = msg);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => buttonMessage = null);
      }
    });
  }

  // ================= SNACKBAR (ROOT) =================
  void _showMsg(String msg, {bool isError = false, bool isSuccess = false}) {
    Color bgColor = Colors.grey.shade800;
    if (isError) bgColor = Colors.red;
    if (isSuccess) bgColor = Colors.green;

    ScaffoldMessenger.of(widget.rootContext)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: bgColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(msg, style: const TextStyle(color: Colors.white)),
        ),
      );
  }

  // ================= IMAGE PICK =================
  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Select Image Source"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, ImageSource.camera),
              child: const Text("Camera")),
          TextButton(
              onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
              child: const Text("Gallery")),
        ],
      ),
    );

    if (source == null) return;

    final picked = await _picker.pickImage(source: source);

    if (picked != null) {
      final file = File(picked.path);
      final sizeInMB = await file.length() / (1024 * 1024);

      if (sizeInMB > 2) {
        _setMessage("Image should be less than 2MB");
        return;
      }

      setState(() {
        pickedImage = picked;
        buttonMessage = null;
      });
    }
  }

  // ================= INPUT FIELD =================
  Widget _input(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Add User",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context)),
                ],
              ),

              const SizedBox(height: 20),

              // IMAGE
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: pickedImage != null
                      ? FileImage(File(pickedImage!.path))
                      : null,
                  child: pickedImage == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              _input("Name", name),
              _input("Email", email,
                  keyboardType: TextInputType.emailAddress),
              _input("Mobile", mobile,
                  keyboardType: TextInputType.phone),

              // GENDER
              DropdownButtonFormField<String>(
                value: gender,
                decoration: InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                items: ["male", "female", "other"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => gender = val),
              ),

              const SizedBox(height: 16),

              // BLOOD GROUP
              DropdownButtonFormField<int>(
                value: selectedBloodGroupId,
                decoration: InputDecoration(
                  labelText: "Blood Group",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                items: bloodGroups
                    .map((bg) =>
                    DropdownMenuItem(value: bg.id, child: Text(bg.name)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => selectedBloodGroupId = val),
              ),

              const SizedBox(height: 16),

              // CATEGORY
              DropdownButtonFormField<int>(
                value: selectedCategoryId,
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                items: categories
                    .map((c) =>
                    DropdownMenuItem(value: c.id, child: Text(c.name)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => selectedCategoryId = val),
              ),

              const SizedBox(height: 16),

              // DOB
              TextField(
                controller: dob,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Date of Birth",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (picked != null) {
                    dob.text =
                    "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                  }
                },
              ),

              const SizedBox(height: 20),

              // 🔴 MESSAGE ABOVE BUTTON
              if (buttonMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    buttonMessage!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

              // ================= BUTTON =================
              BlocConsumer<UserBloc, UserState>(
                bloc: widget.userBloc,
                listener: (context, state) async {
                  if (state is UserAdded || state is UserAddError) {
                    Navigator.pop(context);

                    await Future.delayed(
                        const Duration(milliseconds: 300));

                    _showMsg(
                      state is UserAdded
                          ? "User Added Successfully"
                          : (state as UserAddError).message,
                      isSuccess: state is UserAdded,
                      isError: state is UserAddError,
                    );
                  }
                },
                builder: (context, state) {
                  final loading = state is UserAdding;

                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: loading
                          ? null
                          : () async {
                        if (name.text.isEmpty ||
                            email.text.isEmpty ||
                            mobile.text.isEmpty ||
                            gender == null ||
                            dob.text.isEmpty ||
                            selectedBloodGroupId == null ||
                            selectedCategoryId == null) {
                          _setMessage(
                              "Please fill all required fields");
                          return;
                        }

                        final userId =
                        await SessionManager.getUserId();

                        widget.userBloc.add(AddUser(
                          name: name.text,
                          email: email.text,
                          mobile: mobile.text,
                          gender: gender!,
                          dob: dob.text,
                          bloodGroupId:
                          selectedBloodGroupId!,
                          coverageCategoryId:
                          selectedCategoryId!,
                          userId: userId!,
                          image: pickedImage != null
                              ? File(pickedImage!.path)
                              : null,
                        ));
                      },
                      child: loading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
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