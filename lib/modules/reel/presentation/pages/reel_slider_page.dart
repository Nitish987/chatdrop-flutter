import 'package:chatdrop/shared/bloc/reel_feed/reel_feed_bloc.dart';
import 'package:chatdrop/shared/bloc/reel_feed/reel_feed_state.dart';
import 'package:chatdrop/shared/models/reel_model/reel_model.dart';
import 'package:chatdrop/shared/widgets/reel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReelSliderPage extends StatefulWidget {
  const ReelSliderPage({super.key});

  @override
  State<ReelSliderPage> createState() => _ReelSliderPageState();
}

class _ReelSliderPageState extends State<ReelSliderPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ReelFeedBloc, ReelFeedState>(
        builder: (context, state) {
          if (state is FetchedReelFeedState) {
            List<ReelModel> reels = state.reels;

            return PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              itemCount: reels.length,
              itemBuilder: (context, index) {
                ReelModel reel = reels[index];
                return Reel(
                  key: Key(reel.id.toString()),
                  reel: reel,
                  sameUser: reel.user!.uid! == reel.authUser!.uid!,
                );
              },
            );
          }
          return Container(color: Colors.black);
        }
      ),
    );
  }
}
