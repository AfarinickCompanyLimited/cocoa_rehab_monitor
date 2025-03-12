import 'package:flutter/material.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';

class GridContainer2 extends StatefulWidget {
  final String? label;
  final double? gap;
  final VoidCallback? onTap;
  final Color? color, borderColor;
  final IconData? icon;


  const GridContainer2({
    Key? key,
    this.label,
    this.gap,
    this.onTap, this.color, this.borderColor, this.icon,
  }) : super(key: key);

  @override
  _GridContainer2State createState() => _GridContainer2State();
}

class _GridContainer2State extends State<GridContainer2> with SingleTickerProviderStateMixin {

  // AnimationController to control the animation
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Define the bounce-in curve
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    // Dispose the controller to free resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation, // Apply the animation
      child: GestureDetector(
        onTap: widget.onTap, // Handle tap events
        child: Container(
          height: 90,
          width: 100,
          decoration: BoxDecoration(
            color: widget.color??AppColor.black,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: widget.borderColor??AppColor.white, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              Icon(widget.icon, color: AppColor.black, size: 30),
              SizedBox(height: 10),
              Text(
                widget.label ?? "",
                style: TextStyle(color: AppColor.black, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
