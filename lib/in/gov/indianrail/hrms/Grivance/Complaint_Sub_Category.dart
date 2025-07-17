class Complaint_Sub_Category_Moduel{
  int complaint_sub_type;
  String complaint_sub_name;



  Complaint_Sub_Category_Moduel(
      this.complaint_sub_type,
      this.complaint_sub_name,
      );
  factory Complaint_Sub_Category_Moduel.fromJson(dynamic json) {
    return Complaint_Sub_Category_Moduel(json['complaint_sub_type'] as int, json['complaint_sub_name'] as String

    );
  }


  @override
  String toString() {
    return '{ ${this.complaint_sub_type}, ''${this.complaint_sub_name}';
  }


}

