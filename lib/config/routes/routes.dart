import 'package:dio/dio.dart';
import 'package:executive/config/routes/routes_name.dart';
import 'package:executive/views/bank_details/bank_details_screen.dart';
import 'package:executive/views/contact_us_screen/contact_screen.dart';
import 'package:executive/views/home_screen/app_drawer.dart';
import 'package:executive/views/home_screen/home_screen.dart';
import 'package:executive/views/login_view/login_screen.dart';
import 'package:executive/views/otp_verify/otp_verify_screen.dart';
import 'package:executive/views/profile_screen/profile_screen.dart';
import 'package:executive/views/splash_screen/splash_screen.dart';
import 'package:executive/views/wallet_screen/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bank_bloc/bank_bloc.dart';
import '../../bloc/contact_bloc/contact_bloc.dart';
import '../../bloc/login_bloc/login_bloc.dart';
import '../../bloc/otp_bloc/otp_bloc.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../network/dio_network/dio_client.dart';
import '../../network/dio_network/network_info.dart';
import '../../repository/bank_details_repository/add_bank_repository.dart';
import '../../repository/bank_details_repository/bank_details_repository.dart';
import '../../repository/bank_details_repository/update_bank_repository.dart';
import '../../repository/contact_repo/conatctus_repository.dart';
import '../../repository/login_repo/login_repository.dart';
import '../../repository/otp_repo/otp_repository.dart';
import '../../repository/profile_repo/profile_repository.dart';
import '../../repository/profile_repo/update_profole_repository.dart';
import '../session_manager/session_manager.dart';


class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

    /// ================= SPLASH =================
      case RoutesName.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

    /// ================= LOGIN =================
      case RoutesName.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => LoginBloc(
              LoginRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                  tokenProvider: () async => null,
                ),
              ),
            ),
            child: const LoginScreen(),
          ),
        );
    /// ================= OTP =================
      case RoutesName.otpScreen:
        final args = settings.arguments;

        if (args != null && args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => OtpBloc(
                OtpRepository(
                  DioClient(
                    dio: Dio(),
                    networkInfo: NetworkInfo(),
                    tokenProvider: () async => null,
                  ),
                ),
              ),
              child: OtpVerifyScreen(
                userId: args["userId"],
              ),
            ),
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text("UserId missing")),
            ),
          );
        }

      case RoutesName.walletScreen:
        return MaterialPageRoute(
          builder: (_) => const WalletScreen(),
        );

        /// bank details screen

      case RoutesName.bankDetails:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => BankBloc(

              /// 🔹 GET BANK REPO
              BankDetailsRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                  tokenProvider: () async {
                    return await SessionManager.getToken();
                  },
                ),
              ),

              /// 🔹 ADD BANK REPO
              AddBankRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                  tokenProvider: () async {
                    return await SessionManager.getToken();
                  },
                ),
              ),

              /// 🔹 UPDATE BANK REPO
              UpdateBankRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                  tokenProvider: () async {
                    return await SessionManager.getToken();
                  },
                ),
              ),
            ),

            child: const BankScreen(),
          ),
        );
    /// ================= PROFILE =================
      case RoutesName.profileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ProfileBloc(
              /// GET PROFILE REPO
              ProfileRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                  tokenProvider: () async {
                    return await SessionManager.getToken();
                  },
                ),
              ),

              /// 🔥 UPDATE PROFILE REPO (ADD THIS)
              UpdateProfileRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                  tokenProvider: () async {
                    return await SessionManager.getToken();
                  },
                ),
              ),
            ),
            child: const ProfileScreen(),
          ),
        );

      case RoutesName.contactUsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ContactBloc(
              ContactUsRepository(
                DioClient(
                  dio: Dio(), // ✅ MUST ADD
                  networkInfo: NetworkInfo(),
                  tokenProvider: () async {
                    return await SessionManager.getToken();
                  },
                ),
              ),
            ),
            child: const ContactScreen(),
          ),
        );
    /// ================= HOME =================
      case RoutesName.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

    /// ================= DRAWER =================
      case RoutesName.appBar:
        return MaterialPageRoute(
          builder: (_) => const AppDrawer(),
        );

    /// ================= DEFAULT =================
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("No routes found")),
          ),
        );
    }
  }
}
