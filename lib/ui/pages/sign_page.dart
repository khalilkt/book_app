import 'package:books_app/ui/constants.dart';
import 'package:books_app/ui/pages/book_subjects_page.dart';
import 'package:books_app/ui/size_config.dart';
import 'package:books_app/ui/widgets/def_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum SignState { signIn, signUp }

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage>
    with SingleTickerProviderStateMixin {
  SignState state = SignState.signIn;
  late AnimationController stateAnimController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400));
  late PageController pageController = PageController(initialPage: 0);
  bool keyboardVis = false;

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
            const DefTextField(
              hint: 'Username',
            ),
            const DefTextField(
              hint: 'Email',
            ),
            const DefTextField(
              hint: 'Password',
            ),
            DefButton(
                text: "Sign Up",
                width: double.infinity,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    return const BookSubjPage();
                  }));
                }),
            keyboardVis
                ? SizedBox()
                : Row(
                    children: [
                      Text("already have an account ? ",
                          style: TextStyle(
                              color: const Color(0xff888888),
                              fontWeight: FontWeight.w400,
                              fontSize: SizeConfig.ww * .52)),
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
                              fontSize: SizeConfig.ww * .52),
                        ),
                      )
                    ],
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
            const DefTextField(
              hint: 'Username',
            ),
            const DefTextField(
              hint: 'Email',
            ),
            DefButton(
              text: "Sign In",
              width: double.infinity,
              onTap: () {},
            ),
            Text("Or",
                style: TextStyle(
                    fontSize: SizeConfig.hh * .28,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey[600])),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.grey[700]!, width: 2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const FaIcon(FontAwesomeIcons.google),
                    Text("Sign In with Google",
                        style: TextStyle(
                            fontSize: SizeConfig.hh * .3,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[600]))
                  ],
                )),
            Row(
              children: [
                Text("Don't have an account ? ",
                    style: TextStyle(
                        color: const Color(0xff888888),
                        fontWeight: FontWeight.w400,
                        fontSize: SizeConfig.ww * .52)),
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
                        fontSize: SizeConfig.ww * .52),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    keyboardVis = MediaQuery.of(context).viewInsets.bottom != 0;

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffBB7838),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: keyboardVis ? 0 : SizeConfig.h * .24,
            child:
                Image.asset('assets/images/library.png', fit: BoxFit.fitWidth),
          ),
          Expanded(
              child: PageView(
            controller: pageController,
            children: [_buildSignUpPage(), _buildSignInPage()],
          ))
        ],
      ),
    ));
  }
}

class DefTextField extends StatelessWidget {
  final String hint;
  const DefTextField({Key? key, required this.hint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xffE8ECF0),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xff707070), width: 2)),
      child: TextField(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          hintStyle: const TextStyle(
              color: Color(0xff878A9E),
              fontSize: 22,
              fontWeight: FontWeight.w500),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}