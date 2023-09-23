import 'package:chatdrop/settings/constants/assets_constant.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Private extends StatelessWidget {
  const Private({Key? key, this.height = 250, this.padding = const EdgeInsets.all(20), this.margin = const EdgeInsets.all(0), this.label = 'This is private.'}) : super(key: key);

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeCubit>(context).state;

    String assetSource = theme == ThemeState.light ? IllustrationAssets.privateLight : IllustrationAssets.privateDark;

    return Center(
      child: Container(
        padding: padding,
        margin: margin,
        height: height,
        child: Column(
          children: [
            Image.asset(assetSource, width: 200),
            const SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}