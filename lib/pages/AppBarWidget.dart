import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final User? user;
  const HomeAppBar({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: const Text('Fire cars'),
      elevation: 0.8,
      floating: true,
      forceElevated: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () => Beamer.of(context).beamToNamed('/profile'),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Tooltip(
                message: 'Votre profile',
                child: Hero(
                  tag: user?.photoURL ?? 'default',
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user?.photoURL ??
                        'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAsJCQcJCQcJCQkJCwkJCQkJCQsJCwsMCwsLDA0QDBEODQ4MEhkSJRodJR0ZHxwpKRYlNzU2GioyPi0pMBk7IRP/2wBDAQcICAsJCxULCxUsHRkdLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCz/wAARCADqAU4DASIAAhEBAxEB/8QAFgABAQEAAAAAAAAAAAAAAAAAAAEH/8QAFRABAQAAAAAAAAAAAAAAAAAAACH/xAAUAQEAAAAAAAAAAAAAAAAAAAAA/8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAwDAQACEQMRAD8A1sIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAClAClAClAClAClAClAClAClAClAClAClAClAClAClAClAClAClAClAClAClAClAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACEACEACEACEACEACEACEACEACEACEACEACEACEACEACEACEACEACEACEACEACEAAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAIQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEBRFAEUAEBQAAAAABFAEUAQBQABFABAUAARQAAAAAAAQFBAURQf//Z'),
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
