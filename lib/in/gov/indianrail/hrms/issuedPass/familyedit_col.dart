class FamilyEditCol {
  var family_member_sr_no;
  String member_name;
  String relation_description;
  String relation_flag_description;
  String gender;
  String member_date_of_birth;
  var age;
  bool isChecked = false;

  FamilyEditCol(
      {required this.family_member_sr_no,
      required this.member_name,
      required this.relation_description,
      required this.relation_flag_description,
      required this.gender,
      required this.member_date_of_birth,
      required this.age,
      required this.isChecked});

  String toString() => '''

  family_member_sr_no: $family_member_sr_no,
  member_name: $member_name,
  relation_description: $relation_description,
  relation_flag_description: $relation_flag_description,
  gender:$gender,
  member_date_of_birth:$member_date_of_birth,
  age:$age,
  isChecked:$isChecked
  
  

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
