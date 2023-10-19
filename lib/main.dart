import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:notes/screens/home.dart';
import 'package:notes/utils/toast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var valueListner = ValueNotifier(true);
  late StreamSubscription<InternetStatus> listener;

  @override
  void initState() {
    listener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          // The internet is now connected
          showToast(msg: 'The internet is now connected', isSuccess: true);
          valueListner.value = true;
          break;
        case InternetStatus.disconnected:
          valueListner.value = false;

          // The internet is now disconnected
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: [routeObserver],
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey.shade900,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber)),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        valueNotifier: valueListner,
      ),
    );
  }
}

// Register the RouteObserver as a navigation observer.
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
