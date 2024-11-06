// import 'package:flutter/material.dart';
// import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
// import 'package:mercado_youtube/screen/item_screen.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:uni_links/uni_links.dart';
// import 'dart:async';

// class PagoScreen extends StatefulWidget {
//   static const String routename = 'PagoScreen';
//   final objeto;
//   final String? url;

//   const PagoScreen({super.key, this.objeto, this.url});

//   @override
//   State<PagoScreen> createState() => _PagoScreenState();
// }

// class _PagoScreenState extends State<PagoScreen> {
//   late StreamSubscription _sub;
//   String? operationId; // Variable para almacenar el ID de la operación

//   @override
//   void initState() {
//     super.initState();
//     _initDeepLinkListener();
//   }

//   @override
//   void dispose() {
//     _sub.cancel();
//     super.dispose();
//   }

//   void _initDeepLinkListener() {
//     _sub = uriLinkStream.listen((Uri? uri) {
//       if (uri != null && context.mounted) {
//         String path = uri.host;
//         if (path == 'success') {
//           // Aquí se asume que el ID de la operación se pasa como parámetro en la URI
//           operationId = uri.queryParameters['id'];
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (BuildContext context) => ItemScreen(operationId: operationId),
//             ),
//           );
//         } else {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (BuildContext context) => const ItemScreen(),
//             ),
//           );
//         }
//       }
//     }, onError: (err) {
//       debugPrint('Error al manejar los deep links: $err');
//     });
//   }

//   void _launchURL(BuildContext context, String? url) async {
//     print("url: " + (url ?? 'es null') + "objeto: " + widget.objeto.toString());
//     if (url == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('La URL no es válida')),
//       );
//       return;
//     }

//     try {
//       final response = await http.post(
//         Uri.parse('http://10.0.2.2:3000/create_preferences'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'items': [
//             {'title': 'Zapatillas', 'quantity': 1, 'unit_price': 100.0}
//           ]
//         }),
//       );

//       if (response.statusCode == 201) {
//         final result = json.decode(response.body);
//         final String initPoint = result['init_point'];
//         final String operationId = result['id'].toString();

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (BuildContext context) => ItemScreen(operationId: operationId),
//           ),
//         );

//         await launch(
//           initPoint,
//           customTabsOption: CustomTabsOption(
//             toolbarColor: Theme.of(context).primaryColor,
//             enableDefaultShare: false,
//             enableUrlBarHiding: true,
//             showPageTitle: true,
//             animation: CustomTabsSystemAnimation.slideIn(),
//           ),
//           safariVCOption: SafariViewControllerOption(
//             preferredBarTintColor: Theme.of(context).primaryColor,
//             preferredControlTintColor: Colors.white,
//           ),
//         );
//       } else {
//         debugPrint('Error al crear la preferencia: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Error al abrir la URL o crear la preferencia: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No se pudo procesar el pago')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: ElevatedButton(
//             onPressed: () => _launchURL(context, widget.url),
//             child: const Text('Abrir Checkout'),
//           ),
//         ),
//       ),
//     );
//   }
// }





//---------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:mercado_youtube/screen/item_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

class PagoScreen extends StatefulWidget {
  static const String routename = 'PagoScreen';
  final String? url;

  const PagoScreen({super.key, this.url});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void _initDeepLinkListener() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null && context.mounted) {
        String path = uri.host;
        bool isSuccess = false;
        if (path == 'success') {
          _verificarEstadoPago(context);
        } else {
          Navigator.pushReplacementNamed(context, ItemScreen.routename, arguments: isSuccess);
        }
      }
    }, onError: (err) {
      debugPrint('Error al manejar los deep links: $err');
    });
  }

  Future<void> _verificarEstadoPago(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/verificar_estado_pago'));

      if (response.statusCode == 201) {
        bool isSuccess = true;
        Navigator.pushReplacementNamed(context, ItemScreen.routename, arguments: isSuccess);
      } else {
        bool isSuccess = false;
        Navigator.pushReplacementNamed(context, ItemScreen.routename, arguments: isSuccess);
      }
    } catch (e) {
      debugPrint('Error al verificar el estado del pago: $e');
      bool isSuccess = false;
      Navigator.pushReplacementNamed(context, ItemScreen.routename, arguments: isSuccess);
    }
  }

  void _launchURL(BuildContext context, String? url) async {
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La URL no es válida')),
      );
      return;
    }

    try {
      await launch(
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: false,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsSystemAnimation.slideIn(),
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
        ),
      );
    } catch (e) {
      debugPrint('Error al abrir la URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () => _launchURL(context, widget.url),
            child: const Text('Abrir Checkout'),
          ),
        ),
      ),
    );
  }
}