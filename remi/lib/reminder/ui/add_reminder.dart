
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remi/reminder/Controllers/task_controller.dart';
import 'package:remi/reminder/Themes/theme.dart';
import 'package:remi/reminder/ui/widgets/button.dart';
import 'package:remi/reminder/ui/widgets/input_field.dart';
import 'package:intl/intl.dart';
import 'package:remi/reminder/models/task.dart';

class AddReminderPage extends StatefulWidget {
  const AddReminderPage({super.key});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  // int howManyWeeks = 1;
  // DateTime setDate = DateTime.now();
  // final NotifyHelper _notifications = NotifyHelper();

  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _selectedRepeat = "None";
  List<String> repeatlist =[
    "None",
    "Daily",
    "Weekly",
    "Monthly"
  ];

  // Future initNotifies() async => flutterLocalNotificationsPlugin =
  // await _notifications.initNotifies(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Add Reminder",
              style: headingStyle,),
              InputFields(title: "Medicine Name", hint: "Enter medicine name",controller: _titleController,),
              InputFields(title: "Description", hint: "Enter description", controller: _noteController,),
              InputFields(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                icon: const Icon(Icons.calendar_today_outlined),
                onPressed: (){
                    _getDateFromUser();
                },
              ),),
              InputFields(title: "Time", hint: _startTime,
              widget: IconButton(
                icon: const Icon(Icons.access_time_rounded,),
                onPressed: (){
                  _getTimeFromUser(isStartTime: true);
                },
              ),),
              InputFields(title: "Repeat", hint: _selectedRepeat,
              widget: DropdownButton(
                icon: const Icon(Icons.keyboard_arrow_down),
                iconSize: 30,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue){
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items:repeatlist.map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value ,style: const TextStyle(color: Colors.black),)
                    );
                  }
                  ).toList(),
              ),
              ),
              MyButton(label: "Save", onTap: ()=>_validateDate())
            ],
          ),
        ),
      ),
    );
  }
  _validateDate() {


    if(_titleController.text.isNotEmpty&& _noteController.text.isNotEmpty){
      _addTaskToDB();
      Get.back();
        //set the notification schneudele
      // for (int i = 0; i < howManyWeeks; i++) {
      //
      //     tz.initializeTimeZones();
      //     tz.local;
      //      _notifications.showNotification(_startTime, flutterLocalNotificationsPlugin);
      //   }


    }else if(_titleController.text.isEmpty||_noteController.text.isEmpty){
      Get.snackbar("Required", "All fields are required !",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      icon: const Icon(Icons.warning_amber_outlined,
      color: Colors.red,)
      );

    }

  }
  _addTaskToDB() async{
   int value = await _taskController.addTask(
       task: Task(
         title: _titleController.text,
         note: _noteController.text,
         date: DateFormat.yMd().format(_selectedDate),
         startTime: _startTime,
         repeat: _selectedRepeat,
         isCompleted: 0,
       )
   );
   print("My id is $value");
  }
  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: (){
          Get.back();

        },
        child: const Icon(Icons.arrow_back_ios,
          size: 20,
          color: Colors.black
        ),

      ),

    );
  }
  _getDateFromUser() async{
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime(2110)
    );
    if(pickerDate!=null){
      setState(() {
        _selectedDate = pickerDate;
      });
    }else{
      print("there is an error");
    }

  }
  _getTimeFromUser({required bool isStartTime}) async{
    var pickedTime = await _showTimePicker();
    String formatedTime = pickedTime.format(context);
    if(pickedTime==null){
      print("Time Canceled");
    }else if (isStartTime == true){
      setState(() {
        _startTime = formatedTime;
      });
    }
    else if(isStartTime == false){
      print("False");
    }
  }
  _showTimePicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime:TimeOfDay(

            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
                // .
        )
    );
  }



}
