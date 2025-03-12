import 'package:flutter/material.dart';
import 'package:cocoa_rehab_monitor/view//utils/style.dart';

class GridContainer extends StatefulWidget {
  final String? image;
  final String? label;
  final double? gap;
  final VoidCallback? onTap;
  final Color? color, borderColor;


  const GridContainer({
    Key? key,
    this.image,
    this.label,
    this.gap,
    this.onTap, this.color, this.borderColor,
  }) : super(key: key);

  @override
  _GridContainerState createState() => _GridContainerState();
}

class _GridContainerState extends State<GridContainer> with SingleTickerProviderStateMixin {

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
          ),
          child: Column(
            children: [
              SizedBox(height: 5),
              Image.asset(
                widget.image!,
                height: 30,
                width: 30,
              ),
              SizedBox(height: widget.gap ?? 5),
              Text(
                widget.label ?? "",
                style: TextStyle(color: AppColor.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
