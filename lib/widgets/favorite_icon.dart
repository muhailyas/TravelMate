// import 'package:flutter/material.dart';
// import 'package:travelmate/Db/model/functions/db_functions.dart';
// import '../Db/model/destinaion_model/destination_model.dart';

// class FavoriteIcon extends StatelessWidget {
//   const FavoriteIcon(
//       {super.key,
//       this.color = Colors.black,
//       required this.isFavorite,
//       this.size = 25,
//       required this.destinationModel});
//   final Color color;  
//   final bool isFavorite;
//   final double size;
//   final DestinationModel destinationModel;
//   favoriteChanger() {
//     HiveDB().favoriteDestinationListNotifier.value.contains(destinationModel)
//         ? HiveDB().removeFavorite(destinationModel)
//         : HiveDB().addFavorite(destinationModel);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//       valueListenable: HiveDB().favoriteDestinationListNotifier,
//       builder: (context, list, _) =>
//           HiveDB().favoriteDestinationListNotifier.value.contains(destinationModel)
//               ? InkWell(
//                   onTap: favoriteChanger,
//                   child: Icon(
//                     Icons.bookmark,
//                     size: size,
//                     color: color,
//                   ),
//                 )
//               : InkWell(
//                   onTap: favoriteChanger,
//                   child: Icon(
//                     Icons.bookmark_border,
//                     size: size,
//                     color: color,
//                   ),
//                 ),
//     );
//   }
// }
