import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/cubit/auth/auth_cubit.dart';
import 'package:chatdrop/shared/cubit/auth/auth_state.dart';
import 'package:chatdrop/shared/models/reel_model/reel_model.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:chatdrop/shared/illustrations/nothing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/reel/reel_bloc.dart';
import '../bloc/reel/reel_event.dart';
import '../bloc/reel/reel_state.dart';

class ReelListPage extends StatefulWidget {
  const ReelListPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<ReelListPage> createState() => _ReelListPageState();
}

class _ReelListPageState extends State<ReelListPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ReelBloc>(context).add(ListReelEvent(widget.uid));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthState>(
      builder: (context, authState) {
        if (authState is Authenticated) {
          return Scaffold(
            appBar: AppBar(
              title: const AppBarTitle(title: 'Reels'),
            ),
            body: BlocBuilder<ReelBloc, ReelState>(
              builder: (context, state) {
                if (state is ListReelState) {
                  List<ReelModel> reels = state.reels;

                  if (reels.isEmpty) {
                    return const Nothing();
                  }

                  /// Listing user posts
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: GridView.builder(
                      itemCount: reels.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 3.0,
                        mainAxisSpacing: 3.0,
                        childAspectRatio: 9/16
                      ),
                      itemBuilder: (context, index) {
                        ReelModel reel = reels[index];
                        return InkWell(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              color: Colors.black,
                              child: Stack(
                                children: [
                                  Center(
                                    child: CachedNetworkImage(
                                      key: Key(reel.id.toString()),
                                      imageUrl: reel.video!.thumbnail!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, value) {
                                        return Container(color: Colors.grey);
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        "${reel.viewsCount} views",
                                        style: const TextStyle(
                                          color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, Routes.reelShowcase, arguments: {
                              'reel': reel,
                              'same_user': authState.uid == reel.user!.uid!,
                            });
                          },
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            ),
          );
        }
        return const Scaffold();
      },
    );
  }
}
