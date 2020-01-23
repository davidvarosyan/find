import 'package:find/shared/widgets/blocks/missing_list_block.dart';
import 'package:find/shared/widgets/blocks/pick-image-block.dart';
import 'package:find/shared/widgets/components/default-drawer.dart';
import 'package:find/shared/widgets/components/default-title.dart';
import 'package:find/shared/widgets/components/floating-action-button-picker-image.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DefaultDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: DefaultTitle(
          fontSize: 20.0,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                PickImageBlock(),
                SizedBox(
                  height: 20.0,
                ),
                MissingListBlock(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButtonPickerImage(),
    );
  }
}
