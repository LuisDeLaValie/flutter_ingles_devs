// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ingles_devs/widget/accion_button.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tabla_model.dart';

class TablaView extends StatefulWidget {
  final List<HeaderTable> headers;
  final List<List<CellBodyTable>> body;
  final Future<void> Function(int index)? eliminar;
  const TablaView({
    Key? key,
    required this.headers,
    required this.body,
    this.eliminar,
  }) : super(key: key);

  @override
  State<TablaView> createState() => _TablaViewState();
}

class _TablaViewState extends State<TablaView> {
  late int sortColumnIndex;
  bool sortAscending = true;

  late List<List<CellBodyTable>> body;
  @override
  void initState() {
    super.initState();
    sortColumnIndex = widget.headers.indexWhere((element) => element.orden);
    body = widget.body;
  }

  @override
  void didUpdateWidget(TablaView oldWidget) {
    super.didUpdateWidget(oldWidget);
    sortColumnIndex = widget.headers.indexWhere((element) => element.orden);
    body = widget.body;
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).copyWith(
        cardTheme: const CardTheme(color: Colors.white, elevation: 0));

    return Theme(
      data: tema,
      child: PaginatedDataTable2(
        // minWidth: 500,
        columnSpacing: 5,
        horizontalMargin: 10,
        sortColumnIndex: sortColumnIndex,
        sortAscending: sortAscending,
        columns: headers(),
        source: SourceDataTable(body, eliminar: widget.eliminar),
      ),
    );
  }

  List<DataColumn> headers() {
    List<DataColumn> aux = [];
    for (var i = 0; i < widget.headers.length; i++) {
      final row = widget.headers[i];

      final label = Row(
        children: [
          Text(
            row.nombre,
            style: GoogleFonts.getFont(
              'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (row.orden) const Icon(Icons.filter_alt_rounded, size: 15)
        ],
      );

      aux.add(
        DataColumn2(
          fixedWidth: row.fixedWidth,
          label: label,
          onSort: !row.orden ? null : orderBy,
        ),
      );
    }

    if (widget.eliminar != null) {
      aux.add(
        DataColumn2(
          label: Text(
            "Acción",
            style: GoogleFonts.getFont(
              'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return aux;
  }

  void orderBy(int columnIndex, bool ascending) {
    var auxDataTable = widget.body;

    if (ascending) {
      auxDataTable
          .sort((a, b) => b[columnIndex].data.compareTo(a[columnIndex].data));
    } else {
      auxDataTable
          .sort((a, b) => a[columnIndex].data.compareTo(b[columnIndex].data));
    }

    // auxDataTable?.sort((a, b) {
    //   final aa = a.score ?? -1;
    //   final bb = b.score ?? -1;

    //   int compare = 0;
    //   if (ascending) {
    //     compare = bb.compareTo(aa);
    //   } else {
    //     compare = aa.compareTo(bb);
    //   }

    //   return compare;
    // });

    setState(() {
      sortAscending = ascending;
      sortColumnIndex = columnIndex;
      body = auxDataTable;
    });
  }
}

class SourceDataTable extends DataTableSource {
  final List<List<CellBodyTable>> dataTable;
  final Future<void> Function(int index)? eliminar;

  SourceDataTable(
    this.dataTable, {
    this.eliminar,
  });

  @override
  int get rowCount => dataTable.length;

  @override
  DataRow? getRow(int index) {
    final auxRow = dataTable[index];

    final style = GoogleFonts.getFont(
      'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    var row = auxRow
        .map(
          (e) => DataCell(
            SelectableText(e.data, style: style),
          ),
        )
        .toList();

    if (eliminar != null) {
      row.add(
        DataCell(
          Column(
            children: [
              if (eliminar != null)
                AccionButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15)),
                  colorCircularProgress: Colors.white,
                  onPressed: () async => await eliminar?.call(index),
                  text: "Eliminar",
                )
            ],
          ),
        ),
      );
    }
    return DataRow(cells: row);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
