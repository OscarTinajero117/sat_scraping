import 'package:flutter/material.dart';

class TableInfoSat extends StatelessWidget {
  final String tableTitle;
  final List<TableRow> children;

  const TableInfoSat({
    super.key,
    required this.tableTitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer,
            border: Border.all(
              color: theme.colorScheme.onPrimaryContainer,
              width: 1.0,
            ),
          ),
          margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
          child: Center(
            child: Text(
              tableTitle,
              style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          margin: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
          child: Column(
            children: [
              Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(),
                  1: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: children,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
