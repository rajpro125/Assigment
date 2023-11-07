import 'package:assignment_raj/Controller/employee.dart';
import 'package:assignment_raj/Screen/add_employee_details.dart';
import 'package:assignment_raj/Screen/edit_employee_details.dart';
import 'package:assignment_raj/model/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Employee List'),
      ),
      body: BlocBuilder<EmployeeBloc, List<Employee>>(
        builder: (context, employeeList) {
          return employeeList.isEmpty
              ? SvgPicture.asset(
                  'assets/no_item.svg',
                  width: 261.79,
                  height: 244.38,
                ).centered()
              : SingleChildScrollView(
                child: Column(
                    children: [
                      Container(
                        height: 50,
                        color: Colors.grey.withOpacity(0.2),
                        padding: const EdgeInsets.only(left: 24),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Current employees",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      ListView.builder(

                          itemCount: employeeList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                            final employee = employeeList[index];
                            return DateTime.parse(employee.dateOfEmployment!)
                                        .day
                                        .toString() !=
                                    DateFormat("d").format(DateTime.now())
                                ? const SizedBox()
                                : listData(employee, index, context);
                          },
                        ),

                      Container(
                        height: 50,
                        color: Colors.grey.withOpacity(0.2),
                        padding: const EdgeInsets.only(left: 24),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Previous employees",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      ListView.builder(
                          itemCount: employeeList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final employee = employeeList[index];
                            return DateTime.parse(employee.dateOfEmployment!)
                                .day
                                .toString() ==
                                DateFormat("d").format(DateTime.now())
                                ? const SizedBox()
                                : listData(employee, index, context);
                          },
                        ),

                    ],
                  ),
              );
        },
      ),
      floatingActionButton: Theme(
        data: ThemeData(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8.0), // Set the shape to a circle
            ),
            backgroundColor:
                Colors.blue, // Set the background color of FloatingActionButton
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to the employee detail screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EmployeeDetailScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

   listData(Employee employee, int index, BuildContext context) {
    return Column(
      children: [
        Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  deleteEmployee(employee, index);
                  // employeeList.removeAt(index);
                  setState(() {});
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete_outline_rounded,
              ),
            ],
          ),
          child: Column(
            children: [
              ListTile(
                title: employee.name!.text.size(16).medium.make(),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    employee.role!.text.size(14).normal.make(),
                    6.heightBox,
                    Text(
                        DateFormat('dd MMMM y').format(DateTime.parse(employee.dateOfEmployment!))),
                    // employee.dateOfEmployment!.text
                    //     .size(12)
                    //     .normal
                    //     .make(),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EmployeeEditDetails(employee: employee, index: index),
                    ),
                  );
                },
              ),
              const Divider()
            ],
          ),
        ),
      ],
    );
  }

  void deleteEmployee(Employee employee, index) {
    final employeeBloc = BlocProvider.of<EmployeeBloc>(context);

    // Create a copy of the employee list before the deletion
    final List<Employee> previousEmployeeList = List.of(employeeBloc.state);
    // log("-=0=-0=-0=-0=-0-=0=-0=0=0=-0-=0-=0-=0=-0 ${employee.name!}");

    // Check if employee.id is not null before proceeding
    if (employee.id != null) {
      // Delete the employee from the list
      // employeeBloc.deleteEmployee(employee.id!);
      employeeBloc.deleteEmployee(index);
    }

    final snackBar = SnackBar(
      content: const Text('Employee data has been deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Restore the previous list
          employeeBloc.emit(previousEmployeeList);

          // Add the employee back to the database
          if (employee.id != null) {
            employeeBloc.addEmployee(employee);
          }

          // Optionally, you can also update your UI or show a confirmation message for the restoration.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Employee data has been restored'),
            ),
          );
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
