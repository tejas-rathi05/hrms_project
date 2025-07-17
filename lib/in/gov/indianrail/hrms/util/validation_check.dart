String null_empty_check(String data){
  if(data!=null && data!="" && data!="null") {
    return data;
  }
  return "NA";
}

String service_status_check(String status) {
  String serviceStatus = '';
  if (status == 'A') {
    serviceStatus = 'Verified';
  } else {
    serviceStatus = 'Not Verified';
  }
  return serviceStatus;
}
String pass_cancel_status_check(String data){
  if(data!=null && data!="" && data!="null") {
    return data;
  }
  return "";
}

String leave_balance_status_check(String data){
  if(data!=null && data!="" && data!="null") {
    return data;
  }
  return "";
}