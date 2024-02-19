import 'package:flutter/material.dart';
import 'package:remi/reminder/Controllers/task_controller.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:remi/reminder/services/notification_service.dart';
import 'package:remi/reminder/ui/add_reminder.dart';
import 'package:remi/reminder/ui/widgets/button.dart';
import 'package:remi/reminder/ui/widgets/task_tile.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../Themes/theme.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  @override
  void initState(){
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.requestAndroidPermissions();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        _addTaskBar(),
        _addDateBar(),
        const SizedBox(
          height: 10,
        ),
        _showTasks()

      ],
        ),
    );
  }
  _showTasks(){
    return Expanded(
      child: Obx((){
        return ListView.builder(
          itemCount: _taskController.taskList.length,
            itemBuilder: (_, index){
            print(_taskController.taskList.length);
            Task task = _taskController.taskList[index];
            print(task.toJson());
            print("task.startTime: ${task.startTime.toString()}");
                if (task.repeat == 'Daily') {
                  print(task.startTime.toString());
                  DateTime date = DateFormat.jm().parse(
                      task.startTime.toString());
                  var myTime = DateFormat("HH:mm").format(date);
                  print("myTime: $myTime");
                  notifyHelper.scheduledNotification(
                      int.parse(myTime.toString().split(":")[0]),
                      int.parse(myTime.toString().split(":")[1])
                  );
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, task);
                                  print("tapped");
                                },
                                child: TaskTile(task),

                              )
                            ],
                          ),
                        ),
                      ));
                }
                if (task.date == DateFormat.yMd().format(_selectedDate)) {
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, task);
                                  print("tapped");
                                },
                                child: TaskTile(task),

                              )
                            ],
                          ),
                        ),
                      ));
                } else {
                  return Container();
                }
            //   }
            // }


        });
      }),
    );
  }
  _showBottomSheet(BuildContext context , Task task){
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top:4),
        height: task.isCompleted == 1?
            MediaQuery.of(context).size.height*0.24:
            MediaQuery.of(context).size.height*0.32,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:Colors.black,
              )
            ),
            task.isCompleted==1
            ?Container()
                : _bottomSheetButton(
              label: "Delete Reminder",
              onTap:(){
                _taskController.delete(task);
                _taskController.getTasks();
                  Get.back();
            }, clr:Colors.red[300]!,
              context: context,
            ),
            const SizedBox(
              height: 20,
            ),
            _bottomSheetButton(
              label: "Close",
              onTap:(){
                Get.back();
              }, clr:Colors.grey,
              isClose:true,
              context: context,
            )
          ],
        ),
      )
    );
  }
  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
    }){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,

        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose==true?const Color.fromRGBO(31,182,246,1):const Color.fromRGBO(31,182,246,1)
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true?Colors.white:const Color.fromRGBO(31,182,246,1),
        ),
        child: Center(
          child: Text(
            label,
            style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );

  }
  _addDateBar(){
    return Container(
      margin: const EdgeInsets.only(top: 10,left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 90,
        width: 70,
        initialSelectedDate: DateTime.now(),
        selectionColor: const Color.fromRGBO(31,182,246,1),
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            )
        ),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            )
        ),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            )
        ),
        onDateChange: (date){
          setState(() {
            _selectedDate=date;
          });
        },

      ),
    );
  }
  _addTaskBar(){
    return Container(
      margin: const EdgeInsets.only(left: 20,right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                    style: subHeadingStyle),
                Text("Today",
                  style: headingStyle,
                )
              ],
            ),
          ),
          MyButton(label: "+ Add Reminder", onTap: () async{
             await Get.to(()=>const AddReminderPage());
              _taskController.getTasks();

          }
          )
        ],
      ),
    );
  }
  // _appBar(){
  //    return AppBar(
  //      leading: GestureDetector(
  //        onTap: (){
  //          notifyHelper.displayNotification(
  //            title:"Hello",
  //
  //          );
  //          // notifyHelper.scheduleNotification();
  //        },
  //      ),
  //    );
  }


