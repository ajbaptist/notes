import 'package:get/get.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/service/home_service/home_service.dart';

class HomeController extends GetxController {
  var data = <Datum>[].obs;
  var isloading = false.obs;

  getData() async {
    data.clear();
    isloading(true);
    var res = await HomeService.getData();

    isloading(false);

    if (res != null) {
      data.value = res.data;
    }
  }
}
