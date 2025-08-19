import 'package:flutter/material.dart';
import 'package:mahjong_event_score/models.dart';
import 'package:mahjong_event_score/providers/player_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PlayerManagementDialog extends StatefulWidget {
  final String eventId;

  const PlayerManagementDialog({super.key, required this.eventId});

  @override
  _PlayerManagementDialogState createState() => _PlayerManagementDialogState();
}

class _PlayerManagementDialogState extends State<PlayerManagementDialog> {
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('管理选手'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '选手姓名'),
            ),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: '选手昵称'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty && _nicknameController.text.isNotEmpty) {
                  final player = Player(
                    id: const Uuid().v4(),
                    name: _nameController.text,
                    nickname: _nicknameController.text,
                  );
                  Provider.of<PlayerProvider>(context, listen: false).addPlayer(player);
                  _nameController.clear();
                  _nicknameController.clear();
                }
              },
              child: const Text('添加选手'),
            ),
            const Divider(),
            Expanded(
              child: Consumer<PlayerProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.players.length,
                    itemBuilder: (context, index) {
                      final player = provider.players[index];
                      return ListTile(
                        title: Text(player.name),
                        subtitle: Text(player.nickname),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            provider.deletePlayer(player.id);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
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
