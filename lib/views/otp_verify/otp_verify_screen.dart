import 'package:executive/config/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/otp_bloc/otp_bloc.dart';
import '../../bloc/otp_bloc/otp_event.dart';
import '../../bloc/otp_bloc/otp_state.dart';
import '../../config/routes/routes_name.dart';
import 'package:flutter_svg/flutter_svg.dart';


class OtpVerifyScreen extends StatefulWidget {
  final int userId;

  const OtpVerifyScreen({
    super.key,
    required this.userId,
  });

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());

  String getOtp() {
    return controllers.map((e) => e.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "OTP Verification",
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),

      /// ================= BODY =================
      body: BlocConsumer<OtpBloc, OtpState>(
        listener: (context, state) {
          if (state is OtpSuccess) {
            _showMsg(
              "OTP Verified Successfully",
              bgColor: Colors.green, // ✅ success color
            );

            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.homeScreen,
                  (route) => false,
            );
          }

          if (state is OtpError) {
            _showMsg(
              state.message,
              bgColor: Colors.red,
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [

              /// ===== CONTENT =====
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [

                      /// SVG IMAGE
                      SizedBox(
                        height: 160,
                        child: SvgPicture.asset("assets/med.svg"),
                      ),

                      const SizedBox(height: 30),

                      /// TITLE
                      const Text(
                        "Enter OTP",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Enter the 6-digit OTP sent to your number",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),


                      const SizedBox(height: 30),

                      /// OTP BOXES (6 DIGITS)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 45,
                            child: TextField(
                              controller: controllers[index],
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),

                              /// 🔥 FIXED LOGIC
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  /// Move forward
                                  if (index < 5) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                } else {
                                  /// Move backward ONLY (no clearing)
                                  if (index > 0) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                }
                              },
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),

              /// ===== VERIFY BUTTON =====
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    onPressed: state is OtpLoading
                        ? null
                        : () {
                      final otp = getOtp();

                      if (otp.length != 6) {
                        _showMsg("Enter valid 6-digit OTP", bgColor: Colors.red,);

                        return;
                      }

                      context.read<OtpBloc>().add(
                        SubmitOtpEvent(
                          userId: widget.userId,
                          otp: otp,
                        ),
                      );
                    },

                    child: state is OtpLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      "Verify OTP",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMsg(String msg, {Color bgColor = Colors.grey}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: bgColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(
            msg,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  }
}
