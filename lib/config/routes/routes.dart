import 'package:dio/dio.dart';
import 'package:executive/config/routes/routes_name.dart';
import 'package:executive/views/bank_details/bank_details_screen.dart';
import 'package:executive/views/contact_us_screen/contact_screen.dart';
import 'package:executive/views/home_screen/home_screen.dart';
import 'package:executive/views/login_view/login_screen.dart';
import 'package:executive/views/otp_verify/otp_verify_screen.dart';
import 'package:executive/views/profile_screen/profile_screen.dart';
import 'package:executive/views/splash_screen/splash_screen.dart';
import 'package:executive/views/wallet_screen/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/about_bloc/about_bloc.dart';
import '../../bloc/about_bloc/about_event.dart';
import '../../bloc/agent_bloc/agent_bloc.dart';
import '../../bloc/bank_bloc/bank_bloc.dart';
import '../../bloc/contact_bloc/contact_bloc.dart';
import '../../bloc/home_bloc/home_bloc.dart';
import '../../bloc/home_bloc/home_event.dart';
import '../../bloc/login_bloc/login_bloc.dart';
import '../../bloc/notification_bloc/notification_bloc.dart';
import '../../bloc/notification_bloc/notification_event.dart';
import '../../bloc/otp_bloc/otp_bloc.dart';
import '../../bloc/privacy_bloc/privacy_bloc.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../bloc/subscription_bloc/subscription_bloc.dart';
import '../../bloc/subscription_bloc/subscription_event.dart';
import '../../bloc/terms_bloc/terms_bloc.dart';
import '../../bloc/tutorial_bloc/tutorial_bloc.dart';
import '../../bloc/tutorial_bloc/tutorial_event.dart';
import '../../bloc/update_bloc/update_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../bloc/wallet_bloc/wallet_bloc.dart';
import '../../network/dio_network/dio_client.dart';
import '../../network/dio_network/network_info.dart';
import '../../repository/about_repo/about_repository.dart';
import '../../repository/about_repo/privacy_repository.dart';
import '../../repository/about_repo/terms_repository.dart';
import '../../repository/agent_repo/agent_repository.dart';
import '../../repository/agent_repo/post_agent_repository.dart';
import '../../repository/bank_details_repository/add_bank_repository.dart';
import '../../repository/bank_details_repository/bank_details_repository.dart';
import '../../repository/bank_details_repository/update_bank_repository.dart';
import '../../repository/contact_repo/conatctus_repository.dart';
import '../../repository/home_repository/home_repository.dart';
import '../../repository/login_repo/login_repository.dart';
import '../../repository/notification_repository/notification_repository.dart';
import '../../repository/otp_repo/otp_repository.dart';
import '../../repository/profile_repo/profile_repository.dart';
import '../../repository/profile_repo/update_profole_repository.dart';
import '../../repository/subscriptions_repository/subscriptions_repository.dart';
import '../../repository/tutorial_repository/tutorial_repository.dart';
import '../../repository/update_repository/update_repository.dart';
import '../../repository/user_repo/user_post_repository.dart';
import '../../repository/user_repo/user_repository.dart';
import '../../repository/wallet_repository/wallet_repository.dart';
import '../../repository/wallet_repository/wallet_withdraw_repository.dart';
import '../../views/about_screen/about_screen.dart';
import '../../views/about_screen/privacy_screen.dart';
import '../../views/about_screen/terms_screen.dart';
import '../../views/agent_screen/agent_screen.dart';
import '../../views/bottom_navigation_screens/bottom_navigation_screens.dart';
import '../../views/notification_screen/notification_screen.dart';
import '../../views/subscription_screen/subscription_screen.dart';
import '../../views/tutorial_screen/tutorial_screen.dart';
import '../../views/user_screen/user_screen.dart';
import '../session_manager/session_manager.dart';


class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

    /// ================= SPLASH =================
    //   case RoutesName.splashScreen:
    //     return MaterialPageRoute(
    //       builder: (_) => const SplashScreen(),
    //     );


      case RoutesName.splashScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => UpdateBloc(UpdateRepository(
              DioClient(
                dio: Dio(),
                networkInfo: NetworkInfo(),
                tokenProvider: () async => null,
              ),)),
            child: const SplashScreen(),
          ),
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
          builder: (context) {
            final dioClient = DioClient(
              dio: Dio(),
              networkInfo: NetworkInfo(),
              tokenProvider: () async => await SessionManager.getToken(),
            );

            return BlocProvider(
              create: (_) => WalletBloc(
                repository: WalletRepository(dioClient),
                withdrawRepository: WalletWithdrawRepository(dioClient),
              ),
              child: const WalletScreen(),
            );
          },
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

              ///  UPDATE PROFILE REPO (ADD THIS)
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

      case RoutesName.tutorialScreen:
        return MaterialPageRoute(
          builder: (context) {
            final dioClient = DioClient(
              dio: Dio(),
              networkInfo: NetworkInfo(),
              tokenProvider: () async => await SessionManager.getToken(),
            );

            return BlocProvider(
              create: (_) => TutorialBloc(
                TutorialRepository(dioClient),
              )..add(FetchTutorials()),
              child: const TutorialScreen(),
            );
          },
        );

      case RoutesName.contactUsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ContactBloc(
              ContactUsRepository(
                DioClient(
                  dio: Dio(), //  MUST ADD
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


      case RoutesName.agentScreen:
        return MaterialPageRoute(
          builder: (context) {
            // Create DioClient once
            final dioClient = DioClient(
              dio: Dio(),
              networkInfo: NetworkInfo(),
              tokenProvider: () async => await SessionManager.getToken(),
            );
            final scaffoldKey = GlobalKey<ScaffoldState>();

            return BlocProvider<AgentBloc>(
              create: (_) => AgentBloc(
                agentRepository: AgentRepository(dioClient),
                postAgentRepository: PostAgentRepository(dioClient),
              ),
              child:  AgentScreen(scaffoldKey: scaffoldKey, showBackButton: true),
            );
          },
        );

      case RoutesName.userScreen:
        return MaterialPageRoute(
          builder: (context) {
            // Create DioClient once
            final dioClient = DioClient(
              dio: Dio(),
              networkInfo: NetworkInfo(),
              tokenProvider: () async => await SessionManager.getToken(),
            );
            final scaffoldKey = GlobalKey<ScaffoldState>();
            return MultiBlocProvider(
              providers: [
                BlocProvider<UserBloc>(
                  create: (_) => UserBloc(
                    userRepository: UserRepository(dioClient),
                    userPostRepository: UserPostRepository(dioClient),
                  ),
                ),
              ],
              child:  UserScreen(scaffoldKey: scaffoldKey, showBackButton: true,),
            );
          },
        );

      case RoutesName.subscriptionScreen:
        return MaterialPageRoute(
          builder: (context) {
            final dioClient = DioClient(
              dio: Dio(),
              networkInfo: NetworkInfo(),
              tokenProvider: () async => await SessionManager.getToken(),
            );
            final scaffoldKey = GlobalKey<ScaffoldState>();
            return BlocProvider(
              create: (_) => SubscriptionBloc(
                subscriptionsRepository: SubscriptionsRepository(dioClient),
              )..add(FetchSubscriptions()),
              child:  SubscriptionScreen(scaffoldKey: scaffoldKey, showBackButton: true,),
            );
          },
        );
      case RoutesName.aboutScreen:
        return MaterialPageRoute(
          builder: (context) {
            final dioClient = DioClient(
              dio: Dio(),
              networkInfo: NetworkInfo(),
              tokenProvider: () async => await SessionManager.getToken(),
            );

            return BlocProvider<AboutBloc>(
              create: (_) => AboutBloc(
                aboutRepository: AboutRepository(dioClient),
              )..add(FetchAbout()),
              child: const AboutScreen(),
            );
          },
        );

      case RoutesName.termsScreen:
        return MaterialPageRoute(
          builder: (context) {
            final dioClient = DioClient(
              dio: Dio(),
              networkInfo: NetworkInfo(),
              tokenProvider: () async => await SessionManager.getToken(),
            );

            return BlocProvider(
              create: (_) => TermsBloc(
                repository: TermsRepository(dioClient),
              ),
              child: const TermsScreen(),
            );
          },
        );

      case RoutesName.privacyScreen:
        return MaterialPageRoute(
          builder: (context) {
            final dioClient = DioClient(
              dio: Dio(),
              networkInfo: NetworkInfo(),
              tokenProvider: () async => await SessionManager.getToken(),
            );

            return BlocProvider(
              create: (_) => PrivacyBloc(
                repository: PrivacyRepository(dioClient),
              ),
              child: const PrivacyScreen(),
            );
          },
        );

    /// ================= HOME =================


      // case RoutesName.homeScreen:
      //   return MaterialPageRoute(
      //     builder: (_) {
      //       final dioClient = DioClient(
      //         dio: Dio(),
      //         networkInfo: NetworkInfo(),
      //         tokenProvider: () async => await SessionManager.getToken(),
      //       );
      //
      //       return BlocProvider(
      //         create: (_) => HomeBloc(HomeRepository(dioClient))..add(FetchHomeData()),
      //         child: const BottomNavigationScreens(),
      //       );
      //     },
      //   );

      case RoutesName.homeScreen:
        return MaterialPageRoute(
          builder: (_) {
            final dioClient = DioClient(
              dio: Dio(),
              networkInfo: NetworkInfo(),
              tokenProvider: () async => await SessionManager.getToken(),
            );

            return MultiBlocProvider(
              providers: [

                /// 🔷 HOME BLOC
                BlocProvider<HomeBloc>(
                  create: (_) => HomeBloc(
                    HomeRepository(dioClient),
                  )..add(FetchHomeData()),
                ),

                /// 🔷 NOTIFICATION BLOC (🔥 ADD THIS)
                BlocProvider<NotificationBloc>(
                  create: (_) => NotificationBloc(
                    repository: NotificationRepository(dioClient),
                   )..add(FetchNotifications()),
                ),
              ],

              /// 🔥 IMPORTANT
              child: const BottomNavigationScreens(),
            );
          },
        );
      case RoutesName.notificationScreen:
        return MaterialPageRoute(
          builder: (context) {
            final dioClient = DioClient(
              dio: Dio(),
              networkInfo: NetworkInfo(),
              tokenProvider: () async => await SessionManager.getToken(),
            );

            return BlocProvider(
              create: (_) => NotificationBloc(
                repository: NotificationRepository(dioClient),
              )..add(FetchNotifications()),
              child: const NotificationScreen(),
            );
          },
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
