import 'package:flutter/material.dart';
import 'package:mahjong_event_score/models.dart';
import 'package:mahjong_event_score/providers/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EventCreationScreen extends StatefulWidget {
  const EventCreationScreen({super.key});

  @override
  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _totalScoreCheckController = TextEditingController(text: '100000');
  final _originPointController = TextEditingController(text: '25000');
  final _pos1PtController = TextEditingController(text: '15');
  final _pos2PtController = TextEditingController(text: '5');
  final _pos3PtController = TextEditingController(text: '-5');
  final _pos4PtController = TextEditingController(text: '-15');

  MahjongType _mahjongType = MahjongType.fourPlayer;
  bool _isTeamCompetition = false;
  bool _isScoreCheckEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建赛事'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '赛事名称'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入赛事名称';
                }
                return null;
              },
            ),
            DropdownButtonFormField<MahjongType>(
              value: _mahjongType,
              decoration: const InputDecoration(labelText: '麻将类型'),
              items: MahjongType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type == MahjongType.fourPlayer ? "四人麻将" : "三人麻将"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _mahjongType = value!;
                });
              },
            ),
            SwitchListTile(
              title: const Text('团队赛'),
              value: _isTeamCompetition,
              onChanged: (value) {
                setState(() {
                  _isTeamCompetition = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('启用总分检查'),
              value: _isScoreCheckEnabled,
              onChanged: (value) {
                setState(() {
                  _isScoreCheckEnabled = value;
                });
              },
            ),
            TextFormField(
              controller: _totalScoreCheckController,
              decoration: const InputDecoration(labelText: '总分检查'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入一个数值';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _originPointController,
              decoration: const InputDecoration(labelText: '精算原点'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入一个数值';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _pos1PtController,
              decoration: const InputDecoration(labelText: '顺位pt (1位)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入一个数值';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _pos2PtController,
              decoration: const InputDecoration(labelText: '顺位pt (2位)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入一个数值';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _pos3PtController,
              decoration: const InputDecoration(labelText: '顺位pt (3位)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入一个数值';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _pos4PtController,
              decoration: const InputDecoration(labelText: '顺位pt (4位)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入一个数值';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final event = Event(
                    id: const Uuid().v4(),
                    name: _nameController.text,
                    mahjongType: _mahjongType,
                    isTeamCompetition: _isTeamCompetition,
                    totalScoreCheck: int.parse(_totalScoreCheckController.text),
                    originPoint: int.parse(_originPointController.text),
                    positionPoints: {
                      1: int.parse(_pos1PtController.text),
                      2: int.parse(_pos2PtController.text),
                      3: int.parse(_pos3PtController.text),
                      4: int.parse(_pos4PtController.text),
                    },
                    isScoreCheckEnabled: _isScoreCheckEnabled,
                  );
                  Provider.of<EventProvider>(context, listen: false).addEvent(event);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('创建赛事'),
            ),
          ],
        ),
      ),
    );
  }
}
