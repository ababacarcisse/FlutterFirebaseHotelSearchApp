import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugnu_taxi/pages/LoginPage.dart';
import 'package:sugnu_taxi/pages/pageInfo.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return _user == null ? Login() : const PageInfo();
  }
}
