import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:flutter/material.dart';

import '../../data/models/bg_model.dart';

class BackgroundSelectorPage extends StatelessWidget {
  BackgroundSelectorPage({Key? key}) : super(key: key);

  final List<BgModel> _bgs = BgModel.getBackgroundList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Select Color'),
      ),
      body: GridView.builder(
        itemCount: _bgs.length,
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 300,
        ),
        itemBuilder: (context, index) {
          BgModel bgModel = _bgs[index];
          return InkWell(
            onTap: () {
              Navigator.pop(context, bgModel.name);
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: bgModel.bg),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  bgModel.name.split('.')[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
