import 'package:flutter/material.dart';
import 'package:quoran/model/music_model.dart';

class ItemListView extends StatelessWidget {
  const ItemListView({Key? key, required this.model}) : super(key: key);
  final MusicModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: ListTile(
          trailing: Text(
            model.name,
            style: const TextStyle(color: Colors.white),
          ),
        ));
  }
}
