// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:mercado_youtube/screen/pago_screen.dart';

// class ItemScreen extends StatefulWidget {
//   static const String routename = 'ItemScreen';
//   final bool? pagoExitoso;

//   const ItemScreen({super.key, this.pagoExitoso});

//   @override
//   _ItemScreenState createState() => _ItemScreenState();
// }

// class _ItemScreenState extends State<ItemScreen> {
//   String operationStatusMessage = "";
//   String? opID;

//   // Método para verificar el estado de la operación en MercadoPago
//   Future<bool> verificarEstadoOperacion(String operationId) async {
//     try {
//       final response = await http.get(
//         Uri.parse('https://api.mercadopago.com/v1/payments/$operationId'),
//         headers: {
//           'Authorization': 'APP_USR-2895292226517850-110717-f814a027703fac30e6e1888c13963103-256622141', // Reemplaza con tu token de acceso de Mercado Pago
//         },
//       );

//       if (response.statusCode == 200) {
//         final result = json.decode(response.body);
//         return result['status'] == 'approved';
//       } else {
//         print('Error al consultar el estado de la operación: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       print('Error: $e');
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Verifica si se ha pasado el argumento `pagoExitoso` y si es `true`, muestra el popup.
//     if (widget.pagoExitoso == true) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('FELICITACIONES!'),
//               content: const Text('Su pago se realizó con éxito'),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Aceptar'),
//                 ),
//               ],
//             );
//           },
//         );
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
//               if (operationStatusMessage.isNotEmpty)
//                 Text(
//                   operationStatusMessage,
//                   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//               ElevatedButton(
//                 onPressed: () async {
//                   final parentContext = context; // Guarda el context antes de las llamadas asíncronas
//                   try {
//                     final response = await http.post(
//                       Uri.parse('http://10.0.2.2:3000/create_preferences'),
//                     );
//                     if (response.statusCode == 200) {
//                       final res = json.decode(response.body);
//                       opID = res['id'];
//                       print(opID);

//                       if (parentContext.mounted && opID != null) {
//                         Navigator.pushReplacement(
//                           parentContext,
//                           MaterialPageRoute(
//                             builder: (BuildContext context) => PagoScreen(
//                               url: res["url"],
//                             ),
//                           ),
//                         );

//                         // Abre el diálogo inmediatamente después de la navegación
//                         Future.microtask(() {
//                           showDialog(
//                             context: parentContext,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: const Text('Usted compró las zapatillas?'),
//                                 content: const Text('Presione chequear para verificar.'),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () async {
//                                       Navigator.of(parentContext).pop();
//                                       if (opID != null) {
//                                         bool isApproved = await verificarEstadoOperacion(opID!);
//                                         setState(() {
//                                           operationStatusMessage =
//                                               isApproved ? "COMPRADAS!!!" : "OPERACIÓN FALLIDA";
//                                         });
//                                       }
//                                     },
//                                     child: const Text('Chequear'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         });
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
                      final opID = res['id'];
                      print(opID);
                      
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => PagoScreen(
                              url: res["url"]
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

