import 'package:flutter/foundation.dart';
import 'package:mahjong_event_score/models.dart';
import 'package:mahjong_event_score/services/database_service.dart';

class EventProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Event> _events = [];

  List<Event> get events => _events;

  Future<void> loadEvents() async {
    final box = await _databaseService.eventsBox;
    _events = box.values.toList();
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    final box = await _databaseService.eventsBox;
    await box.put(event.id, event);
    _events.add(event);
    notifyListeners();
  }

  Future<void> updateEvent(Event event) async {
    final box = await _databaseService.eventsBox;
    await box.put(event.id, event);
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final box = await _databaseService.eventsBox;
    await box.delete(eventId);
    _events.removeWhere((event) => event.id == eventId);
    notifyListeners();
  }
}
