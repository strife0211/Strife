import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Matching/components/game_icon.dart';
import 'package:strife/Screens/Matching/controllers/matching_controller.dart';
import 'package:strife/models/user.dart';

class UserCard extends StatelessWidget {
  final MyUser user;
  
  const UserCard({
    Key? key,
    required this.user
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10, 
        left: 20,
        right: 20,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(user.url),
                ),
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 4,
                    offset: const Offset(3, 3),
                  )
                ]
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5.0),
            //     gradient: const LinearGradient(
            //       colors: [
            //         Color.fromARGB(200, 0, 0, 0),
            //         Color.fromARGB(0, 0, 0, 0),
            //       ],
            //       begin: Alignment.bottomCenter,
            //       end: Alignment.topCenter,
            //     ),
            //   ),
            // ),
            Positioned(
              bottom: 30,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 325,
                    child:
                    user.age == 0 
                    ? user.gender == 'Hidden'
                      ? Text(user.name, style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white))
                      : Text("${user.name}, ${user.gender}", style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white))
                    : user.gender == 'Hidden'
                      ? Text("${user.name}, ${user.age}", style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white))
                      : Text("${user.name}, ${user.age}, ${user.gender}", style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white)),
                  ),
                  Row(
                    children: [
                      user.sameGames == null
                      ? SizedBox(
                          height: 50,
                          width: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: user.games!.length > 4 ? 4 : user.games!.length,
                            itemBuilder: (context, index) {
                              // print("sameGames Null");
                              // print("user.games!.length");
                              // print(user.games!.length);
                              return GameIcon(game: user.games![index]);
                            }
                          ),
                        )
                      : SizedBox(
                          height: 50,
                          width: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: user.sameGames!.length > 4 ? 4 : user.sameGames!.length,
                            itemBuilder: (context, index) {
                              // print("sameGames is not Null");
                              // print("user.sameGames!.length");
                              // print(user.sameGames!.length);
                              return GameIcon(game: user.sameGames![index]);
                            }
                          ),
                        ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     GameIcon(game: user.games![0]),
                  //     GameIcon(game: user.games![1]),
                  //     GameIcon(game: user.games![2]),
                  //     GameIcon(game: user.games![3]),
                  //     // const SizedBox(width: 10),
                  //     // Container(
                  //     //   width: 35,
                  //     //   height: 35,
                  //     //   decoration: const BoxDecoration(
                  //     //     shape: BoxShape.circle,
                  //     //     color: Colors.white,
                  //     //   ),
                  //     //   child: Icon(
                  //     //     Icons.info_outline,
                  //     //     size: 25,
                  //     //     color: Theme.of(context).primaryColor,
                  //     //   ),
                  //     // )
                  //   ],
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}