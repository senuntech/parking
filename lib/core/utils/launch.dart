import 'package:url_launcher/url_launcher.dart';

class LaunchApp {
  static void email() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'senuntec@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Recibo e Gestão para Motorista - Dúvidas ou Sugestões',
      }),
    );

    launchUrl(emailLaunchUri);
  }

  static Future<void> site(String urlSite) async {
    final Uri url = Uri.parse(urlSite);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map(
        (MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
      )
      .join('&');
}
