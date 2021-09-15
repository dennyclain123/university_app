import 'package:flutter/material.dart';
import 'package:university_searcher/ob/uni_ob.dart';
import 'package:url_launcher/url_launcher.dart';
class University extends StatelessWidget {
  UniOb uob;
  University(this.uob);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchURL(),
      child: ListTile(
        title: Text(uob.country),
        subtitle: Text(uob.name),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
  void _launchURL() async =>
      await canLaunch(uob.webPages[0]) ? await launch(uob.webPages[0]) : throw 'Could not launch $uob.webPages[0]';
}
