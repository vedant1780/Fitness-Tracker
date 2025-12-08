import 'package:flutter/material.dart';

import '../../widgets/analytic_tile_widget.dart';



class DataAnalyticsPage extends StatelessWidget {
  const DataAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Data & Analytics",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        children: const [
          SettingsAnalyticTile(
            title: "Data Usage",
            subtitle:
            "Control how your data is used for analytics.\nCustomize your preferences.",
          ),


          SettingsAnalyticTile(
            title: "Ad Preferences",
            subtitle:
            "Manage ad personalization settings. Tailor\nyour ad experience.",
          ),
          SettingsAnalyticTile(
            title: "Download My Data",
            subtitle:
            "Request a copy of your data. Your information.\nyour control.",
          ),
        ],
      ),
    );
  }
}



