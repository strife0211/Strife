import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:strife/Screens/Post/controllers/post_controller.dart';
import 'package:strife/Screens/Profile/controllers/profile_controller.dart';
// import 'package:strife/Screens/Profile/controllers/update_profile_controller.dart';
import 'package:strife/constants.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postController = Get.put(PostController());
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: appBarPrimaryColor,
        // automaticallyImplyLeading: false,
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left)),
        centerTitle: true,
        title: Text("Create Post"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              // -- Form Fields
              Form(
                key: _formKey,
                child: GetBuilder<PostController>(
                  builder: (_) {
                    return Column(
                      children: [
                        TextFormField(
                          controller: postController.content,
                          validator: (content) => 
                            content == null || content.isEmpty
                            ? 'Enter something. Don\'t be shy'
                            : null,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            label: Text("content"), prefixIcon: Icon(Icons.textsms)
                          ),
                        ),
                        const SizedBox(height: tFormHeight),

                        // -- Form Submit Button
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                postController.createPost(postController.content.text.trim());
                                _formKey.currentState!.reset();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[200],
                                side: BorderSide.none,
                                shape: const StadiumBorder()),
                            child: const Text("Create Post", style: TextStyle(color: tDarkColor)),
                          ),
                        ),
                        const SizedBox(height: tFormHeight),
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