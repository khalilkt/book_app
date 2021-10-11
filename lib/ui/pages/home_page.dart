import 'package:books_app/ui/size_config.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: SizeConfig.ww, right: SizeConfig.ww / 2),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Explore thousands of books on the go",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.ww * .8,
                    fontWeight: FontWeight.bold))
          ],
        ),
      ),
    ));
  }
}
