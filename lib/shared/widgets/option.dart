import 'package:flutter/material.dart';

enum OptionAlign {center, start, end}

class Option extends StatelessWidget {
  const Option({Key? key,
    required this.label,
    required this.icon,
    required this.color,
    this.align = OptionAlign.start,
    required this.onPressed,
    this.height = 60,
  }) : super(key: key);

  final String label;
  final IconData icon;
  final Color color;
  final OptionAlign align;
  final Function onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    MainAxisAlignment alignment = MainAxisAlignment.start;

    if(align == OptionAlign.center) {
      alignment = MainAxisAlignment.center;
    } else if(align == OptionAlign.start) {
      alignment = MainAxisAlignment.start;
    } else {
      alignment = MainAxisAlignment.end;
    }

    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        height: height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: alignment,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(label,
              style: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
