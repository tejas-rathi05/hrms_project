class reportingOfficerModel{




  String employeeid; String employeename;String designation; String office;
  reportingOfficerModel(this.employeeid, this.employeename, this.designation, this.office);


  @override
  String toString() {
    return '{ ${this.employeeid}, ${this.employeename},${this.designation},${this.office} }';
  }
}