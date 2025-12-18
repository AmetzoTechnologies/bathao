import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';

final baseImageUrl = 'https://api.bathaocalls.com';

class ApiService extends GetConnect {
  ApiService() {
    baseUrl = "https://api.bathaocalls.com/";
  }

  Future<Response> getRequest(String endpoint, {String? bearerToken}) async {
    try {
      return await get(endpoint, headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postRequest(
      String endpoint,
      dynamic data, {
        String? bearerToken,
        bool isMultipart = false,
      }) async {
    try {
      final headers = {
        if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
      };

      if (isMultipart && data is Map<String, dynamic>) {
        final formData = _buildMultipart(data);
        return await post(endpoint, formData, headers: headers);
      }

      return await post(endpoint, data, headers: headers);

    } catch (e) {
      print("POST ERROR: $e");
      rethrow;
    }
  }

  Future<Response> putRequest(
      String endpoint,
      dynamic data, {
        String? bearerToken,
        bool isMultipart = false,
      }) async {
    try {
      final headers = {
        if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
      };

      if (isMultipart && data is Map<String, dynamic>) {
        final formData = _buildMultipart(data);
        return await put(endpoint, formData, headers: headers);
      }

      return await put(endpoint, data, headers: headers);

    } catch (e) {
      print("PUT ERROR: $e");
      rethrow;
    }
  }

  // FIXED MULTIPART HANDLER
  FormData _buildMultipart(Map<String, dynamic> data) {
    final form = FormData({});

    data.forEach((key, value) {
      if (value == null) return;

      if (value is File) {
        form.files.add(
          MapEntry(
            key,
            MultipartFile(value, filename: value.path.split('/').last),
          ),
        );
      }

      else if (value is List) {
        for (int i = 0; i < value.length; i++) {
          form.fields.add(MapEntry("$key[$i]", value[i].toString()));
        }
      }

      else {
        form.fields.add(MapEntry(key, value.toString()));
      }
    });

    return form;
  }
}
