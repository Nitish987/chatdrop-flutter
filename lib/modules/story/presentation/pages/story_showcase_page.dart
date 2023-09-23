import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdrop/modules/story/presentation/providers/story_showcase_provider.dart';
import 'package:chatdrop/modules/story/presentation/widgets/story_viewers_sheet.dart';
import 'package:chatdrop/shared/controllers/normal_chat_controller.dart';
import 'package:chatdrop/shared/cubit/auth/auth_cubit.dart';
import 'package:chatdrop/shared/cubit/auth/auth_state.dart';
import 'package:chatdrop/shared/models/message_model/message_model.dart';
import 'package:chatdrop/shared/models/story_feed_model/story_feed_model.dart';
import 'package:chatdrop/shared/models/story_model/story_model.dart';
import 'package:chatdrop/shared/tools/avatar_image_provider.dart';
import 'package:chatdrop/shared/widgets/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';

class StoryShowcasePage extends StatefulWidget {
  final StoryFeedModel story;

  const StoryShowcasePage({Key? key, required this.story}) : super(key: key);

  @override
  State<StoryShowcasePage> createState() => _StoryShowcasePageState();
}

class _StoryShowcasePageState extends State<StoryShowcasePage> {
  final StoryController _storyController = StoryController();
  final TextEditingController _replyController = TextEditingController();
  final NormalChatController _chatController = NormalChatController();
  late List<StoryItem?> _storyItems;

  @override
  void initState() {
    super.initState();
    _storyItems = widget.story.stories!.map((story) {
      if (story.contentType == 'TEXT' || story.contentType == 'PHOTO') {
        return StoryItem.pageProviderImage(
          CachedNetworkImageProvider(
            story.content.toString(),
          ),
          key: Key(story.id.toString()),
          caption: story.contentType == 'PHOTO' ? story.text ?? '' : null,
        );
      } else if (story.contentType == 'VIDEO') {
        return StoryItem.pageVideo(
          story.content.toString(),
          key: Key(story.id.toString()),
          controller: _storyController,
          caption: story.text ?? '',
        );
      }
    }).toList();

    _chatController.init(widget.story.user!);
  }

  @override
  Widget build(BuildContext context) {
    List<StoryModel> stories = widget.story.stories!;
    return BlocBuilder<AuthenticationCubit, AuthState>(builder: (context, authState) {
      if (authState is Authenticated) {
        return ChangeNotifierProvider(
          create: (context) => StoryShowcaseProvider(),
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: AppBar(
                backgroundColor: Colors.black,
              ),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  Consumer<StoryShowcaseProvider>(
                    builder: (context, provider, child) {
                      return Container(
                        color: Colors.black,
                        height: MediaQuery.of(context).size.height - 75,
                        child: StoryView(
                          controller: _storyController,
                          storyItems: _storyItems,
                          onStoryShow: (storyItem) {
                            String key = storyItem.view.key.toString();
                            String storyId = storyItem.view.key
                                .toString()
                                .substring(3, key.length - 3);
                            int index = 0;
                            for (index = 0; index < stories.length; index++) {
                              if (stories[index].id == storyId) {
                                break;
                              }
                            }
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              provider.setStoryId(storyId, index);
                              provider.giveStoryView();
                            });
                          },
                          onComplete: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: Avatar.getAvatarProvider(
                        widget.story.user!.gender.toString(),
                        widget.story.user!.photo,
                      ),
                    ),
                    title: Text(
                      widget.story.user!.name.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Consumer<StoryShowcaseProvider>(
                        builder: (context, provider, child) {
                      return Text(
                        stories[provider.storyIndex!].postedOn.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      );
                    }),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton:widget.story.user!.uid != authState.uid ? null : Consumer<StoryShowcaseProvider>(
              builder: (context, provider, child) {
                return FloatingActionButton(
                  child: const Icon(Icons.remove_red_eye_outlined),
                  onPressed: () async {
                    _storyController.pause();
                    await showModalBottomSheet(
                      context: context,
                      builder: (context) => StoryViewerSheet(storyId: provider.storyId!),
                    );
                    _storyController.play();
                  },
                );
              }
            ),
            bottomSheet: widget.story.user!.uid == authState.uid ? null : Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              height: 55,
              alignment: Alignment.bottomCenter,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: TextField(
                controller: _replyController,
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Reply',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.comment_outlined,
                    color: Colors.white,
                  ),
                  suffixIcon: Consumer<StoryShowcaseProvider>(builder: (context, provider, child) {
                    return IconButton(
                      onPressed: () {
                        _chatController.sendMessage(MessageModel(
                          contentType: 'STORY',
                          content: _replyController.value.text,
                          refer: provider.storyId,
                          time: DateTime.now().millisecondsSinceEpoch,
                        ));
                        _replyController.text = '';
                      },
                      icon: const Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                      ),
                    );
                  }),
                  border: InputBorder.none,
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                ),
                style: const TextStyle(color: Colors.white),
                onTap: () {
                  _storyController.pause();
                },
              ),
            ),
          ),
        );
      }
      return const Scaffold(
        body: CenterMessage(message: 'Please Login again'),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _storyController.dispose();
  }
}
