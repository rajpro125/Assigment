import 'package:assignment_raj/database.dart';
import 'package:assignment_raj/model/employee_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeBloc extends Cubit<List<Employee>> {
  final dbHelper = HiveDatabaseHelper();

  EmployeeBloc() : super([]);

  // Fetch employees from the database and update the state.
  void getEmployees() async {
    final employees = await dbHelper.getEmployees();
    emit(employees);
  }

  // Insert an employee into the database.
  void addEmployee(Employee employee) async {
    await dbHelper.insertEmployee(employee);
    getEmployees(); // Refresh the list of employees.
  }

  // Delete an employee from the database by ID.
  // void deleteEmployee(int id) async {
  //   await dbHelper.deleteEmployee(id);
  //   getEmployees(); // Refresh the list of employees.
  // }
  void deleteEmployee(index) async {
    await dbHelper.deleteEmployee(index);
    getEmployees(); // Refresh the list of employees.
  }

  // Update an employee in the database by ID.
  // void updateEmployee(int id, Employee updatedEmployee) async {
  //   await dbHelper.updateEmployee(id, updatedEmployee);
  //   getEmployees(); // Refresh the list of employees.
  // }
  void updateEmployee(int index, Employee updatedEmployee) async {
    await dbHelper.updateEmployee(index, updatedEmployee);
    getEmployees(); // Refresh the list of employees.
  }

}

