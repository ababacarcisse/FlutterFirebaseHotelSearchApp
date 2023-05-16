import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/addToTaxiWidget.dart';
import 'AppBarWidget.dart';

class PageInfo extends StatefulWidget {
  const PageInfo({super.key});

  @override
  State<PageInfo> createState() => _PageInfoState();
}

class _PageInfoState extends State<PageInfo> {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: kIsWeb ? true : false,
          trackVisibility: kIsWeb ? true : false,
          child: CustomScrollView(slivers: [
            HomeAppBar(user: _user),
            AddToTaxiSectionWidget(user: _user),
          ]),
        ),
      ),
    );
  }
}
