

class PastSanctionLeaveDetailsModel{
  int leave_id;
  String employee_name;
  String hrms_employee_id;
  String? leave_type;
  String? leave_type2;
  String? leave_type3;
  String? leave_from;
  String? leave_from_fn_an;
  String? leave_to;
  String? leave_to2;
  String? leave_to3;
  String? leave_to_fn_an;
  String? leave_to_fn_an2;
  String? leave_to_fn_an3;
  double? number_of_days;
  double? number_of_days2;
  double? number_of_days3;
  String? hq_leave;
  String? hq_leave_from;
  String? hq_leave_from_time;
  String? hq_leave_to;
  String? hq_leave_to_time;
  String? ex_india_leave;
  String? ex_india_leave_from;
  String? ex_india_leave_from_fn_an;
  String? ex_india_leave_to;
  String? ex_india_leave_to_fn_an;
  String? leave_mode;
  String? leave_status;
  String? pending_with;
  String? pendingWithName;
  String? pendingWithDesignation;
  String? encashment_applied_flag;

  PastSanctionLeaveDetailsModel({
    required this.leave_id,
    required this.employee_name,
    required this.hrms_employee_id,
    required this.leave_type,
    required this.leave_type2,
    required this.leave_type3,
    required this.leave_from,
    required this.leave_from_fn_an,
    required this.leave_to,
    required this.leave_to2,
    required this.leave_to3,
    required this.leave_to_fn_an,
    required this.leave_to_fn_an2,
    required this.leave_to_fn_an3,
    required this.number_of_days,
    required this.number_of_days2,
    required this.number_of_days3,
    required this.hq_leave,
    required this.hq_leave_from,
    required this.hq_leave_from_time,
    required this.hq_leave_to,
    required this.hq_leave_to_time,
    required this.ex_india_leave,
    required this.ex_india_leave_from,
    required this.ex_india_leave_from_fn_an,
    required this.ex_india_leave_to,
    required this.ex_india_leave_to_fn_an,
    required this.leave_mode,
    required this.leave_status,
    required this.pending_with,
    required this.pendingWithName,
    required this.pendingWithDesignation,
    required this.encashment_applied_flag
  });

  factory PastSanctionLeaveDetailsModel.fromJson(Map<String, dynamic> json) {
    return PastSanctionLeaveDetailsModel(
      leave_id: json['leave_id'],
      employee_name: json['employee_name'],
      hrms_employee_id: json['hrms_employee_id'],
      leave_type: json['leave_type'],
      leave_type2: json['leave_type2'],
      leave_type3: json['leave_type3'],
      leave_from: json['leave_from'],
      leave_from_fn_an: json['leave_from_fn_an'],
      leave_to: json['leave_to'],
      leave_to2: json['leave_to2'],
      leave_to3: json['leave_to3'],
      leave_to_fn_an: json['leave_to_fn_an'],
      leave_to_fn_an2: json['leave_to_fn_an2'],
      leave_to_fn_an3: json['leave_to_fn_an3'],
      number_of_days: json['number_of_days'],
      number_of_days2: json['number_of_days2'],
      number_of_days3: json['number_of_days3'],
      hq_leave: json['hq_leave'],
      hq_leave_from: json['hq_leave_from'],
      hq_leave_from_time: json['hq_leave_from_time'],
      hq_leave_to: json['hq_leave_to'],
      hq_leave_to_time: json['hq_leave_to_time'],
      ex_india_leave: json['ex_india_leave'],
      ex_india_leave_from: json['ex_india_leave_from'],
      ex_india_leave_from_fn_an: json['ex_india_leave_from_fn_an'],
      ex_india_leave_to: json['ex_india_leave_to'],
      ex_india_leave_to_fn_an: json['ex_india_leave_to_fn_an'],
      leave_mode:json['leave_mode'],
      leave_status:json['leave_status'],
      pending_with: json['pending_with'],
      pendingWithName: json['pendingWithName'],
      pendingWithDesignation: json['pendingWithDesignation'],
      encashment_applied_flag: json['encashment_applied_flag']
    );
  }
  @override
  String toString() {
    return 'PastSanctionLeaveDetailsModel(leave_id: $leave_id, employee_name: $employee_name, hrms_employee_id: $hrms_employee_id, leave_type: $leave_type, leave_type2: $leave_type2, leave_type3: $leave_type3, leave_from: $leave_from, leave_from_fn_an: $leave_from_fn_an, leave_to: $leave_to, leave_to2: $leave_to2, leave_to3: $leave_to3, leave_to_fn_an: $leave_to_fn_an, leave_to_fn_an2: $leave_to_fn_an2, leave_to_fn_an3: $leave_to_fn_an3, number_of_days: $number_of_days, number_of_days2: $number_of_days2, number_of_days3: $number_of_days3, hq_leave: $hq_leave, hq_leave_from: $hq_leave_from, hq_leave_from_time: $hq_leave_from_time, hq_leave_to: $hq_leave_to, hq_leave_to_time: $hq_leave_to_time, ex_india_leave: $ex_india_leave, ex_india_leave_from: $ex_india_leave_from, ex_india_leave_from_fn_an: $ex_india_leave_from_fn_an, ex_india_leave_to: $ex_india_leave_to, ex_india_leave_to_fn_an: $ex_india_leave_to_fn_an, leave_mode:$leave_mode,leave_status:$leave_status,pending_with:$pending_with,pendingWithName:$pendingWithName,pendingWithDesignation:$pendingWithDesignation,encashment_applied_flag:$encashment_applied_flag)';
  }
}