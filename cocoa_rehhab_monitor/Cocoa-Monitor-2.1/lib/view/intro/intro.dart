import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cocoa_monitor/view/routes.dart' as route;

class IntroScreen extends StatefulWidget {
  static String routeName = '/introScreen';
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  final introKey = GlobalKey<IntroductionScreenState>();

  Future<void> _onIntroEnd(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('byPassIntro', true);
    Get.offNamed(route.trackMyTreeIndex);
  }


  Widget _buildImage(String assetName, [double width = 350]) {
    // return Image.asset('assets/$assetName', width: width);
    return SvgPicture.asset(
        'assets/icon/$assetName',
        width: width
    );
  }


  @override
  Widget build(BuildContext context) {

    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );


    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      // isTopSafeArea: false,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: Hero(
                  tag: "welcomeHero",
                  child: Image.asset('assets/logo/green_ghana_logo.png', width: 60)
              )
          ),
        ),
      ),
      // globalFooter: SizedBox(
      //   width: double.infinity,
      //   height: 60,
      //   child: ElevatedButton(
      //     child: const Text(
      //       'Let\'s go right away!',
      //       style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      //     ),
      //     onPressed: () => _onIntroEnd(context),
      //   ),
      // ),
      pages: [
        PageViewModel(
          // titleWidget: Container(),
          title: "Welcome",
          body: "Welcome to Green Ghana Tracker",
          // bodyWidget: Text("Welcome to Green Ghana Tracker",
          //   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.5, color: Colors.black87),
          //   textAlign: TextAlign.center,
          // ),
          image: Image.asset('assets/logo/green_ghana_logo.png', width: MediaQuery.of(context).size.width * 0.4),
          decoration: pageDecoration,
        ),
        PageViewModel(
          // titleWidget: Container(),
          title: "Seedling Request",
          body: "Request for seedling without hassle",
          // bodyWidget: Text("Request for seedling without hassle",
          //   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.5, color: Colors.black87),
          //   textAlign: TextAlign.center,
          // ),
          image: _buildImage('seedling_request.svg', MediaQuery.of(context).size.width * 0.6),
          decoration: pageDecoration,
        ),
        PageViewModel(
          // titleWidget: Container(),
          title: "Tree Tagging",
          // bodyWidget: Text("Get noticed by easily tagging your tree",
          //   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.5, color: Colors.black87),
          //   textAlign: TextAlign.center,
          // ),
          body: "Get noticed by easily tagging the tree you plant",
          image: _buildImage('tag_tree.svg', MediaQuery.of(context).size.width * 0.6),
          decoration: pageDecoration,
        ),
        PageViewModel(
          // titleWidget: Container(),
          title: "Get Updated",
          // bodyWidget: Text("See trees that others are planting",
          //   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.5, color: Colors.black87),
          //   textAlign: TextAlign.center,
          // ),
          body: "See trees that others are planting",
          image: _buildImage('people_post.svg', MediaQuery.of(context).size.width * 0.6),
          decoration: pageDecoration,
        ),
        PageViewModel(
          // titleWidget: Container(),
          title: "Get Interactive",
          // bodyWidget: Text("Get the interaction going by applauding and commenting on tags",
          //   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.5, color: Colors.black87),
          //   textAlign: TextAlign.center,
          // ),
          body: "Get the interaction going by applauding and commenting on tags",
          image: _buildImage('discussion.svg', MediaQuery.of(context).size.width * 0.6),
          decoration: pageDecoration,
        ),
        PageViewModel(
          // titleWidget: Container(),
          title: "View Statistics",
          // bodyWidget: Text("Easily follow the trend of the Green Ghana Exercise",
          //   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.5, color: Colors.black87),
          //   textAlign: TextAlign.center,
          // ),
          body: "Easily follow the trend of the Green Ghana Exercise",
          image: _buildImage('green_ghana_status.svg', MediaQuery.of(context).size.width * 0.6),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0XFF002424))),
      next: const Icon(Icons.arrow_forward, color: Color(0XFF002424)),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0XFF002424))),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        // color: Color(0XFF002424),
        activeColor: Color(0XFF002424),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      // dotsContainerDecorator: const ShapeDecoration(
      //   color: Colors.black87,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(8.0)),
      //   ),
      // ),
    );

  }
}
