import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mahjong_event_score/models.dart';
import 'package:mahjong_event_score/providers/event_provider.dart';
import 'package:mahjong_event_score/screens/event_creation_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MahjongTypeAdapter());
  Hive.registerAdapter(PlayerAdapter());
  Hive.registerAdapter(TeamAdapter());
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(GameRecordAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider()..loadEvents(),
      child: MaterialApp(
        title: '麻将赛事计分',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('麻将赛事'),
      ),
      body: Consumer<EventProvider>(
        builder: (context, provider, child) {
          if (provider.events.isEmpty) {
            return const Center(
              child: Text('没有找到赛事，快去创建一个吧！'),
            );
          }
          return ListView.builder(
            itemCount: provider.events.length,
            itemBuilder: (context, index) {
              final event = provider.events[index];
              return ListTile(
                title: Text(event.name),
                subtitle: Text('类型: ${event.mahjongType == MahjongType.fourPlayer ? "四人麻将" : "三人麻将"}'),
                onTap: () {
                  // Navigate to event details screen
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EventCreationScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
