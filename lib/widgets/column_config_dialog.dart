import 'package:flutter/material.dart';
import 'package:mahjong_event_score/models.dart';
import 'package:mahjong_event_score/providers/event_provider.dart';
import 'package:provider/provider.dart';

class ColumnConfigDialog extends StatefulWidget {
  final Event event;

  const ColumnConfigDialog({super.key, required this.event});

  @override
  _ColumnConfigDialogState createState() => _ColumnConfigDialogState();
}

class _ColumnConfigDialogState extends State<ColumnConfigDialog> {
  late List<bool> _visibilities;

  @override
  void initState() {
    super.initState();
    _visibilities = widget.event.playerColumns.map((c) => c.isVisible).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('配置表格列'),
      content: SizedBox(
        width: 300,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.event.playerColumns.length,
          itemBuilder: (context, index) {
            final column = widget.event.playerColumns[index];
            return CheckboxListTile(
              title: Text(column.columnName),
              value: _visibilities[index],
              onChanged: (bool? value) {
                setState(() {
                  _visibilities[index] = value ?? false;
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            for (int i = 0; i < widget.event.playerColumns.length; i++) {
              widget.event.playerColumns[i].isVisible = _visibilities[i];
            }
            // We need to save the event to persist the changes
            Provider.of<EventProvider>(context, listen: false).updateEvent(widget.event);
            Navigator.of(context).pop();
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}
