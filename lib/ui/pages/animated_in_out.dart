// I usally want to animate widget when they are disposing,
// like start an aniimation and the push the page route..
// I didnt found a way to impletment it expect with the global key (luch the animation form the state, expl : (globKey.state as WidgetSate).animationController.start())
// What I did is create an interface and implementing it on every widdget(or page) that needs this type of behaviour
// now I can do somgh like this  :
// if (widget is OutAnimatedPage then await widget.animatedOut() => push the screen)
class OutAnimatedPage {
  Future<void> animateOut() async {}
}
