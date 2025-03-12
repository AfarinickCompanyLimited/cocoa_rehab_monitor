import 'package:flutter/material.dart';


class SpeedDialFab extends StatefulWidget {
  const SpeedDialFab({Key? key, 
    this.child,
    this.speedDialChildren,
    this.labelsStyle,
    this.controller,
    this.closedForegroundColor,
    this.openForegroundColor,
    this.closedBackgroundColor,
    this.openBackgroundColor,
    this.labelBackgroundColor,
    this.speedDialIsMini = false,
  }) : super(key: key);

  final Widget? child;

  final List<SpeedDialChild>? speedDialChildren;

  final TextStyle? labelsStyle;

  final AnimationController? controller;

  final Color? closedForegroundColor;

  final Color? openForegroundColor;

  final Color? closedBackgroundColor;

  final Color? openBackgroundColor;

  final Color? labelBackgroundColor;

  final bool? speedDialIsMini;

  @override
  State<StatefulWidget> createState() {
    return _SpeedDialState();
  }
}

class _SpeedDialState extends State<SpeedDialFab> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<Color?> _foregroundColorAnimation;
  final List<Animation<double>> _speedDialChildAnimations = <Animation<double>>[];

  @override
  void initState() {
    _animationController =
        widget.controller ?? AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _backgroundColorAnimation = ColorTween(
      begin: widget.closedBackgroundColor,
      end: widget.openBackgroundColor,
    ).animate(_animationController);

    _foregroundColorAnimation = ColorTween(
      begin: widget.closedForegroundColor,
      end: widget.openForegroundColor,
    ).animate(_animationController);

    final double fractionOfOneSpeedDialChild = 1.0 / widget.speedDialChildren!.length;
    for (int speedDialChildIndex = 0; speedDialChildIndex < widget.speedDialChildren!.length; ++speedDialChildIndex) {
      final List<TweenSequenceItem<double>> tweenSequenceItems = <TweenSequenceItem<double>>[];

      final double firstWeight = fractionOfOneSpeedDialChild * speedDialChildIndex;
      if (firstWeight > 0.0) {
        tweenSequenceItems.add(TweenSequenceItem<double>(
          tween: ConstantTween<double>(0.0),
          weight: firstWeight,
        ));
      }

      tweenSequenceItems.add(TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: fractionOfOneSpeedDialChild,
      ));

      final double lastWeight =
          fractionOfOneSpeedDialChild * (widget.speedDialChildren!.length - 1 - speedDialChildIndex);
      if (lastWeight > 0.0) {
        tweenSequenceItems.add(TweenSequenceItem<double>(tween: ConstantTween<double>(1.0), weight: lastWeight));
      }

      _speedDialChildAnimations.insert(0, TweenSequence<double>(tweenSequenceItems).animate(_animationController));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int speedDialChildAnimationIndex = 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (!_animationController.isDismissed)
          Padding(
            padding: EdgeInsets.only(right: widget.speedDialIsMini! ? 0 : 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widget.speedDialChildren?.map<Widget>((SpeedDialChild speedDialChild) {
                final Widget speedDialChildWidget = Opacity(
                  opacity: _speedDialChildAnimations[speedDialChildAnimationIndex].value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0 - 4.0),
                        child: Card(
                          elevation: 0.30,
                          color: widget.labelBackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: Text(
                              speedDialChild.label!,
                              style: widget.labelsStyle,
                            ),
                          ),
                        ),
                      ),
                      ScaleTransition(
                        scale: _speedDialChildAnimations[speedDialChildAnimationIndex],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: FloatingActionButton(
                            heroTag: speedDialChildAnimationIndex,
                            elevation: 1,
                            mini: true,
                            foregroundColor: speedDialChild.foregroundColor,
                            backgroundColor: speedDialChild.backgroundColor,
                            onPressed: () {
                              if (speedDialChild.closeSpeedDialOnPressed) {
                                _animationController.reverse();
                              }
                              speedDialChild.onPressed?.call();
                            },
                            child: speedDialChild.child,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                speedDialChildAnimationIndex++;
                return speedDialChildWidget;
              }).toList() ??
                  <Widget>[],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FloatingActionButton(
            mini: widget.speedDialIsMini!,
            foregroundColor: _foregroundColorAnimation.value,
            backgroundColor: _backgroundColorAnimation.value,
            onPressed: () {
              if (_animationController.isDismissed) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            },
            child: widget.child,
          ),
        )
      ],
    );
  }
}


class SpeedDialChild {
  const SpeedDialChild({
    this.child,
    this.foregroundColor,
    this.backgroundColor,
    this.label,
    this.onPressed,
    this.closeSpeedDialOnPressed = true,
  });

  final Widget? child;

  final Color? foregroundColor;

  final Color? backgroundColor;

  final String? label;

  final Function? onPressed;

  final bool closeSpeedDialOnPressed;
}
