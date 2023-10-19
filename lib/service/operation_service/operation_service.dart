import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notes/constants/api_routes.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/utils/toast.dart';

class OperationService {
  static var client = http.Client();

  static var headers = {'Content-Type': 'application/json'};

  static Future<void> addNotess(
      {required String title, required String desc}) async {
    try {
      var json = {"title": title, "description": desc};
      var res = await client.post(Uri.parse(ApiRoutes.endPoint),
          body: jsonEncode(json), headers: headers);

      print('res-->${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        showToast(msg: 'Notes added Successfully.', isSuccess: true);
        return;
      } else {
        showToast(msg: 'Notes added Failed.', isSuccess: false);
        return;
      }
    } catch (e) {
      showToast(msg: e.toString(), isSuccess: false);
      return;
    }
  }

  static Future<void> updateNotess(
      {required String title, required String desc, required int id}) async {
    try {
      var json = {"title": title, "description": desc};
      var res = await client.put(Uri.parse("${ApiRoutes.endPoint}/$id"),
          body: jsonEncode(json), headers: headers);

      print('res-->${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        showToast(msg: 'Notes update Successfully.', isSuccess: true);
        return;
      } else {
        showToast(msg: 'Notes update Failed.', isSuccess: false);
        return;
      }
    } catch (e) {
      showToast(msg: e.toString(), isSuccess: false);
      return;
    }
  }

  static Future<void> deleNotes({required int id}) async {
    try {
      var res = await client.delete(Uri.parse("${ApiRoutes.endPoint}/$id"),
          headers: headers);

      print('res-->${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        showToast(msg: 'Notes Deleted Successfully.', isSuccess: true);
        return;
      } else {
        showToast(msg: 'Notes Deleted Failed.', isSuccess: false);
        return;
      }
    } catch (e) {
      showToast(msg: e.toString(), isSuccess: false);
      return;
    }
  }
}
