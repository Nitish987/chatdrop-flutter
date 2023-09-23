import 'package:chatdrop/shared/models/audio_model/audio_model.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


class Audio extends StatefulWidget {
  const Audio({super.key, required this.audio, required this.player, required this.sameUser, required this.onTap, required this.onOption});
  final AudioModel audio;
  final AudioPlayer player;
  final bool sameUser;
  final Function onTap;
  final Function onOption;

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  void pauseAudio() async {
    if (widget.player.playing) {
      await widget.player.pause();
    }
  }

  void playAudio(String url) async {
    await widget.player.setUrl(url);
    await widget.player.play();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        onPressed: () {
          pauseAudio();
          playAudio(widget.audio.url!);
        },
        icon: const Icon(Icons.audiotrack),
      ),
      title: Text(widget.audio.name!),
      subtitle: Text('Duration : ${widget.audio.duration!} sec'),
      trailing: IconButton(
        onPressed: () {
          widget.onOption();
        },
        icon: const Icon(Icons.more_horiz),
      ),
      onTap: () {
        widget.onTap();
      },
    );
  }
}
