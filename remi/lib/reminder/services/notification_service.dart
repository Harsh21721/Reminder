import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

class NotifyHelper{
  FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  initializeNotification() async {

    _configureLocalTimezone();

    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings("001");

    final InitializationSettings initializationSettings =
    InitializationSettings(
        iOS: initializationSettingsIOS,
        android: initializationSettingsAndroid
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: selectNotification
    );
    return flutterLocalNotificationsPlugin;
  }

  displayNotification({required String title, required String body,required int hour,required int minutes}) async {
    print("doing test");
    var androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        // 'your channel description',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      _convertTime(hour, minutes) as String?,
      'You change your theme',
      // 'You changed your theme back !',
      // _convertTime(hour, minutes),
      platformChannelSpecifics,
      // payload: 'It could be anything you pass',
    );
  }

  scheduledNotification(int hour, int minutes) async {
    print("notification is running");
    print("Hour:$hour,Minutes:$minutes");
    var androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
        '001', 'oslo',
        // 'your channel description',
        importance: Importance.max, priority: Priority.high,playSound: true,
    enableVibration: true,groupAlertBehavior: GroupAlertBehavior.all, );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);


    await flutterLocalNotificationsPlugin.zonedSchedule(
        001,
        'scheduled title',
        'theme changes 5 seconds ago',
        _convertTime(hour, minutes) ,
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      // const NotificationDetails(
      //     android: AndroidNotificationDetails('your_chosen_channel_id',
      //         'your channel name',
      //         // 'your channel description'
      //     )),
      platformChannelSpecifics,


      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time
    );
    print("Converted Time:${_convertTime(hour, minutes)}");


  }
  // showNotification(  startTime, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'scheduled title',
  //       'theme changes 5 seconds ago',
  //       tz.TZDateTime.now(tz.local).add(Duration(milliseconds: startTime)),
  //       const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //               'medicines_id', 'medicines',
  //               // 'medicines_notification_channel',
  //               importance: Importance.high,
  //               priority: Priority.high,
  //               color: Colors.cyanAccent)),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime);
  // }


  tz.TZDateTime _convertTime(int hour, int minutes){
    final tz.TZDateTime now = tz.TZDateTime.now(tz.getLocation('Asia/Kolkata'));
    // final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print(tz.TZDateTime.now(tz.getLocation('Asia/Kolkata')));

    tz.TZDateTime scheduleDate = tz.TZDateTime(tz.getLocation('Asia/Kolkata'), now.year,now.month, now.day,hour, minutes);
    if(scheduleDate.isBefore(now)){

      scheduleDate = scheduleDate.add(const Duration (days: 1));
      print("scheduledate:$scheduleDate") ;
    }
    return scheduleDate;

  }

  Future<void> _configureLocalTimezone() async{
    initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
    print(FlutterNativeTimezone.getLocalTimezone());
    print("configuring done");
  }


  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  void requestAndroidPermissions(){
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission(

    );
  }



  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  //  showDialog(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Text('title'),
  //       content: Text('body'),
  //       actions: [
  //         CupertinoDialogAction(
  //           isDefaultAction: true,
  //           child: Text('Ok'),
  //           onPressed: () async {
  //             Navigator.of(context, rootNavigator: true).pop();
  //             await Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => ,
  //               ),
  //             );
  //           },
  //         )
  //       ],
  //     ),
  //   );
  //   Get.dialog(const Text("Welcome to flutter"));
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(()=>Container());
  }

}