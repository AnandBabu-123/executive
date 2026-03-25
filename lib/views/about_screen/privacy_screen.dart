import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/privacy_bloc/privacy_bloc.dart';
import '../../bloc/privacy_bloc/privacy_event.dart';
import '../../bloc/privacy_bloc/privacy_state.dart';
import '../../config/colors/app_colors.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PrivacyBloc>().add(FetchPrivacy());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.blue,
      ),
      body: BlocBuilder<PrivacyBloc, PrivacyState>(
        builder: (context, state) {
          if (state is PrivacyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PrivacyLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                state.data.name,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            );
          } else if (state is PrivacyError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}