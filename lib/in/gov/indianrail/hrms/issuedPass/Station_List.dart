class StationList {
  String code;
  String description;

  StationList({required this.code, required this.description});

  factory StationList.fromJson(Map<String, dynamic> parsedJson) {
    return StationList(
      code: parsedJson["code"] as String,
      description: parsedJson["description"] as String,
    );
  }
}

class ReasonList {
  String reason_code;
  String description;
  String ipas_code;
  String basic_pay_multiplier;
  String withdrawal_percentage;

  ReasonList(
      {required this.reason_code,
      required this.description,
      required this.ipas_code,
      required this.basic_pay_multiplier,
      required this.withdrawal_percentage});

  String toString() => '''

  reason_code: $reason_code,
  description: $description,
  ipas_code: $ipas_code,
  basic_pay_multiplier: $basic_pay_multiplier,
  withdrawal_percentage:$withdrawal_percentage,
  
  

  ''';

// factory FamilyEditCol.fromJson(dynamic json) {
//       return FamilyEditCol(json['family_member_sr_no'].toString(),
//           json['member_name'] as String,
//           json['relation_description'] as String,
//           json['relation_flag_description'] as String,
//           json['gender'] as String,
//           json['member_date_of_birth'] as String,
//           json['age'].toString(),
//           json['isChecked']
//
//       );
//    }
// @override
// String toString() {
//    return '{ ${this.family_member_sr_no},}';
// }
// @override
//    String toString() {
//
//       return '{ ${this.family_member_sr_no}, ${this.member_name},${this.relation_description},${this.relation_flag_description},${this.member_date_of_birth},${this.age},${this.isChecked}}';
//    }
}
