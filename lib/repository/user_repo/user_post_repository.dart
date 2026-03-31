
import 'dart:io';

import 'package:dio/dio.dart';

import '../../config/routes/app_url.dart';
import '../../network/dio_network/dio_client.dart';

class UserPostRepository {
  final DioClient dioClient;
  UserPostRepository(this.dioClient);

  Future<void> postUser({
    required int userId,
    required String name,
    required String email,
    required String mobile,
    required String gender,
    required String dob,
    required int bloodGroupId,
    required int coverageCategoryId,
    File? image,
  }) async {
    FormData formData = FormData.fromMap({
      "user_id": userId,
      "name": name,
      "email": email,
      "mobile": mobile,
      "gender": gender,
      "dob": dob,
      "blood_group": bloodGroupId,
      "coverage_category": coverageCategoryId,
      if (image != null) "image": await MultipartFile.fromFile(image.path, filename: image.path.split("/").last),
    });

    final response = await dioClient.post(AppUrl.getUsers, data: formData);

    if (response["status"] != 200) throw response["message"];
  }
}