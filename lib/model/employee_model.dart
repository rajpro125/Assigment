import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee_model.g.dart';

@JsonSerializable()

@HiveType(typeId: 0)
class Employee {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? role;

  @HiveField(3)
  String? dateOfEmployment;

  @HiveField(4)
  String? endDateOfEmployment;

  // Json
  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeToJson(this);

  Employee({
     this.id,
    required this.name,
    required this.role,
    required this.dateOfEmployment,
    required this.endDateOfEmployment,
  });

  Employee copyWith({
    int? id,
    String? name,
    String? role,
    String? dateOfEmployment,
    String? endDateOfEmployment,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      dateOfEmployment: dateOfEmployment ?? this.dateOfEmployment,
      endDateOfEmployment: endDateOfEmployment ?? this.endDateOfEmployment,
    );
  }
}
