import 'package:flutter/material.dart';

class TopTitles extends StatelessWidget {
  final String title, subTitle;
  const TopTitles({super.key, required this.subTitle, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: kToolbarHeight + 12,
        ),
        if (title == "Login" || title == "Create Account")
          GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back_ios)),
        const SizedBox(
          height: 12.0,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          subTitle,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}
