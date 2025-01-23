import 'package:flutter/material.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("Fuel Calculator", style: TextStyle(fontSize: 20)),
          ),
          Divider(
            thickness: 2,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: ModalRoute.of(context)?.settings.name == '/'
                    ? Theme.of(context).colorScheme.surfaceVariant
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.money,
                ),
                title: const Text("Price"),
                onTap: () {
                  Navigator.of(context).pop();
                  if (ModalRoute.of(context)?.settings.name == '/') {
                    return;
                  }
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: ModalRoute.of(context)?.settings.name == '/range'
                    ? Theme.of(context).colorScheme.surfaceVariant
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.speed),
                title: const Text("Range"),
                onTap: () {
                  Navigator.of(context).pop();
                  if (ModalRoute.of(context)?.settings.name == '/range') {
                    return;
                  }
                  Navigator.pushReplacementNamed(context, '/range');
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: ModalRoute.of(context)?.settings.name == '/settings'
                    ? Theme.of(context).colorScheme.surfaceVariant
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {
                  Navigator.of(context).pop();
                  if (ModalRoute.of(context)?.settings.name == '/settings') {
                    return;
                  }
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
