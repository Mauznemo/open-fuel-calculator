import 'package:flutter/material.dart';

import '../components/add_vehicle_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Fuel Calculator'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
        body: SafeArea(child: Text("Home Page")),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Your FAB action
            AddVehicleBottomSheet.showBottomSheet(context);
          },
          child: const Icon(Icons.add),
        ));
  }
}
