import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomTable extends StatefulWidget {
  const CustomTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  final List<DataColumn> columns;
  final List<DataRow> rows;

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  late ScrollController _horizontalScrollController;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        return true;
      },
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
          physics: const ClampingScrollPhysics(),
        ),
        child: Scrollbar(
          controller: _horizontalScrollController,
          thumbVisibility: true, // Always show scrollbar thumb
          trackVisibility: true, // Always show scrollbar track
          thickness: .5, // Adjust thickness as needed
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horizontalScrollController,
            // Preserve scroll offset during rebuilds
            key: const PageStorageKey<String>('horizontal_scroll'),
            child: Theme(
              // Prevent DataTable from handling its own scrolling
              data: Theme.of(context).copyWith(
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor: WidgetStateProperty.all(Colors.grey[400]),
                  trackColor: WidgetStateProperty.all(Colors.grey[200]),
                ),
                dataTableTheme: DataTableThemeData(
                  headingTextStyle:
                      Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                  dataTextStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              child: DataTable(
                headingRowColor:
                    WidgetStateProperty.all(const Color(0xffF6F6F6)),
                headingRowHeight: 48,
                horizontalMargin: 1,
                dataRowMinHeight: 28,
                dataRowMaxHeight: 50,
                // 38,
                columnSpacing: 0,
                border: TableBorder.all(
                  color: const Color(0xff727272),
                  width: 0.5,
                ),
                columns: widget.columns,
                rows: widget.rows,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Optional: Add a TableTheme class for consistent styling
class TableTheme {
  static const Color headerBackgroundColor = Color(0xffF6F6F6);
  static const Color borderColor = Color(0xff727272);
  static const double borderWidth = 0.5;
  static const double headerHeight = 48.0;
  static const double minRowHeight = 28.0;
  static const double maxRowHeight = 38.0;
}
