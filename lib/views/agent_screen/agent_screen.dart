
import 'package:executive/config/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/agent_bloc/agent_bloc.dart';
import '../../bloc/agent_bloc/agent_event.dart';
import '../../bloc/agent_bloc/agent_state.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../config/session_manager/session_manager.dart';



class AgentScreen extends StatefulWidget {
  const AgentScreen({super.key});

  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late AgentBloc agentBloc;

  @override
  void initState() {
    super.initState();
    agentBloc = context.read<AgentBloc>();
    agentBloc.add(FetchAgents());

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        final state = agentBloc.state;
        if (state is AgentLoaded && state.currentPage <= state.lastPage) {
          agentBloc.add(FetchAgents());
        }
      }
    });
  }

  void _openAddAgentBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddAgentBottomSheet(agentBloc: agentBloc),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Agent List",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Agents...",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) => agentBloc.add(FetchAgents(search: value, reset: true)),
            ),
          ),

          // Agents List
          Expanded(
            child: BlocBuilder<AgentBloc, AgentState>(
              builder: (context, state) {
                if (state is AgentLoading && state is! AgentLoaded) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AgentError) {
                  return Center(child: Text(" No data"));
                } else if (state is AgentLoaded) {
                  if (state.agents.isEmpty) return const Center(child: Text("No agents found"));

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: state.agents.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemBuilder: (_, index) {
                      final agent = state.agents[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5, offset: const Offset(0, 2))],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(radius: 25, backgroundImage: NetworkImage(agent.image)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(agent.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(agent.email),
                                  Text(agent.mobile),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddAgentBottomSheet,
        label: const Text("Add Agent",style: TextStyle(color: AppColors.whiteColor),),
        backgroundColor: AppColors.blue,
      ),
    );
  }
}

// ---------------- Add Agent Bottom Sheet ---------------- //

class AddAgentBottomSheet extends StatefulWidget {
  final AgentBloc agentBloc;
  const AddAgentBottomSheet({super.key, required this.agentBloc});

  @override
  State<AddAgentBottomSheet> createState() => _AddAgentBottomSheetState();
}

class _AddAgentBottomSheetState extends State<AddAgentBottomSheet> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController occupation = TextEditingController();
  String? gender;
  XFile? pickedImage;
  final ImagePicker _picker = ImagePicker();

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
      child: TextFormField(
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
                  const Text("Add Agent", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  initialValue: gender,
                  decoration: InputDecoration(labelText: "Gender", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  items: ["male", "female", "other"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() => gender = val),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
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
              _input("Occupation", occupation),
              const SizedBox(height: 20),
              BlocConsumer<AgentBloc, AgentState>(
                bloc: widget.agentBloc,
                listener: (context, state) {
                  String message = "";
                  Color bgColor = Colors.green;

                  if (state is AgentAdded) {
                    message = "Agent Added Successfully";
                    bgColor = Colors.green;
                  } else if (state is AgentAddError) {
                    message = state.message;
                    bgColor = Colors.red;
                  } else {
                    return; // ignore other states
                  }

                  // Show SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message), backgroundColor: bgColor),
                  );

                  // Dismiss BottomSheet after showing message
                  Navigator.pop(context);
                },
                builder: (context, state) {
                  final loading = state is AgentAdding;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () async {
                        if (name.text.isEmpty ||
                            email.text.isEmpty ||
                            mobile.text.isEmpty ||
                            gender == null ||
                            dob.text.isEmpty ||
                            occupation.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all required fields"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        //  Get user_id from SessionManager
                        final userId = await SessionManager.getUserId();

                        widget.agentBloc.add(AddAgent(
                          name: name.text,
                          email: email.text,
                          mobile: mobile.text,
                          gender: gender!,
                          dob: dob.text,
                          occupation: occupation.text,
                          image: pickedImage != null ? File(pickedImage!.path) : null,
                          userId: userId!,
                        ));
                      },
                      child: loading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
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