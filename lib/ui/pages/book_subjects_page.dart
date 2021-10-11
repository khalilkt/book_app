import 'package:books_app/ui/constants.dart';
import 'package:books_app/ui/pages/home_page.dart';
import 'package:books_app/ui/widgets/def_button.dart';
import 'package:books_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';

class BookSubjPage extends StatefulWidget {
  const BookSubjPage({Key? key}) : super(key: key);

  @override
  _BookSubjPageState createState() => _BookSubjPageState();
}

class _BookSubjPageState extends State<BookSubjPage> {
  final List<String> subjects = [
    "Biography",
    "Business",
    "Cooking",
    "Fiction",
    "History",
    "Horror",
    "Programming",
    "Science",
    "self help",
  ];

  List<bool> selection = List.generate(9, (index) => false);
  List<GlobalKey> subjectsKeys = List.generate(9, (index) => GlobalKey());
  GlobalKey nextButKey = GlobalKey();

  //THE SHOOW! jk
  Future<void> startAnimation() async {
    List<GlobalKey> keys = [];
    //getting the globalkeys for the subjectscontainers that are selected
    for (int i = 0; i < selection.length; i++) {
      if (selection[i]) {
        keys.add(subjectsKeys[i]);
      }
    }

    late OverlayEntry entry;
    void removeEntry() {
      entry.remove();
    }

    entry = OverlayEntry(builder: (c) {
      return GestureDetector(
          onTap: () {
            removeEntry();
          },
          child: OverlayPageTransition(
              nextButKey: nextButKey,
              keys: keys,
              backColor: const Color(0xffEDF3FA)));
    });
    Overlay.of(context)?.insert(entry);
  }

  Widget _buildSubjectRow(int sIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (i) {
        int index = sIndex + i;
        return DefTapAnimation(
          end: 1.1,
          onTap: () {
            setState(() {
              selection[index] = !selection[index];
            });
          },
          child: SubjectContainer(
            key: subjectsKeys[index],
            name: subjects[index],
            selected: selection[index],
            path: 'assets/images/subjects/' +
                subjects[index].replaceAll(" ", "-") +
                ".png",
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEDF3FA),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Choose your \nfavorite genres",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w800,
                      fontSize: SizeConfig.ww * .8),
                ),
              ),
              _buildSubjectRow(0),
              _buildSubjectRow(3),
              _buildSubjectRow(6),
              DefButton(
                  key: nextButKey,
                  backColor: selection.contains(true) ? mainColor : Colors.grey,
                  text: "Next",
                  onTap: () async {
                    startAnimation();
                    await Future.delayed(Duration(seconds: 1));
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (c) {
                      return HomePage();
                    }));
                  },
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 38))
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectContainer extends StatelessWidget {
  final String name;
  final String path;
  final bool selected;

  const SubjectContainer(
      {Key? key,
      required this.name,
      required this.path,
      required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ClipOval(
          child: ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(colors: [Colors.black, Colors.black])
                  .createShader(rect);
            },
            blendMode: selected ? BlendMode.colorDodge : BlendMode.hue,
            child: Image.asset(path,
                width: SizeConfig.ww * 2.2,
                height: SizeConfig.ww * 2.2,
                fit: BoxFit.fill),
          ),
        ),
        Text(name,
            style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: 16))
      ],
    );
  }
}

class OverlayPageTransition extends StatefulWidget {
  final List<GlobalKey> keys;
  final Color backColor;
  final GlobalKey nextButKey;
  const OverlayPageTransition(
      {Key? key,
      required this.keys,
      required this.backColor,
      required this.nextButKey})
      : super(key: key);

  @override
  _OverlayPageTransitionState createState() => _OverlayPageTransitionState();
}

class _OverlayPageTransitionState extends State<OverlayPageTransition>
    with TickerProviderStateMixin {
  late List<Rect> rects;
  late Rect nextButRect;
  late AnimationController animationController;
  late Animation<double> firtPartAnimation = Tween<double>(begin: 0, end: 1)
      .animate(CurvedAnimation(
          parent: animationController, curve: const Interval(0, .6)));
  late Animation<double> secondePartAnimation = Tween<double>(begin: 0, end: 1)
      .animate(CurvedAnimation(
          parent: animationController,
          curve: Interval(.8, 1, curve: Curves.easeInCubic)));

  @override
  void initState() {
    super.initState();
    nextButRect = _renderBoxToRect(
        (widget.nextButKey.currentContext!.findRenderObject() as RenderBox));
    rects = [];
    for (GlobalKey k in widget.keys) {
      rects.add(_renderBoxToRect(
          (k.currentContext!.findRenderObject() as RenderBox)));
    }
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    animationController.forward();
    // print("rects :  $rects");
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Rect _renderBoxToRect(RenderBox renderBox) {
    double x = renderBox.localToGlobal(Offset.zero).dx;
    double y = renderBox.localToGlobal(Offset.zero).dy;

    double w = renderBox.size.width;
    double h = renderBox.size.height;

    return Rect.fromLTWH(x, y, w, h);
  }

  Widget _keyToSubjectContainer(GlobalKey key) {
    SubjectContainer cont = key.currentWidget as SubjectContainer;
    String name = cont.name;
    String path = cont.path;

    return SubjectContainer(name: name, path: path, selected: true);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(children: [
            ...List.generate(rects.length, (index) {
              return Positioned(
                left: rects[index].left,
                top: rects[index].top,
                child: Container(
                  width: rects[index].width,
                  height: rects[index].height,
                  color: widget.backColor,
                ),
              );
            }),
            ...List.generate(rects.length, (index) {
              return AnimatedBuilder(
                  animation: animationController,
                  child: _keyToSubjectContainer(widget.keys[index]),
                  builder: (context, w) {
                    Tween<Offset> tween = Tween(
                        begin: rects[index].topLeft,
                        end: nextButRect.center -
                            Offset(rects[index].width / 2,
                                rects[index].height / 2));
                    double start = (1 / rects.length) * index;
                    start = index * .6 / rects.length;
                    double maxStart = (rects.length - 1) * .6 / rects.length;
                    double end = start + (1 - maxStart);
                    Offset v = tween.transform(
                        Interval(start, end, curve: Curves.easeIn)
                            .transform(firtPartAnimation.value));
                    double opac = const Interval(.3, .9).transform(
                        Interval(start, end)
                            .transform(firtPartAnimation.value));
                    return Positioned(
                      left: v.dx,
                      top: v.dy,
                      child: Opacity(
                        opacity: 1 - opac,
                        child: w!,
                      ),
                    );
                  });
            }),
            Positioned(
              top: nextButRect.top,
              left: nextButRect.left,
              child: AnimatedBuilder(
                animation: secondePartAnimation,
                builder: (_, w) {
                  return Transform.scale(
                    scale: secondePartAnimation.value * 28,
                    alignment: Alignment.center,
                    child: w!,
                  );
                },
                child: Container(
                  width: nextButRect.width,
                  height: nextButRect.height,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: mainColor),
                ),
              ),
            ),
          ]),
        ));
  }
}
