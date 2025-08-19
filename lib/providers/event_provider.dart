import 'package:flutter/foundation.dart';
import 'package:mahjong_event_score/models.dart';
import 'package:mahjong_event_score/services/database_service.dart';

class EventProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Event> _events = [];
  Event? _currentEvent;

  List<Event> get events => _events;
  Event? get currentEvent => _currentEvent;

  Future<void> loadEvents() async {
    final box = await _databaseService.eventsBox;
    _events = box.values.toList();
    if (_events.isNotEmpty) {
      _currentEvent = _events.first;
    }
    notifyListeners();
  }

  void setCurrentEvent(Event event) {
    _currentEvent = event;
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    final box = await _databaseService.eventsBox;
    await box.put(event.id, event);
    _events.add(event);
    if (_currentEvent == null) {
      _currentEvent = event;
    }
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
    if (_currentEvent?.id == eventId) {
      _currentEvent = _events.isNotEmpty ? _events.first : null;
    }
    notifyListeners();
  }
}
