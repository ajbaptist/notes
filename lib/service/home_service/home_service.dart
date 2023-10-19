import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes/constants/api_routes.dart';
import 'package:notes/models/note_model.dart';

import '../../utils/toast.dart';

class HomeService {
  static var client = http.Client();

  static Future<NotesModel?> getData() async {
    try {
      var res = await client.get(Uri.parse(ApiRoutes.endPoint));

      print('res-->${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        return notesModelFromJson(res.body);
      } else {
        return null;
      }
    } catch (e) {
      showToast(msg: e.toString(), isSuccess: false);
      return null;
    }
  }
}
