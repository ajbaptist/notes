import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/utils/style.dart';

Future<dynamic> confirmDialog(
    BuildContext context, Function(bool isAgree) onClick) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          icon: const Icon(
            Icons.info,
            color: Colors.grey,
          ),
          title: Text(
            'Save changes ?',
            style: content.copyWith(color: Colors.white),
          ),
          content:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ElevatedButton(
                onPressed: () {
                  onClick(true);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                child: SizedBox(
                  width: 60,
                  child: Text(
                    'Save',
                    textAlign: TextAlign.center,
                    style: content.copyWith(color: Colors.white),
                  ),
                )),
            ElevatedButton(
                onPressed: () {
                  onClick(false);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                child: SizedBox(
                  width: 60,
                  child: Text(
                    'Discard',
                    textAlign: TextAlign.center,
                    style: content.copyWith(color: Colors.white),
                  ),
                )),
          ]),
        );
      });
}
