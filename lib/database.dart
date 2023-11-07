import 'package:assignment_raj/model/employee_model.dart';
import 'package:hive/hive.dart';

class HiveDatabaseHelper {
  static final HiveDatabaseHelper _instance = HiveDatabaseHelper._();
  factory HiveDatabaseHelper() => _instance;

  HiveDatabaseHelper._();

  Future<Box<Employee>> getEmployeesBox() async {
    if (Hive.isBoxOpen('employees')) {
      return Hive.box<Employee>('employees');
    }
    return await Hive.openBox<Employee>('employees');
  }

  Future<int> insertEmployee(Employee employee) async {
    final box = await getEmployeesBox();
    return await box.add(employee);
  }

  Future<List<Employee>> getEmployees() async {
    final box = await getEmployeesBox();
    return box.values.toList();
  }

  // Future<void> deleteEmployee(int id) async {
  //   final box = await Hive.openBox<Employee>('employees');
  //   await box.delete(id);
  // }
  Future<void> deleteEmployee(int index) async {
    final box = await Hive.openBox<Employee>('employees');
    await box.deleteAt(index);
  }

  // Future<void> updateEmployee(int id, Employee updatedEmployee) async {
  //   final box = await getEmployeesBox();
  //
  //   // Check if the employee with the specified ID exists in the database
  //   if (box.containsKey(id)) {
  //     // Update the employee data with the new values
  //     await box.putAt(id, updatedEmployee);
  //   }
  // }
  Future<void> updateEmployee(int index, Employee updatedEmployee) async {
    final box = await getEmployeesBox();
      await box.putAt(index, updatedEmployee);
  }
}
