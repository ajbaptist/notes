import 'package:get/get.dart';
import 'package:notes/service/operation_service/operation_service.dart';

class OperationController extends GetxController {
  var isloading = false.obs;
  Future<void> updateNote(
      {required String title, required String desc, required int id}) async {
    isloading(true);
    await OperationService.updateNotess(title: title, desc: desc, id: id);
    isloading(false);
  }

  Future<void> addNote({required String title, required String desc}) async {
    isloading(true);
    await OperationService.addNotess(
      title: title,
      desc: desc,
    );
    isloading(false);
  }
}
