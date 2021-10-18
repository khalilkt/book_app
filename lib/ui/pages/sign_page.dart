import 'package:books_app/bloc/auth_cubit.dart';
import 'package:books_app/bloc/books_cubit.dart';
import 'package:books_app/models/user.dart';
import 'package:books_app/ui/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:books_app/ui/size_config.dart';
import 'package:books_app/ui/widgets/def_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../logg.dart';
import 'book_subjects_page.dart';
import 'home_page.dart';

enum SignState { signIn, signUp }

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> with TickerProviderStateMixin {
  SignState state = SignState.signIn;

  late PageController pageController = PageController(initialPage: 0);
  bool keyboardVis = false;
  AuthException authException = AuthException('');

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();

  GlobalKey signInKey = GlobalKey();
  GlobalKey signUpKey = GlobalKey();

  late AnimationController outAnimController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));
  late Animation<double> outAnimation =
      Tween<double>(begin: 0, end: 1).animate(outAnimController);

  void startTransitionAnimation() async {
    await outAnimController.forward();

    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (c, a, aa, w) {
              return AnimatedBuilder(
                  animation: a,
                  builder: (c, w) {
                    return Opacity(opacity: a.value, child: w);
                  },
                  child: w);
            },
            pageBuilder: (c, a, aa) {
              User user =
                  (context.read<AuthCubit>().state as UserLogedState).user;
              if (user.favCategories.isEmpty) {
                return BlocProvider.value(
                    value: context.read<AuthCubit>(),
                    child: const BookSubjPage());
              } else {
                return MultiBlocProvider(providers: [
                  BlocProvider(create: (_) => BooksCubit(user)),
                  BlocProvider.value(
                    value: context.read<AuthCubit>(),
                  )
                ], child: const HomePage());
              }
            }));
    await Future.delayed(const Duration(milliseconds: 300));
    outAnimController.reset();
    // outAnimController.dispose();
  }

  void _showErrorToast(String message) async {
    AnimationController animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    Animation<Offset> animation =
        Tween<Offset>(begin: const Offset(0, 100), end: Offset.zero).animate(
            CurvedAnimation(parent: animController, curve: Curves.easeInOut));
    OverlayEntry entry = OverlayEntry(builder: (c) {
      return Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedBuilder(
                    animation: animation,
                    builder: (c, w) {
                      return Transform.translate(
                          offset: animation.value, child: w);
                    },
                    child: ErrorToast(message: message))),
          ));
    });
    Overlay.of(context)?.insert(entry);
    await animController.forward();
    for (int i = 0; i < 3; i++) {
      await animController.animateTo(1.2,
          duration: const Duration(milliseconds: 200));
      await animController.animateTo(.8,
          duration: const Duration(milliseconds: 200));
    }
    // await Future.delayed(const Duration(seconds: 2));
    await animController.reverse();
    entry.remove();
    animController.dispose();
  }

  Widget _buildSignUpPage() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(90))),
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(SizeConfig.ww * .9, 10, SizeConfig.ww * .9, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Sign Up',
                style: TextStyle(
                    color: mainColor,
                    fontSize: SizeConfig.hh * .44,
                    fontWeight: FontWeight.w900),
              ),
            ),
            DefTextField(
              next: true,
              controller: nameController,
              errorText: authException.type == AuthExType.signUpName
                  ? authException.message
                  : null,
              hint: 'Username',
            ),
            DefTextField(
              next: true,
              errorText: authException.type == AuthExType.signUpEmail
                  ? authException.message
                  : null,
              controller: emailController,
              hint: 'Email',
            ),
            DefTextField(
              next: false,
              errorText: authException.type == AuthExType.signUpPassword
                  ? authException.message
                  : null,
              controller: passwordController,
              password: true,
              hint: 'Password',
            ),
            DefButton(
                text: "Sign Up",
                key: signUpKey,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                onTap: () async {
                  try {
                    authException = AuthException(
                      '',
                    );
                    await context.read<AuthCubit>().signUpWithEmail(
                          nameController.text,
                          emailController.text,
                          passwordController.text,
                        );
                    startTransitionAnimation();
                  } catch (e) {
                    logg('exception in sign page is :  $e');
                    if (e is AuthException) {
                      setState(() {
                        authException = e;
                      });
                      if (e.type == null) {
                        _showErrorToast(e.message);
                      }
                      return;
                    }
                    _showErrorToast('Something Went Wrong!');
                  }
                }),
            FittedBox(
              child: Row(
                children: [
                  Text("Already have an account? ",
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          color: const Color(0xff888888),
                          fontWeight: FontWeight.w400,
                          fontSize: SizeConfig.ww * .46)),
                  GestureDetector(
                    onTap: () {
                      pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                          color: const Color(0xff888888),
                          fontWeight: FontWeight.w900,
                          fontSize: SizeConfig.ww * .46),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInPage() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(90))),
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(SizeConfig.ww * .9, 10, SizeConfig.ww * .9, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Sign In',
                style: TextStyle(
                    color: mainColor,
                    fontSize: SizeConfig.hh * .44,
                    fontWeight: FontWeight.w900),
              ),
            ),
            DefTextField(
              next: true,
              controller: signInEmailController,
              errorText: authException.type == AuthExType.signInEmail
                  ? authException.message
                  : null,
              hint: 'Email',
            ),
            DefTextField(
              next: false,
              controller: signInPasswordController,
              errorText: authException.type == AuthExType.signInPassword
                  ? authException.message
                  : null,
              password: true,
              hint: 'Password',
            ),
            DefButton(
              text: "Sign In",
              key: signInKey,
              width: double.infinity,
              onTap: () async {
                setState(() {
                  authException = AuthException(
                    '',
                  );
                });
                try {
                  await context.read<AuthCubit>().signIn(
                        signInEmailController.text,
                        signInPasswordController.text,
                      );
                  startTransitionAnimation();
                } catch (e) {
                  logg('exception in sign page is :  $e');
                  if (e is AuthException) {
                    setState(() {
                      authException = e;
                    });
                    if (e.type == null) {
                      _showErrorToast(e.message);
                    }
                    return;
                  }
                  _showErrorToast('Something Went Wrong!');
                }
              },
            ),
            keyboardVis
                ? Container()
                : Text("Or",
                    style: TextStyle(
                        fontSize: SizeConfig.hh * .28,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey[600])),
            keyboardVis
                ? Container()
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.grey[700]!, width: 2)),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          authException = AuthException(
                            '',
                          );
                        });
                        try {
                          await context.read<AuthCubit>().signInWithGoogle();
                          startTransitionAnimation();
                        } catch (e) {
                          logg('exception in sign page is :  $e');

                          _showErrorToast('Something Went Wrong!');
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const FaIcon(FontAwesomeIcons.google),
                          Text("Sign In with Google",
                              style: TextStyle(
                                  fontSize: SizeConfig.hh * .28,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[600]))
                        ],
                      ),
                    )),
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account ? ",
                      style: TextStyle(
                          color: const Color(0xff888888),
                          fontWeight: FontWeight.w400,
                          fontSize: SizeConfig.ww * .46)),
                  GestureDetector(
                    onTap: () {
                      pageController.animateTo(0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: const Color(0xff888888),
                          fontWeight: FontWeight.w900,
                          fontSize: SizeConfig.ww * .46),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    keyboardVis = MediaQuery.of(context).viewInsets.bottom != 0;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xffBB7838),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: keyboardVis ? 0 : SizeConfig.h * .24,
                  child: Image.asset('assets/images/library.png',
                      fit: BoxFit.fitWidth),
                ),
                Expanded(
                    child: PageView(
                  // physics: RangeMaintainingScrollPhysics(),
                  controller: pageController,
                  children: [_buildSignUpPage(), _buildSignInPage()],
                ))
              ],
            ),
            AnimatedBuilder(
              animation: outAnimController,
              builder: (c, w) {
                RenderBox? box =
                    ((pageController.page == 0 ? signUpKey : signInKey)
                        .currentContext
                        ?.findRenderObject() as RenderBox?);
                if (box != null) {
                  return Positioned(
                      top: box.localToGlobal(Offset.zero).dy -
                          box.size.height / 2,
                      left: box.localToGlobal(Offset.zero).dx +
                          box.size.width / 2,
                      child: Transform.scale(
                          scale: outAnimation.value * SizeConfig.w / 3,
                          child: w!));
                }
                return Container();
              },
              child: Builder(builder: (context) {
                return Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: mainColor,
                  ),
                );
              }),
            )
          ],
        ),
      )),
    );
  }
}

class DefTextField extends StatelessWidget {
  final String hint;
  final String? errorText;
  final TextEditingController controller;
  final bool password;
  final bool next;
  final InputBorder defInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(width: 2, color: Color(0xff707070)),
  );
  DefTextField(
      {Key? key,
      required this.next,
      required this.hint,
      this.password = false,
      required this.controller,
      this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        obscureText: password,
        textInputAction: next ? TextInputAction.next : TextInputAction.go,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          filled: true,
          labelText: hint,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          errorText: errorText,
          suffixIcon: errorText == null
              ? null
              : const Icon(Icons.error_outline, color: Colors.red, size: 28),
          fillColor: const Color(0xffE8ECF0),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          labelStyle: TextStyle(
              color: errorText == null ? const Color(0xff878A9E) : Colors.red,
              fontSize: 22,
              fontWeight: FontWeight.w500),
          // hintText: hint,
          border: defInputBorder,
          enabledBorder: defInputBorder,
          focusedBorder: defInputBorder,
        ));
  }
}

class ErrorToast extends StatelessWidget {
  final String message;
  const ErrorToast({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.red[100],
          border: Border.all(color: Colors.red[600]!, width: 1),
          borderRadius: BorderRadius.circular(22)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 34,
            color: Colors.red,
          ),
          const SizedBox(width: 12),
          Text(message,
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.w500))
        ],
      ),
    );
  }
}
