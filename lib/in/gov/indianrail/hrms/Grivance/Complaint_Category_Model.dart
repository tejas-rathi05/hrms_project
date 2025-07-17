class Complaint_Category_Moduel{
  int complaint_type;
  String complaint_name;



  Complaint_Category_Moduel(
    this.complaint_type,
    this.complaint_name,
  );
  factory Complaint_Category_Moduel.fromJson(dynamic json) {
    return Complaint_Category_Moduel(json['complaint_type'] as int, json['complaint_name'] as String

    );
  }


  @override
  String toString() {
    return '{ ${this.complaint_type}, ''${this.complaint_name}';
  }


}

