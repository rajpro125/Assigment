import 'package:assignment_raj/Controller/employee.dart';
import 'package:assignment_raj/Screen/employee_list.dart';
import 'package:assignment_raj/model/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(EmployeeAdapter());

  await Hive.openBox<Employee>("employees");

  runApp(
    MultiProvider(
      providers: [
        BlocProvider<EmployeeBloc>(
          create: (context) => EmployeeBloc(),
        ),
        // Other providers if any
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final employeeBloc = context.read<EmployeeBloc>();
    // Call the getEmployees method to fetch data when the app starts
    employeeBloc.getEmployees();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EmployeeListScreen(),
    );
  }
}
