import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/bloc/reel_feed/reel_feed_bloc.dart';
import 'package:chatdrop/shared/bloc/reel_feed/reel_feed_event.dart';
import 'package:chatdrop/shared/models/reel_model/reel_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReelView extends StatelessWidget {
  const ReelView({super.key, required this.reel});
  final ReelModel reel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<ReelFeedBloc>(context).add(MoveReelFeedEvent(reel.id!));
        Navigator.pushNamed(context, Routes.reelSlider);
      },
      child: Container(
        width: 140,
        height: 200,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.black,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Stack(
            children: [
              Center(
                child: CachedNetworkImage(
                  width: 140,
                  imageUrl: reel.video!.thumbnail!,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        reel.user!.name!,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${reel.viewsCount} views',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
