import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectFileDialog extends StatelessWidget {
  const SelectFileDialog({Key? key, required this.onImageSelectPressed, required this.onVideoSelectPressed}) : super(key: key);

  final Function onImageSelectPressed;
  final Function onVideoSelectPressed;

  Widget _circularBorderIconButton(BuildContext context, {required String label, required IconData icon, required Function onPressed}) {
    ThemeState theme = BlocProvider.of<ThemeCubit>(context).state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: Colors.blue,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: theme == ThemeState.light ? Colors.white : Colors.black,
            child: IconButton(
              icon: Icon(icon),
              onPressed: () {
                onPressed();
              },
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _circularBorderIconButton(context, label: 'Image', icon: Icons.image_outlined, onPressed: () {
            onImageSelectPressed();
          }),
          const SizedBox(width: 10),
          _circularBorderIconButton(context, label: 'Video', icon: Icons.videocam_outlined, onPressed: () {
            onVideoSelectPressed();
          }),
        ],
      ),
    );
  }
}
