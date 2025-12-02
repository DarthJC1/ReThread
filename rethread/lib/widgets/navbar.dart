// import 'package:flutter/material.dart';

// class RoleInfoWidget extends StatelessWidget {
//   final String role;
//   const RoleInfoWidget({super.key, required this.role});

//   @override
//   Widget build(BuildContext context) {
//     String description;
//     if (role == 'Business Owner') {
//       description = 'List your shop, upload products, and reach more customers.';
//     } else if (role == 'Shopper') {
//       description = 'Find nearby shops, order items, and get quick delivery.';
//     } else {
//       description = 'Deliver local orders and earn from short-distance trips.';
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 60),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(role, style: RoleTitle, textAlign: TextAlign.center),
//           Text(description, style: DefaultCaption, textAlign: TextAlign.center),

//           const SizedBox(height: 300),

//           SizedBox(
//             width: 220,
//             height: 50,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: BaseYellow,
//                 foregroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => Welcomepage()),
//                     );
//               },
              
//               child: Text('Start', style: DefaultCaption),
              
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
