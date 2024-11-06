// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:mercado_youtube/screen/pago_screen.dart';

// class ItemScreen extends StatelessWidget {
//   static const String routename = 'ItemScreen';
//   final String? operationId;

//   const ItemScreen({super.key, this.operationId});

//   @override
//   Widget build(BuildContext context) {
//     // Verifica si se ha pasado el argumento `operationId` y consulta el estado de la operación.
//     if (operationId != null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         // Esperamos un tiempo razonable antes de verificar el estado
//         await Future.delayed(const Duration(seconds: 5)); // Espera 5 segundos antes de consultar
//         final response = await http.get(
//           Uri.parse('http://10.0.2.2:3000/verificar_estado_pago/$operationId'),
//         );

//         if (response.statusCode == 200) {
//           final result = json.decode(response.body);
//           final String status = result['status'];

//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               if (status == 'approved') {
//                 return AlertDialog(
//                   title: const Text('FELICITACIONES!'),
//                   content: const Text('Su pago se realizó con éxito'),
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: const Text('Aceptar'),
//                     ),
//                   ],
//                 );
//               } else {
//                 return AlertDialog(
//                   title: const Text('ERROR'),
//                   content: const Text('Su operación no pudo ser realizada'),
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: const Text('Aceptar'),
//                     ),
//                   ],
//                 );
//               }
//             },
//           );
//         } else {
//           debugPrint('Error al consultar el estado de la operación: ${response.statusCode}');
//         }
//       });
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xfffefdfd),
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               const Text(
//                 'Zapatillas',
//                 style: TextStyle(fontSize: 40),
//               ),
//               SizedBox(
//                 child: Image.asset('assets/zapatillas.jpg'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   try {
//                     final response = await http.post(
//                       Uri.parse('http://10.0.2.2:3000/create_preferences'),
//                     );

//                     if (response.statusCode == 201) {
//                       final res = json.decode(response.body);
//                       if (context.mounted) {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (BuildContext context) => PagoScreen(
//                               url: res["sandbox_init_point"],
//                               objeto: res,
//                             ),
//                           ),
//                         );
//                       }
//                     } else {
//                       print('Error en la solicitud: ${response.statusCode}');
//                     }
//                   } catch (e) {
//                     print('Error: $e');
//                   }
//                 },
//                 child: const Text('Pagar con MercadoPago'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


//----------------------------------------------

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mercado_youtube/screen/pago_screen.dart';

class ItemScreen extends StatelessWidget {
  static const String routename = 'ItemScreen';
  final bool? pagoExitoso;

  const ItemScreen({super.key, this.pagoExitoso});

  @override
  Widget build(BuildContext context) {
    // Verifica si se ha pasado el argumento `pagoExitoso` y si es `true`, muestra el popup.
    if (pagoExitoso == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('FELICITACIONES!'),
              content: const Text('Su pago se realizó con éxito'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xfffefdfd),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Zapatillas',
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(
                child: Image.asset('assets/zapatillas.jpg'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final response = await http.post(
                      Uri.parse('http://10.0.2.2:3000/create_preferences'),
                    );

                    if (response.statusCode == 200) {
                      final res = json.decode(response.body);
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => PagoScreen(
                              url: res["url"],
                            ),
                          ),
                        );
                      }
                    } else {
                      print('Error en la solicitud: ${response.statusCode}');
                    }
                  } catch (e) {
                    print('Error: $e');
                  }
                },
                child: const Text('Pagar con MercadoPago'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

