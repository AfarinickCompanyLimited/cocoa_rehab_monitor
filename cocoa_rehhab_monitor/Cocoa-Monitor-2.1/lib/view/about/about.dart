// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () =>  Navigator.of(context).pop(),
            child: Icon(appIconBackOld, color: appColorButtonTextBlack, size: 20,),
          ),
          // title: GestureDetector(
          //   onTap: () =>  Navigator.of(context).pop(),
          //   child: Icon(appIconBack, color: appColorButtonTextBlack, size: 20,),
          // ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: appMainHorizontalPadding),
          child: Column(
            children: [

              // SizedBox(height: 10,),

              Center(
                child: Image.asset("assets/logo/green_ghana_logo.png",
                  fit: BoxFit.contain, height: MediaQuery.of(context).size.width * 0.2,
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text("Green Ghana Tracker",
                  style: TextStyle(
                      color: appColorPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 18
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("The Green Ghana Initiative seeks to create a collective action towards restoration of degraded landscapes in the country, "
                  "mitigate climate change and inculcate in the youth the values of planting and nurturing trees",
              style: TextStyle(height: 1.6),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),

              const Text("The App is developed by the Forestry Commission of Ghana to facilitate easy seedling request and monitoring of the planted trees",
                style: TextStyle(height: 1.6),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 10),

              Center(
                child: Image.asset("assets/logo/fcghana.png",
                  fit: BoxFit.contain, height: MediaQuery.of(context).size.width * 0.2,
                ),
              ),

              const SizedBox(height: 20),

              const Divider(),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Powered by Bigdata Ghana Limited",
                        style: TextStyle(height: 1.6, fontSize: 12),
                        textAlign: TextAlign.justify,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: tmtColorSecondary, backgroundColor: tmtColorSecondary.shade50,
                          minimumSize: const Size(0, 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.xl))
                          ),
                        ),
                        onPressed: () => _launchMailClient(),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("info@bigdataghana.com",
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),

                    ],
                  ),
                  Image.asset("assets/logo/bdg.png",
                    fit: BoxFit.contain, height: MediaQuery.of(context).size.width * 0.20,
                  ),
                ],
              ),

              const SizedBox(height: 10),



            ],
          ),
        )
      ),
    );
  }


  void _launchMailClient() async {
    const mailUrl = 'mailto:info@bigdataghana.com?subject=Green Ghana Tracker: CONTACT DEVELOPER';
    try {
      await launchUrl(Uri.parse(mailUrl));
    } catch (e) {
      print(e.toString());
    }
  }


}
