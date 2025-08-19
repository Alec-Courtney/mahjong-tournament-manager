import 'package:hive/hive.dart';

part 'column_config.g.dart';

@HiveType(typeId: 5)
class ColumnConfig extends HiveObject {
  @HiveField(0)
  String columnName;
  @HiveField(1)
  String dataKey;
  @HiveField(2)
  bool isVisible;

  ColumnConfig({
    required this.columnName,
    required this.dataKey,
    this.isVisible = true,
  });
}
