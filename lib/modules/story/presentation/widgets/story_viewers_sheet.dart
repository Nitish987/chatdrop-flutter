import 'package:chatdrop/modules/story/presentation/cubit/story_viewer/story_viewer_cubit.dart';
import 'package:chatdrop/modules/story/presentation/cubit/story_viewer/story_viewer_state.dart';
import 'package:chatdrop/shared/illustrations/nothing.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/tools/avatar_image_provider.dart';
import 'package:chatdrop/shared/widgets/bottom_sheet_container.dart';
import 'package:chatdrop/shared/widgets/list_tile_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryViewerSheet extends StatelessWidget {
  const StoryViewerSheet({Key? key, required this.storyId}) : super(key: key);

  final String storyId;

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      height: 400,
      children: [
        BlocProvider(
          create: (context) => StoryViewerCubit(storyId),
          child: BlocBuilder<StoryViewerCubit, StoryViewerState>(
            builder: (context, state) {
              if (state is StoryViewersListedState) {
                List<UserModel> viewers = state.viewers;

                if (viewers.isEmpty) {
                  return const Nothing(label: 'No viewers.');
                }

                return Flexible(
                  child: ListView.builder(
                    itemCount: viewers.length,
                    itemBuilder: (context, index) {
                      UserModel user = viewers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: Avatar.getAvatarProvider(
                            user.gender.toString(),
                            user.photo,
                          ),
                        ),
                        title: Text(user.name.toString()),
                        subtitle: Text(user.message.toString()),
                      );
                    },
                  ),
                );
              }

              return const Flexible(child: ListTileShimmerLoading());
            },
          ),
        ),
      ],
    );
  }
}
