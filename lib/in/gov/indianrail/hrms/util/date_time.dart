import 'package:intl/intl.dart';

String format_date(String date){
  if(date!=null && date!="" && date!="null") {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
   }
  return "NA";
}

