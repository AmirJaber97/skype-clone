import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rogchat/app/locator.dart';
import 'package:rogchat/constants/app_colors.dart';
import 'package:rogchat/constants/app_routes.dart';
import 'package:rogchat/enums/notifier_state.dart';
import 'package:rogchat/services/push_notifications_service.dart';
import 'package:rogchat/ui/views/login/login_viewmodel.dart';
import 'package:shimmer/shimmer.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBlackColor,
        body: Center(child: loginButton()));
  }

  Widget loginButton() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: senderColor,
      child: Consumer<LoginViewModel>(
        builder: (context, LoginViewModel model, widget) {
          return model.state == NotifierState.Loading
              ? CircularProgressIndicator()
              : FlatButton(
                  padding: EdgeInsets.all(35.0),
                  child: Text('Login'),
                  onPressed: () => performLogin(model),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0)),
                );
        },
      ),
    );
  }

  void performLogin(LoginViewModel model) {
    model.signIn().then((user) {
      if (user != null) {
        print("User is not null, authenticating...");
        authenticateUser(model, user);
      } else {
        print("Failed to sign in");
      }
    });
  }

  void authenticateUser(LoginViewModel model, FirebaseUser user) {
    model.authenticateUser(user).then((isNewUser) {
      if (isNewUser) {
        model.register(user).then((value) {
          Get.offAndToNamed(RoutePaths.Home);
        });
      } else {
        Get.offAndToNamed(RoutePaths.Home);
      }
    });
  }
}
