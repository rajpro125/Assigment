import 'dart:developer';
import 'package:assignment_raj/Component/calendar_widget.dart';
import 'package:assignment_raj/Controller/employee.dart';
import 'package:assignment_raj/model/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

enum DateOption {
  today,
  nextMonday,
  nextTuesday,
  afterOneWeek,
}

class EmployeeDetailScreen extends StatefulWidget {
  const EmployeeDetailScreen({super.key});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController();
  String? selectedRole;
  DateTime? selectedDate;
  DateTime? lastDate;
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Add Employee Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          16.heightBox,
          TextFormField(
            controller: nameController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Employee name',
              hintStyle:const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.person_outline, color: Colors.blue),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ).px12(),
          20.heightBox,
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus(); // Hide the keyboard
              showRoleSelection(context);
            },
            child: InputDecorator(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.work_outline, color: Colors.blue),
                suffixIcon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Colors.blue,
                  size: 35,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              child: Text(selectedRole ?? 'Select role',style: selectedRole!=null?const TextStyle(): const TextStyle(color: Colors.grey) ),
            ),
          ).px12(),
          20.heightBox,
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_outlined,
                      color: Colors.blue,
                    ),
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus(); // Hide the keyboard
                        _showCustomDatePickerDialog(context, callBack: (v) {
                          selectedDate = v;
                          setState(() {});
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            selectedDate == null
                                ? "Today"
                                : selectedDate!.day.toString() ==
                                DateFormat("d").format(DateTime.now())
                                ? "Today"
                                : DateFormat('dd MMM y').format(selectedDate!),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).px12(),
              ).expand(),
              SvgPicture.asset('assets/vector.svg').p12(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_outlined,
                      color: Colors.blue,
                    ),
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus(); // Hide the keyboard
                        _showCustomDatePickerDialog(
                          context,
                          isLastDate: true,
                          callBack: (v) {
                            if (v != null) {
                              setState(() {
                                if (selectedDate == null ||
                                    v.isAfter(selectedDate!)) {
                                  lastDate = v;
                                } else {
                                  var snackBar = const SnackBar(content: Text(
                                      'Selected date cannot be the same.'));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snackBar);
                                }
                              });
                            }
                          },
                        );
                      },
                      child: Text(
                        lastDate == null
                            ? "No date"
                            : lastDate!.day.toString() == DateFormat("d")
                            .format(DateTime.now()) ? "Today" : DateFormat(
                            'dd MMM y').format(lastDate!),
                        style: lastDate == null
                            ? const TextStyle(color: Colors.grey)
                            : const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ).px12(),
              ).expand(),
            ],
          ).px12(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Divider(
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xffEDF8FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: 'Cancel'.text.medium
                          .size(14)
                          .sky500
                          .make(),
                    ),
                    15.widthBox,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      onPressed: saveEmployee,
                      child: 'Save'.text.medium.size(14).make(),
                    ),
                  ],
                ).px12()
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom Dialog Sheet
  void showRoleSelection(BuildContext context) {
    final List<String> roles = [
      'Product Designer',
      'Flutter Developer',
      'QA Tester',
      'Product Owner',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: roles.length,
            itemBuilder: (context, index) {
              final role = roles[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  5.heightBox,
                  role.text.size(16).makeCentered().onTap(() {
                    setState(() {
                      selectedRole = role;
                    });
                    Navigator.pop(context);
                  }).p12(),
                  const Divider(),
                ],
              );
            },
          ),
        );
      },
    );
  }

  /// Show Dialog DatePicker
  _showCustomDatePickerDialog(BuildContext context,
      {Function(DateTime?)? callBack, bool isLastDate = false}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.only(left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0), // Adjust the radius as needed
          ),
          content: SizedBox(
            // height: 475,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.9,
            child: CalendarWidget(
                selectedDate: selectedDate ?? DateTime.now(),
                callBack: callBack,
                isLastDate: isLastDate),
          ),
        );
      },
    );
  }

  /// Save Employee Data
  Future<void> saveEmployee() async {
    log("nameController   ${nameController.text}");
    log("selectedRole   $selectedRole");
    log("selectedDate   ${selectedDate.toString()}");
    log("selectedDate   ${lastDate == null ? "" : lastDate.toString()}");

    if (mounted) {
      final name = nameController.text;
      final role = selectedRole ?? ''; // Ensure a default value for role
      final dateOfEmployment = selectedDate != null
          ? selectedDate.toString()
          : DateTime.now().toString();
      final endDateOfEmployment = lastDate == null ? "" : lastDate.toString();

      if (name.isNotEmpty) {
        final employee = Employee(
            name: name,
            role: role,
            dateOfEmployment: dateOfEmployment,
            id: DateTime
                .now()
                .microsecondsSinceEpoch,
            endDateOfEmployment: endDateOfEmployment);

        try {
          final employeeBloc = context.read<EmployeeBloc>();
          employeeBloc.addEmployee(employee);

          var snackBar = const SnackBar(
            content: Text('Employee data added successfully'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          Navigator.of(context).pop(); // Close the current screen after saving
        } catch (e) {
          var snackBar = const SnackBar(
            content: Text('Something went wrong. Please try again.'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        var snackBar = const SnackBar(
          content: Text('Enter Employee name'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

}
