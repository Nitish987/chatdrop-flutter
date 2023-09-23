import 'package:chatdrop/shared/bloc/search/search_bloc.dart';
import 'package:chatdrop/shared/bloc/search/search_event.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/tools/avatar_image_provider.dart';
import 'package:chatdrop/shared/widgets/list_tile_shimmer_loading.dart';
import 'package:chatdrop/shared/widgets/messages.dart';
import 'package:chatdrop/shared/illustrations/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/bloc/search/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _queryController,
          autofocus: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: const TextStyle(
              fontSize: 20,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                _queryController.text = '';
              },
              icon: const Icon(
                Icons.clear,
                color: Colors.blue,
              ),
            ),
            border: InputBorder.none,
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)
            ),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)
            ),
          ),
          onSubmitted: (value) {
            BlocProvider.of<SearchBloc>(context).add(StartProfileSearchingEvent(value));
          },
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchInitialState) {
            return const Search();
          }
          else if (state is SearchSuccessState<UserModel>) {
            return ListView.builder(
              itemCount: state.result.length,
              itemBuilder: (context, index) {
                UserModel searchProfile = state.result[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: Avatar.getAvatarProvider(
                      searchProfile.gender.toString(),
                      searchProfile.photo,
                    ),
                  ),
                  title: Text(searchProfile.name.toString()),
                  subtitle: Text(searchProfile.message.toString()),
                  onTap: () {
                    Navigator.pushNamed(context, Routes.friendProfile, arguments: {
                      'uid': searchProfile.uid
                    });
                  },
                );
              },
            );
          }
          else if (state is SearchFailedState) {
            return ErrorMessage(message: state.error);
          } else {
            return const ListTileShimmerLoading();
          }
        },
      ),
    );
  }
}
