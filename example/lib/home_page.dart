import 'package:flutter/material.dart';
import 'package:fplayer_example/recent_list.dart';

import 'app_bar.dart';

class HomeItem extends StatelessWidget {
  const HomeItem({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 45,
      child: Container(
        padding: const EdgeInsets.all(0),
        child: TextButton(
          key: ValueKey(text),
          onPressed: onPressed,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final RecentMediaList list = RecentMediaList();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FAppBar.defaultSetting(
        title: "FPlayer",
      ),
      body: Builder(
        builder: (ctx) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            HomeItem(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SamplesScreen(),
                  ),
                );
              },
              text: "Online Samples",
            ),
          ],
        ),
      ),
    );
  }
}
