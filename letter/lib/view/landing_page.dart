
import 'package:flutter/material.dart';
import 'package:letter/view/home_page.dart';
import 'package:letter/view/login_page.dart';
import 'package:letter/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    if (userViewModel.state == ViewState.Idle) {
      if (userViewModel.appUser == null) {
        return const LoginPage();
      } else {
        return const HomePage();
      }
    } else {
      return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('images/background_image.png'),
              ),
            ),
            const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                color: Colors.indigo,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              child: const Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.indigo,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}
