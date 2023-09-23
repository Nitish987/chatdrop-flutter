import 'package:chatdrop/modules/dashboard/presentation/widgets/reel_view.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/widgets/reel_feed_shimmer_loading.dart';
import 'package:chatdrop/shared/bloc/reel_feed/reel_feed_bloc.dart';
import 'package:chatdrop/shared/bloc/reel_feed/reel_feed_state.dart';
import 'package:chatdrop/shared/models/reel_model/reel_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ReelsContainer extends StatelessWidget {
  const ReelsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: MediaQuery.of(context).size.width,
      height: 220,
      child: BlocBuilder<ReelFeedBloc, ReelFeedState>(
        builder: (context, state) {
          if (state is FetchedReelFeedState) {
            List<ReelModel> reelFeeds = state.reels;

            int reelsLength = reelFeeds.length;
            if (reelFeeds.length > 5) {
              reelsLength = 4;
            }

            /// Listing Stories
            return ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: reelsLength + 1,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return const SizedBox(width: 5);
              },
              itemBuilder: (context, index) {
                if (index < reelsLength) {
                  ReelModel reel = reelFeeds[index];
                  return ReelView(
                    key: Key(reel.id.toString()),
                    reel: reel,
                  );
                }
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.reelSlider);
                  },
                  child: Container(
                    width: 140,
                    height: 200,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey,
                    ),
                    child: const Center(
                      child: SizedBox(
                        height: 50,
                        child: Column(
                          children: [
                            Icon(
                              Icons.arrow_circle_right_outlined,
                              color: Colors.black,
                            ),
                            Text(
                              'Watch More Reels',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const ReelFeedShimmerLoading();
        },
      ),
    );
  }
}
