import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class AdsSlider extends StatefulWidget {
  @override
  State<AdsSlider> createState() => _AdsSliderState();
}

class _AdsSliderState extends State<AdsSlider> {

  List ads = [];
  int currentIndex = 0;
  PageController controller = PageController();

  Future fetchAds() async {
    final data = await ApiService.get("/ads");

    setState(() {
      ads = data;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAds();

    // 🔥 autoplay
    Future.delayed(Duration(seconds: 3), autoPlay);
  }

  void autoPlay() {
    if (controller.hasClients && ads.isNotEmpty) {
      int next = (currentIndex + 1) % ads.length;

      controller.animateToPage(
        next,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

      currentIndex = next;
    }

    Future.delayed(Duration(seconds: 3), autoPlay);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ads.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [

                // 🔥 Slider
                Expanded(
                  child: PageView.builder(
                    controller: controller,
                    onPageChanged: (index) {
                      setState(() => currentIndex = index);
                    },
                    itemCount: ads.length,
                    itemBuilder: (context, index) {
                      final ad = ads[index];

                      return GestureDetector(
                        onTap: () async {
                          final url = Uri.parse(ad["link"]);
                          if (await canLaunchUrl(url)) {
                            launchUrl(url);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                ad["image"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 8),

                // 🔥 Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(ads.length, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: currentIndex == index ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),

              ],
            ),
    );
  }
}