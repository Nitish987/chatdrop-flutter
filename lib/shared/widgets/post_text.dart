import 'package:any_link_preview/any_link_preview.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/theme/theme_state.dart';
import '../models/hashtag_model/hashtag_model.dart';
import '../tools/web_visit.dart';

class PostText extends StatelessWidget {
  const PostText({super.key, required this.text, this.containsHashtags = false, required this.hashtags});
  final String text;
  final bool containsHashtags;
  final List<HashtagModel> hashtags;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeCubit>(context).state;
    Widget child;

    if (text.startsWith('http') && !text.contains(' ')) {
      child = Stack(
        children: [
          AnyLinkPreview(
            link: text,
            backgroundColor: theme == ThemeState.light? Colors.white: Colors.black,
            errorWidget: Container(
              padding: const EdgeInsets.all(20),
              color: theme == ThemeState.light? Colors.white: Colors.black,
              child: const Text('Unable to load link preview.'),
            ),
            onTap: () {
              webVisit(text);
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
              color: theme == ThemeState.light ? Colors.white : Colors.black,
                borderRadius: const BorderRadius.all(Radius.circular(5))
              ),
              child: InkWell(
                onTap: () {
                  webVisit(text);
                },
                child: const Icon(Icons.open_in_new, color: Colors.grey),
              ),
            ),
          ),
        ],
      );
    } else {
      child = DetectableText(
        text: text,
        detectionRegExp: detectionRegExp()!,
        basicStyle: const TextStyle(fontSize: 12),
        detectedStyle: const TextStyle(fontSize: 12, color: Colors.blue),
        onTap: (tag) {
          if (containsHashtags) {
            HashtagModel? tappedHashTagged;
            for (HashtagModel hashtag in hashtags) {
              if (hashtag.tag!.startsWith(tag)) {
                tappedHashTagged = hashtag;
                break;
              }
            }
            if (tappedHashTagged != null) {
              switch(tappedHashTagged.type) {
                case 'USER':
                  Navigator.pushNamed(
                    context,
                    Routes.friendProfile,
                    arguments: {'uid': tappedHashTagged.tag!.split('::')[1]},
                  );
                  break;
                case 'URL':
                  webVisit(tappedHashTagged.tag!);
                  break;
              }
            }
          }
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: child,
    );
  }
}
