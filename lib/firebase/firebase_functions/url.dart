import 'package:url_launcher/url_launcher.dart';

Future<void> createdlaunchUrl(location) async {
  final Uri url = Uri.parse(location);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
  // if (await canLaunch(location)) {
  //   await launch(location);
  // } else {
  //   throw 'Could not launch $location';
  // }
