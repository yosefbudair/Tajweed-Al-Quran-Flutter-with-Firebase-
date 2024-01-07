import 'package:flutter/material.dart';
import 'package:tajweed/appbar.dart';
import 'package:tajweed/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class suggestions extends StatelessWidget {
  const suggestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBarScreen(
              title: 'المقترحات',
            ),
            endDrawer: drawer(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    isThreeLine: true,
                    trailing: Image.asset("images/كتاب المنير.jpg"),
                    title: Text("كتاب المنير"),
                    subtitle: InkWell(
                      child: Text(
                        'انقر هنا للذهاب للموقع',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () => {_launchUrl("bit.ly", "/3HiDWeA")},
                    ),
                  ),
                  ListTile(
                    // leading: Text("منهاج الدارسين"),
                    trailing: Image.asset("images/كتاب منهاج الدارسين.jpg"),
                    title: Text("كتاب منهاج الدارسين"),
                    subtitle: InkWell(
                        child: Text(
                          'انقر هنا للذهاب للموقع',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onTap: () => _launchUrl("bit.ly", "/3Y7ezDA")),
                  ),
                  ListTile(
                    trailing: Image.asset("images/شرح خادم القران.jpg"),
                    title: Text(" شرح خادم القرآن الكريم علاء معن نصيرات"),
                    subtitle: InkWell(
                        child: Text(
                          'انقر هنا للذهاب للموقع',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onTap: () => _launchUrl("bit.ly", "/3kREroh")),
                  ),
                  ListTile(
                    trailing: Image.asset("images/ايمن سويد.jpg"),
                    title: Text("تعلم التجويد مع الشيخ أيمن سويد"),
                    subtitle: InkWell(
                        child: Text(
                          'انقر هنا للذهاب للموقع',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onTap: () {
                          _launchUrl("bit.ly", "/3jcLUxX");
                        }),
                  ),
                ],
              ),
            )));
  }

  Future<void> _launchUrl(String url, String path) async {
    final Uri uri = Uri(scheme: "https", host: url, path: path);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch url');
    }
  }
}
