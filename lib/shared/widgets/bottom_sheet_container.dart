import 'package:flutter/material.dart';

class BottomSheetContainer extends StatelessWidget {
  const BottomSheetContainer({
    super.key,
    this.height = 250,
    this.padding = const EdgeInsets.all(10),
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    required this.children,
  });
  final double? height;
  final EdgeInsets padding;
  final CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Center(
        child: Container(
          width: 100,
          height: 4,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    ];

    children.addAll(this.children);

    return Container(
      padding: padding,
      height: height,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
  }
}
