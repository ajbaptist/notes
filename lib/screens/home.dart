import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notes/controller/home_controller/home_controller.dart';
import 'package:notes/service/operation_service/operation_service.dart';
import 'package:notes/utils/responsive.dart';
import 'package:notes/utils/style.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../constants/colors.dart';
import '../main.dart';
import '../models/note_model.dart';
import 'edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.valueNotifier});

  final ValueNotifier<bool> valueNotifier;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  var homeController = Get.put(HomeController());
  var refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    homeController.getData();
    widget.valueNotifier.addListener(() {
      homeController.getData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    widget.valueNotifier.removeListener(() {});
    super.dispose();
  }

  @override
  void didPopNext() {
    homeController.getData();
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text(
          'Notes',
          style: heading,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              padding: const EdgeInsets.all(0),
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.shade800.withOpacity(.8),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(
                  Icons.info,
                  color: Colors.white,
                ),
              ))
        ],
      ),
      body: Obx(() {
        if (homeController.isloading.value && homeController.data.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (homeController.isloading.isFalse &&
            homeController.data.isEmpty) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage("assets/rafiki.png")),
              SizedBox(
                height: 0.5.hp,
              ),
              Text(
                "Create your first note !",
                style: content.copyWith(color: Colors.white),
              ),
            ],
          ));
        } else {
          return SmartRefresher(
            controller: refreshController,
            onRefresh: () async {
              await homeController.getData();
              refreshController.refreshCompleted();
            },
            child: ListView.builder(
              padding: EdgeInsets.all(1.hp),
              itemCount: homeController.data.length,
              itemBuilder: (context, index) {
                var data = homeController.data[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => EditScreen(note: data));
                  },
                  child: Dismissible(
                    key: ObjectKey(UniqueKey()),
                    onDismissed: (direction) {
                      homeController.data.removeWhere(
                        (element) => element.id == data.id,
                      );
                      OperationService.deleNotes(id: data.id);
                    },
                    background: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(8),
                      child: const Icon(Icons.delete),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 20),
                        color: getRandomColor(),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.all(3.hp),
                          child: Text(
                            data.description,
                            style: content,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.to(const EditScreen(
            isNew: true,
          ));
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 38,
        ),
      ),
    );
  }
}
