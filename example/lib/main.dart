import 'package:carousel_nerdzlab/carousel_nerdzlab.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child: CenteredPageView.builder(
                itemCount: 9,
                physics: const BouncingScrollPhysics(),
                controller: PageController(viewportFraction: 0.8),
                indicatorStyle: const IndicatorStyle(
                    indicatorWidth: 100, unselectedSize: Size(8, 8)),
                itemBuilder: (context, index) => Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(color: Colors.amber),
                    child: Align(
                      child: Text(
                        'Page $index',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
