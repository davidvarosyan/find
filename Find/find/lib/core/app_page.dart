import 'package:find/shared/colors/default_colors.dart';
import 'package:find/shared/widgets/blocks/animated-title-auth-block.dart';
import 'package:find/shared/widgets/components/animated-color-background.dart';
import 'package:find/shared/widgets/components/image-background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'app_controller.dart';

class AppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _controller = Provider.of<AppController>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          ImageBackground(),
          AnimatedColorBackground(),
          Align(
            alignment: Alignment.center,
            child: Observer(
              builder: (_) {
                return _controller.currentUserVerified
                    ? AnimatedTitleAuth()
                    : CircularProgressIndicator(
                        backgroundColor: DefaultColors.white,
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
