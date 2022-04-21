import 'package:flutter/material.dart';

class Menghapus extends StatelessWidget {
  final Function() onPressed;

  const Menghapus({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }
}
