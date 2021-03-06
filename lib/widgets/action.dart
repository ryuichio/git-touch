import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../providers/settings.dart';

class Action {
  String text;
  Function onPress;

  Action({@required this.text, @required this.onPress});
}

class ActionButton extends StatelessWidget {
  final String title;
  final List<Action> actions;
  final IconData iconData;

  ActionButton({
    @required this.title,
    @required this.actions,
    this.iconData = Icons.more_vert,
  });

  void _onSelected(int value) {
    if (value != null) {
      actions[value].onPress();
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (SettingsProvider.of(context).theme) {
      case ThemeMap.cupertino:
        return GestureDetector(
          child: Icon(iconData, size: 24),
          onTap: () async {
            int value = await showCupertinoModalPopup<int>(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                  title: Text(title),
                  actions: actions.asMap().entries.map((entry) {
                    return CupertinoActionSheetAction(
                      child: Text(entry.value.text),
                      onPressed: () {
                        Navigator.pop(context, entry.key);
                      },
                    );
                  }).toList(),
                  cancelButton: CupertinoActionSheetAction(
                    child: const Text('Cancel'),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            );

            _onSelected(value);
          },
        );
      default:
        return PopupMenuButton<int>(
          icon: Icon(iconData),
          onSelected: _onSelected,
          itemBuilder: (BuildContext context) {
            return actions.asMap().entries.map((entry) {
              return PopupMenuItem(
                value: entry.key,
                child: Text(entry.value.text),
              );
            }).toList();
          },
        );
    }
  }
}
