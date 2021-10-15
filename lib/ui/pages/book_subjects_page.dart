import 'package:books_app/bloc/auth_cubit.dart';
import 'package:books_app/bloc/books_cubit.dart';
import 'package:books_app/ui/constants.dart';
import 'package:books_app/ui/pages/home_page.dart';
import 'package:books_app/ui/widgets/def_button.dart';
import 'package:books_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../size_config.dart';

class BookSubjPage extends StatefulWidget {
  const BookSubjPage({Key? key}) : super(key: key);

  @override
  _BookSubjPageState createState() => _BookSubjPageState();
}

class _BookSubjPageState extends State<BookSubjPage>
    with TickerProviderStateMixin {
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
  Future<void> startTransitionAnimation() async {
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

    AnimationController animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    entry = OverlayEntry(builder: (c) {
      return GestureDetector(
          onTap: () {
            removeEntry();
          },
          child: PageTransitionOverlay(
              animationController: animController,
              nextButKey: nextButKey,
              keys: keys,
              backColor: const Color(0xffEDF3FA)));
    });
    Overlay.of(context)?.insert(entry);
    // Duration dur =
    //     Duration(milliseconds: animController.duration!.inMilliseconds);
    Duration dur =
        animController.duration!; //when the screen is filled with blue
    dur = dur * (0.6 + 2 * 0.4 / 3);

    animController.forward();
    await Future.delayed(dur);
    Navigator.of(context).pushReplacement(
        PageRouteBuilder(pageBuilder: (c, animation, secondaryAnimation) {
      return BlocProvider(
        lazy: false,
        create: (c) => BooksCubit(
            (context.read<AuthCubit>().state as UserLogedState).user),
        child: const HomePage(),
      );
    }, transitionsBuilder: (c, animation, secondatyAnimation, child) {
      return child;
    }));

    await Future.delayed(animController.duration! - dur);
    removeEntry();
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
                    startTransitionAnimation();
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

class PageTransitionOverlay extends StatefulWidget {
  final List<GlobalKey> keys;
  final Color backColor;
  final GlobalKey nextButKey;
  final AnimationController animationController;
  const PageTransitionOverlay(
      {Key? key,
      required this.animationController,
      required this.keys,
      required this.backColor,
      required this.nextButKey})
      : super(key: key);

  @override
  _PageTransitionOverlayState createState() => _PageTransitionOverlayState();
}

class _PageTransitionOverlayState extends State<PageTransitionOverlay> {
  late List<Rect> rects;
  late Rect nextButRect;
  //first part  : the subjects flow to next button
  // seconde part: the next button scale
  //thrid part is the reverse of the seconde part
  late Animation<double> firtPartAnimation = Tween<double>(begin: 0, end: 1)
      .animate(CurvedAnimation(
          parent: widget.animationController, curve: const Interval(0, .6)));
  late Animation<double> secondePartAnimation = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: .25),
    TweenSequenceItem(tween: Tween(begin: 1, end: 1), weight: .5),
    TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: .25),
  ]).animate(CurvedAnimation(
      parent: widget.animationController,
      curve: const Interval(.6, 1, curve: Curves.easeOut)));

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
    // animationController = AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 1000));
    // animationController.forward();
    // print("rects :  $rects");
  }

  @override
  void dispose() {
    widget.animationController.dispose();
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
                  animation: widget.animationController,
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
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.circular(30),
                      color: mainColor),
                ),
              ),
            ),
          ]),
        ));
  }
}
