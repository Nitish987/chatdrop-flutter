import 'package:chatdrop/shared/bloc/notifier/notifier_bloc.dart';
import 'package:chatdrop/shared/bloc/notifier/notifier_event.dart';
import 'package:chatdrop/shared/bloc/notifier/notifier_state.dart';
import 'package:chatdrop/modules/dashboard/presentation/widgets/notification.dart';
import 'package:chatdrop/shared/models/notification_model/notification_model.dart';
import 'package:chatdrop/shared/widgets/list_tile_shimmer_loading.dart';
import 'package:chatdrop/shared/widgets/loading.dart';
import 'package:chatdrop/shared/widgets/messages.dart';
import 'package:chatdrop/shared/illustrations/nothing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({Key? key}) : super(key: key);

  @override
  State<FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  final ScrollController _scrollController = ScrollController();
  int _page = 2;
  bool _hasNext = false;

  void fetchNotifications() {
    BlocProvider.of<NotifierBloc>(context).add(ListNotificationEvent(page: _page));
    _page += 1;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset == _scrollController.position.maxScrollExtent && _hasNext) {
        fetchNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotifierBloc, NotifierState>(
      builder: (context, state) {
        if (state is FailedNotificationListState) {
          return ErrorMessage(message: state.error);
        }
        if (state is NotificationListState) {
          List<NotificationModel> notifications = state.notifications;
          _hasNext = state.hasNext;

          if (notifications.isEmpty) {
            return const Nothing(
              label: 'No new notification.',
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: notifications.length + 1,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index < notifications.length) {
                NotificationModel model = notifications[index];

                return NotificationView(
                  key: Key(model.id.toString()),
                  model: model,
                );
              } else {
                if (state.hasNext) {
                  return const Padding(
                    padding: EdgeInsets.all(10),
                    child: Loading(),
                  );
                }
                return const Padding(
                  padding: EdgeInsets.all(10),
                  child: CenterMessage(message: "You're all caught up for now"),
                );
              }
            },
          );
        }
        return const ListTileShimmerLoading();
      },
    );
  }
}
