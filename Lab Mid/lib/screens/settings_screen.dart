import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SwitchListTile(
            title: Text('Dark Theme'),
            subtitle: Text('Enable dark mode for reading & UI'),
            value: false,
            onChanged: null,
          ),
          const SwitchListTile(
            title: Text('Auto Cloud Backup'),
            subtitle: Text('Sync scanned PDFs to cloud storage'),
            value: true,
            onChanged: null,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Lab Mid App'),
            subtitle: const Text('PDF Reader & Utility Suite v1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Comprehensive PDF Reader & Utility',
                applicationVersion: '1.0.0',
                applicationLegalese: 'Developed by Furqan Fayyaz (FA24-BCS-125)',
                children: [
                  const SizedBox(height: 12),
                  const Text('Lab Mid Assessment - Mobile Application Development (CSC 303).'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
