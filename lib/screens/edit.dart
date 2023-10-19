import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/controller/operation_controller/operation_controller.dart';
import 'package:notes/utils/confirm_dialog.dart';
import 'package:notes/utils/responsive.dart';
import 'package:notes/utils/style.dart';

import '../models/note_model.dart';

class EditScreen extends StatefulWidget {
  final Datum? note;
  final bool isNew;
  const EditScreen({super.key, this.note, this.isNew = false});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  var operationController = Get.put(OperationController());
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  var editEnable = false.obs;

  @override
  void initState() {
    editEnable(widget.isNew);
    if (widget.note != null) {
      titleController = TextEditingController(text: widget.note!.title);
      contentController = TextEditingController(text: widget.note!.description);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: () async {
          if (operationController.isloading.value) {
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade900,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  if (operationController.isloading.isFalse) {
                    Get.back();
                  }
                },
                padding: const EdgeInsets.all(0),
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade800.withOpacity(.8),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                )),
            actions: [
              (editEnable.isFalse)
                  ? IconButton(
                      onPressed: () {
                        editEnable(true);
                      },
                      padding: const EdgeInsets.all(0),
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade800.withOpacity(.8),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ))
                  : IconButton(
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        confirmDialog(context, (isAgree) {
                          if (isAgree) {
                            if (widget.isNew) {
                              operationController
                                  .addNote(
                                      title: titleController.text,
                                      desc: contentController.text)
                                  .then((value) => Get.back());
                            } else {
                              operationController
                                  .updateNote(
                                    title: titleController.text,
                                    desc: contentController.text,
                                    id: widget.note!.id,
                                  )
                                  .then((value) => Get.back());
                            }
                          }
                        });
                      },
                      padding: const EdgeInsets.all(0),
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade800.withOpacity(.8),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                      )),
              SizedBox(
                width: 1.wp,
              )
            ],
          ),
          body: Obx(() {
            return Padding(
              padding: EdgeInsets.all(1.hp),
              child: Column(children: [
                if (operationController.isloading.value)
                  const LinearProgressIndicator(),
                Expanded(
                    child: ListView(
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white, fontSize: 30),
                      readOnly: editEnable.isFalse,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title',
                          hintStyle: content.copyWith(
                              color: Colors.grey, fontSize: 30)),
                    ),
                    TextField(
                      controller: contentController,
                      style: content.copyWith(
                        color: Colors.white,
                      ),
                      maxLines: null,
                      readOnly: editEnable.isFalse,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type something here',
                          hintStyle: content.copyWith(
                            color: Colors.grey,
                          )),
                    ),
                  ],
                ))
              ]),
            );
          }),
        ),
      );
    });
  }
}
