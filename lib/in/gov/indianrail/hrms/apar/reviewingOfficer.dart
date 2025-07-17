import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import 'aparProfile.dart';
import 'gazettedoffierviewModel.dart';
import 'reportingOfficerModel.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';

class ReviewingOfficer extends StatefulWidget {
  final List<GazettedOfficerModel> userList;
  final String title;
  final int arraySize;

  ReviewingOfficer(this.userList, this.title, this.arraySize);

  @override
  _ReviewingOfficerState createState() => _ReviewingOfficerState();
}

class _ReviewingOfficerState extends State<ReviewingOfficer> {
  final sharedpreferencemanager pref = sharedpreferencemanager();

  @override
  Widget build(BuildContext context) {
    if (widget.arraySize == 0) {
      return Center(
        child: Text(
          "No data found",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable2(
          columnSpacing: 12,
          minWidth: 620,
          headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
          columns: [
            DataColumn2(
              label: Text('HRMS ID', style: TextStyle(fontWeight: FontWeight.bold)),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text('Emp Name', style: TextStyle(fontWeight: FontWeight.bold)),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Text('Designation', style: TextStyle(fontWeight: FontWeight.bold)),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Text('Unit Code', style: TextStyle(fontWeight: FontWeight.bold)),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text('Fin‑Year', style: TextStyle(fontWeight: FontWeight.bold)),
              size: ColumnSize.S,
            ),
          ],
          rows: List<DataRow>.generate(
            widget.userList.length,
                (index) {
              final item = widget.userList[index];
              return DataRow(
                cells: [
                  DataCell(
                    Text(item.hrmsEmployeeId ?? 'Not Available',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AparProfile(
                            item.hrmsEmployeeId,
                            item.employeeName,
                            item.Designation,
                            item.vafCode,
                            item.aparFinYr,
                            'reviewing',
                          ),
                        ),
                      );
                    },
                  ),
                  DataCell(Text(item.employeeName ?? 'Not Available')),
                  DataCell(Text(item.Designation ?? 'Not Available')),
                  DataCell(Text(item.DesigatnionCode?.toString() ?? '—',
                      textAlign: TextAlign.center)),
                  DataCell(Text(item.aparFinYr ?? 'Not Available')),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
