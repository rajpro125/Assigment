// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:velocity_x/velocity_x.dart';

class CalendarWidget extends StatefulWidget {
  DateTime? selectedDate;
  final Function(DateTime?)? callBack;
  final bool? isLastDate;

  CalendarWidget(
      {super.key, this.selectedDate, this.callBack, this.isLastDate = false});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  PageController pageController = PageController();
  DateTime focusedDay = DateTime.now();

  int selectedIndex = 0;

  String headerText = '';

  void updateHeaderText() {
    setState(() {
      headerText = DateFormat('MMMM y').format(focusedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Top two buttons
          widget.isLastDate == true
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // Add your button functionality here
                        widget.selectedDate = DateTime.now();
                        selectedIndex = 0;
                        setState(() {});
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              selectedIndex == 0
                                  ? Colors.blueAccent
                                  : const Color(0xffEDF8FF)),
                          elevation: const MaterialStatePropertyAll(0)),
                      child: Text('Today',
                          style: TextStyle(
                            color:
                                selectedIndex == 0 ? Colors.white : Colors.blue,
                          )),
                    ).expand(),
                    10.widthBox,
                    ElevatedButton(
                      onPressed: () {
                        // Add your button functionality here
                        widget.selectedDate = getNextMonday();
                        selectedIndex = 1;
                        setState(() {});
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              selectedIndex == 1
                                  ? Colors.blueAccent
                                  : const Color(0xffEDF8FF)),
                          elevation: const MaterialStatePropertyAll(0)),
                      child: Text('Next Monday',
                          style: TextStyle(
                            color:
                                selectedIndex == 1 ? Colors.white : Colors.blue,
                          )),
                    ).expand(),
                  ],
                ),
          // Below two buttons
          widget.isLastDate == true
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        widget.selectedDate = getNextTuesday();
                        selectedIndex = 2;

                        setState(() {});
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              selectedIndex == 2
                                  ? Colors.blueAccent
                                  : const Color(0xffEDF8FF)),
                          elevation: const MaterialStatePropertyAll(0)),
                      child: Text('Next Tuesday',
                          style: TextStyle(
                            color:
                                selectedIndex == 2 ? Colors.white : Colors.blue,
                          )),
                    ).expand(),
                    10.widthBox,
                    ElevatedButton(
                      onPressed: () {
                        // Add your button functionality here
                        widget.selectedDate = getAfterOneWeek();
                        selectedIndex = 3;
                        setState(() {});
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              selectedIndex == 3
                                  ? Colors.blueAccent
                                  : const Color(0xffEDF8FF)),
                          elevation: const MaterialStatePropertyAll(0)),
                      child: Text('After 1 Week',
                          style: TextStyle(
                            color:
                                selectedIndex == 3 ? Colors.white : Colors.blue,
                          )),
                    ).expand(),
                  ],
                ),
          widget.isLastDate == true
              ? Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add your button functionality here
                        widget.selectedDate = DateTime.now();
                        selectedIndex = 0;
                        setState(() {});
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              selectedIndex == 0
                                  ? Colors.blueAccent
                                  : const Color(0xffEDF8FF)),
                          elevation: const MaterialStatePropertyAll(0)),
                      child: Text('No Date',
                          style: TextStyle(
                            color:
                                selectedIndex == 0 ? Colors.white : Colors.blue,
                          )),
                    ).expand(),
                    10.widthBox,
                    ElevatedButton(
                      onPressed: () {
                        // Add your button functionality here
                        widget.selectedDate = DateTime.now();
                        selectedIndex = 1;
                        setState(() {});
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              selectedIndex == 1
                                  ? Colors.blueAccent
                                  : const Color(0xffEDF8FF)),
                          elevation: const MaterialStatePropertyAll(0)),
                      child: Text('Today',
                          style: TextStyle(
                            color:
                                selectedIndex == 1 ? Colors.white : Colors.blue,
                          )),
                    ).expand(),
                  ],
                )
              : const SizedBox(),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                      focusedDay =
                          focusedDay.subtract(const Duration(days: 30));
                      updateHeaderText();
                    },
                    icon: const Icon(
                      Icons.arrow_left_rounded,
                      color: Color(0xff949C9E),
                    ),
                  ),
                  Text(
                    headerText == ''
                        ? DateFormat('MMMM y').format(widget.selectedDate!)
                        : headerText,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                      focusedDay = focusedDay.add(const Duration(days: 30));
                      updateHeaderText();
                    },
                    icon: const Icon(
                      Icons.arrow_right_rounded,
                      color: Color(0xff949C9E),
                    ),
                  ),
                ],
              ),
              TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: focusedDay,
                selectedDayPredicate: (DateTime date) {
                  return isSameDay(widget.selectedDate, date);
                },
                onDaySelected: (DateTime selectDay, DateTime focusDay) {
                  setState((){
                    widget.selectedDate = selectDay;
                    focusedDay = focusDay;
                    updateHeaderText();
                  });
                  // log("-=0=-0=-0=0=-onDaySelected0  ${selectDay}");

                },

                 onPageChanged: (fs) {
                   focusedDay = fs  ;
                   // focusedDay = focusedDay.add(const Duration(days: 30));
                   headerText = DateFormat('MMMM y').format(fs);
                   // headerText = DateFormat('MMMM y').format(focusedDay).toString();
                   setState(() {});
                 // log("-=0=-0=-0=0=-0  ${fs}");
                 },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    // color: Colors.blue,
                    border: Border.all(color: Colors.blueAccent, width: 1),
                    shape: BoxShape.circle,
                    // borderRadius: BorderRadius.circular(30.0),
                  ),
                  todayTextStyle: const TextStyle(color: Colors.blue),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(color: Colors.white),
                ),
                onCalendarCreated: (controller) => pageController = controller,
                headerVisible: false,
              ),
            ],
          ),
          // Divider
          const Divider(),

          // Cancel and Save buttons
          Row(
            children: [
              // Display selected date
              const Icon(
                Icons.event_outlined,
                color: Colors.blue,
              ),
              const SizedBox(
                width: 4,
              ),

              Text(
                widget.selectedDate!.day.toString() ==
                        DateFormat("d").format(DateTime.now())
                    ? widget.isLastDate == true
                        ? selectedIndex == 0
                            ? "No Date"
                            : "Today"
                        : DateFormat('dd MMM y').format(widget.selectedDate!)
                    : DateFormat('dd MMM y').format(widget.selectedDate!),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xffEDF8FF),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: 'Cancel'.text.medium.size(14).sky500.make(),
              ),
              const SizedBox(
                width: 12,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 0,
                ),
                onPressed: () {
                  // saveEmployee();
                  if (widget.isLastDate==false) {
                    widget.callBack!(widget.selectedDate!);

                  }  else{
                    // if(selectedIndex==0){
                    //   widget.selectedDate=null;
                    // }
                    widget.callBack!(widget.selectedDate);

                  }
                  Navigator.of(context).pop();
                },
                child: 'Save'.text.medium.size(14).make(),
              ),
            ],
          )
        ],
      ),
    );
  }

  DateTime getNextMonday() {
    // final today = DateTime.now();
    final today = widget.selectedDate!;
    final daysUntilMonday = 1 - today.weekday;
    if (daysUntilMonday <= 0) {
      return today.add(Duration(days: (7 - today.weekday) + 1));
    } else {
      return today.add(Duration(days: daysUntilMonday));
    }
  }

  DateTime getNextTuesday() {
    // final today = DateTime.now();
    final today = widget.selectedDate!;
    final daysUntilTuesday = 2 - today.weekday;
    if (daysUntilTuesday <= 0) {
      return today.add(Duration(days: (7 - today.weekday) + 2));
    } else {
      return today.add(Duration(days: daysUntilTuesday));
    }
  }

  DateTime getAfterOneWeek() {
    final today = widget.selectedDate!;
    return today.add(const Duration(days: 7));
  }
}
