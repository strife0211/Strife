import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:strife/Screens/Post/controllers/post_controller.dart';
import 'package:strife/Screens/Profile/components/profile_menu.dart';
import 'package:strife/Screens/Profile/controllers/profile_controller.dart';
import 'package:strife/Screens/Profile/update_profile_screen.dart';
import 'package:strife/Screens/Profile/view_game_screen.dart';
import 'package:strife/constants.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ProfileController());

//     return Scaffold(
//       appBar: AppBar(),
//       body: Container(
//         child: ElevatedButton(
//           child: Text("Log out"),
//           onPressed : () {
//             ProfileController.instance.signOut();
//           },
//         ),
//       ),
//     );
//   }
// }

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());
    // final postController = Get.put(PostController());
    // var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: appBarPrimaryColor,
        automaticallyImplyLeading: false,
        // leading: IconButton(onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text("Profile"),
        centerTitle: true,
        // actions: [IconButton(onPressed: () {}, icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [

              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100), 
                      child: GetBuilder<ProfileController>(builder: (_){
                        return Image.network(profileController.userData.url);
                      })
                      // Obx(() => Image.network(profileController.userData.value.url))
                    ),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: Container(
                  //     width: 35,
                  //     height: 35,
                  //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: tPrimaryColor),
                  //     child: const Icon(
                  //       LineAwesomeIcons.alternate_pencil,
                  //       color: Colors.black,
                  //       size: 20,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 10),
              // Obx(() => Text(profileController.userData.value.name, style: Theme.of(context).textTheme.headlineMedium)),
              GetBuilder<ProfileController>(builder: (_) { return Text(profileController.userData.name, style: Theme.of(context).textTheme.headlineMedium);}),
              // Obx(() => Text(profileController.userData.value.email, style: Theme.of(context).textTheme.bodyMedium)),
              GetBuilder<ProfileController>(builder: (_) { return Text(profileController.userData.email, style: Theme.of(context).textTheme.bodyMedium);}),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const UpdateProfileScreen()),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[200], side: BorderSide.none, shape: const StadiumBorder()),
                  child: const Text("Edit Profile", style: TextStyle(color: tDarkColor)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(thickness: 1),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(title: "Settings", icon: LineAwesomeIcons.cog, onPress: () {}),
              ProfileMenuWidget(title: "View Game", icon: Icons.games, onPress: () {
                // ProfileController.getGames();
                Get.to(() => const ViewGameScreen());
              }),
              ProfileMenuWidget(title: "View Post", icon: Icons.post_add, onPress: () {
                profileController.goToViewPostScreen();
              }),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              ProfileMenuWidget(title: "About Us", icon: LineAwesomeIcons.info, onPress: () {}),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    Get.defaultDialog(
                      title: "LOGOUT",
                      titleStyle: const TextStyle(fontSize: 20),
                      content: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text("Are you sure, you want to Logout?"),
                      ),
                      confirm: ElevatedButton(
                        onPressed: () {
                          ProfileController.instance.signOut();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          side: BorderSide.none
                        ),
                        child: const Text("Yes"),
                      ),
                      cancel: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        }, 
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            width: 0.1,
                            style: BorderStyle.solid
                          )
                        ),
                        child: const Text("No")
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}