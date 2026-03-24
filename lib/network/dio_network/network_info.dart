
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  Future<bool> get isConnected async {
    var result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}

// import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// class NetworkInfo {
//   final Connectivity connectivity;
//
//   NetworkInfo({required this.connectivity});
//
//   Future<bool> get isConnected async {
//     final connectivityResult = await connectivity.checkConnectivity();
//
//     if (connectivityResult == ConnectivityResult.none) {
//       return false;
//     }
//
//     // Optional: Also check actual internet connectivity
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } on SocketException catch (_) {
//       return false;
//     }
//   }
// }