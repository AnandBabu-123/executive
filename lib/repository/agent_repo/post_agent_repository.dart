
import '../../config/routes/app_url.dart';
import '../../network/dio_network/dio_client.dart';

import 'dart:io';
import 'package:dio/dio.dart';




class PostAgentRepository {
  final DioClient dioClient;

  PostAgentRepository(this.dioClient);

  Future<void> postAgent(FormData data) async {
    final response = await dioClient.dio.post(
      AppUrl.getAgents,
      data: data,
      options: Options(
        headers: {"Content-Type": "multipart/form-data"},
      ),
    );

    if (response.data["status"] != 200) {
      throw Exception(response.data["message"]);
    }
  }
}