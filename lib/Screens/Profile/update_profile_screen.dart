import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:strife/Screens/Profile/controllers/profile_controller.dart';
// import 'package:strife/Screens/Profile/controllers/update_profile_controller.dart';
import 'package:strife/constants.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: appBarPrimaryColor,
        // automaticallyImplyLeading: false,
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left)),
        centerTitle: true,
        title: Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: GetBuilder<ProfileController>(builder: (_) {
                          return controller.childWidget;
                        },)
                        // Obx(() => controller.childWidget.value)
                        // ProfileController.profile.showImage()
                        // child: ProfileController.profile.showImage() ? Image.network(ProfileController.profile.userData.url) : Image.file(ProfileController.profile.selectedFile!)
                      ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 80,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.camera_alt),
                                        onPressed: () async {
                                          await ProfileController.profile.getImage(ImageSource.camera);
                                          // getImage(ImageSource.camera);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      const Text('Choose From Camera')
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.file_copy),
                                        onPressed: () async {
                                          await ProfileController.profile.getImage(ImageSource.gallery);
                                          // getImage(ImageSource.gallery);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      const Text('Choose From Gallery')
                                    ],
                                  ),
                                ],
                              )
                            );
                          }
                        );
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.blue[200]),
                        child: const Icon(LineAwesomeIcons.camera, color: Colors.black, size: 20),
                      ),
                    )
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                child: GetBuilder<ProfileController>(
                  builder: (_) {
                    return Column(
                      children: [
                        TextFormField(
                          controller: controller.name,
                          decoration: const InputDecoration(
                              label: Text("Full Name"), prefixIcon: Icon(LineAwesomeIcons.user)),
                        ),
                        const SizedBox(height: tFormHeight - 20),
                        // TextFormField(
                        //   decoration: const InputDecoration(
                        //       label: Text("Gender"), prefixIcon: FaIcon(FontAwesomeIcons.personHalfDress)),
                        // ),

                        // GetBuilder<ProfileController>(builder: (_){
                          // return 
                          DropdownButtonFormField(
                            icon: const Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.purple,
                            ),
                            dropdownColor: Colors.deepPurple.shade50,
                            decoration: const InputDecoration(
                              labelText: "Gender",
                              prefixIcon: Icon(
                                Icons.accessibility_new,
                                color: Colors.purple,
                              )
                            ),
                            value: controller.selectedGender,
                            items: controller.gender.map((e) {
                              return DropdownMenuItem(
                                child: new Text(e),
                                value: e,
                              );
                            }).toList(),
                            onChanged: (val) {
                              controller.setSelected(val as String);
                            },
                          ),
                        // }),
                        const SizedBox(height: tFormHeight - 20),
                        TextFormField(
                          controller: controller.age,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              label: Text("Age"), prefixIcon: Icon(Icons.calendar_month)),
                        ),
                        const SizedBox(height: tFormHeight - 20),
                        TextFormField(
                          controller: controller.address,
                          decoration: const InputDecoration(
                              label: Text("Address"), prefixIcon: Icon(LineAwesomeIcons.address_book)),
                        ),
                        const SizedBox(height: tFormHeight - 20),
                        TextFormField(
                          controller: controller.phone,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              label: Text("Phone Number"), prefixIcon: Icon(LineAwesomeIcons.phone)),
                        ),
                        const SizedBox(height: tFormHeight),
                        TextFormField(
                          controller: controller.about,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            label: Text("About"), prefixIcon: Icon(Icons.help)
                          ),
                        ),
                        const SizedBox(height: tFormHeight),

                        // -- Form Submit Button
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              ProfileController.profile.updateUser(controller.name.text.trim(), controller.selectedGender, int.parse(controller.age.text), controller.address.text.trim(), controller.phone.text.trim(), controller.about.text.trim());
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[200],
                                side: BorderSide.none,
                                shape: const StadiumBorder()),
                            child: const Text("Edit Profile", style: TextStyle(color: tDarkColor)),
                          ),
                        ),
                        const SizedBox(height: tFormHeight),

                        // // -- Created Date and Delete Button
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     const Text.rich(
                        //       TextSpan(
                        //         text: tJoined,
                        //         style: TextStyle(fontSize: 12),
                        //         children: [
                        //           TextSpan(
                        //               text: tJoinedAt,
                        //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                        //         ],
                        //       ),
                        //     ),
                        //     ElevatedButton(
                        //       onPressed: () {},
                        //       style: ElevatedButton.styleFrom(
                        //           backgroundColor: Colors.redAccent.withOpacity(0.1),
                        //           elevation: 0,
                        //           foregroundColor: Colors.red,
                        //           shape: const StadiumBorder(),
                        //           side: BorderSide.none),
                        //       child: const Text(tDelete),
                        //     ),
                        //   ],
                        // )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}