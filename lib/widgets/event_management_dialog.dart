import 'package:flutter/material.dart';
import 'package:mahjong_event_score/models.dart';
import 'package:mahjong_event_score/providers/event_provider.dart';
import 'package:mahjong_event_score/screens/event_creation_screen.dart';
import 'package:provider/provider.dart';

class EventManagementDialog extends StatelessWidget {
  const EventManagementDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final events = eventProvider.events;
    final currentEvent = eventProvider.currentEvent;

    return AlertDialog(
      title: const Text('管理赛事'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (events.isEmpty)
              const Text('没有赛事，请创建一个。')
            else
              DropdownButtonFormField<Event>(
                value: currentEvent,
                hint: const Text('选择一个赛事'),
                items: events.map((event) {
                  return DropdownMenuItem(
                    value: event,
                    child: Text(event.name),
                  );
                }).toList(),
                onChanged: (event) {
                  if (event != null) {
                    eventProvider.setCurrentEvent(event);
                  }
                },
              ),
            const SizedBox(height: 20),
            ...events.map((event) => ListTile(
                  title: Text(event.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      eventProvider.deleteEvent(event.id);
                    },
                  ),
                  onTap: () {
                    eventProvider.setCurrentEvent(event);
                    Navigator.of(context).pop();
                  },
                )),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EventCreationScreen(),
              ),
            );
          },
          child: const Text('创建新赛事'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('关闭'),
        ),
      ],
    );
  }
}
