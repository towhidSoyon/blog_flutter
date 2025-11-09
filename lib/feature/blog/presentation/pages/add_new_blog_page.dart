import 'dart:io';
import 'dart:math';

import 'package:blog_app/core/common/cubits/app_user_cubit.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/feature/blog/presentation/blog_bloc.dart';
import 'package:blog_app/feature/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => AddNewBlogPage());

  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {
          if(formKey.currentState!.validate() && selectedTopics.isNotEmpty && image != null){
            final posterId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
            context.read<BlogBloc>().add(BlogUpload(posterId: posterId, title: titleController.text.trim(), content: contentController.text.trim(), image: image!, topics: selectedTopics));
          }
        }, icon: Icon(Icons.done_rounded))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                image != null
                    ? GestureDetector(
                      onTap: (){
                        selectImage();
                      },
                      child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(image!, fit: BoxFit.cover),
                          ),
                        ),
                    )
                    : GestureDetector(
                        onTap: () {
                          selectImage();
                        },
                        child: DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            color: AppPallete.borderColor,
                            dashPattern: const [10, 4],
                            radius: Radius.circular(10),
                            strokeCap: StrokeCap.round,
                          ),
                          child: Container(
                            color: AppPallete.borderColor,
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_open, size: 40),
                                SizedBox(height: 15),
                                Text(
                                  'Select your image',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        ['Technology', 'Business', 'Programming', 'Entertainment']
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectedTopics.contains(e)) {
                                      selectedTopics.remove(e);
                                    } else {
                                      selectedTopics.add(e);
                                    }
                                    setState(() {});
                                  },
                                  child: Chip(
                                    color: selectedTopics.contains(e)
                                        ? const MaterialStatePropertyAll(
                                            AppPallete.gradient1,
                                          )
                                        : null,
                                    label: Text(e),
                                    side: selectedTopics.contains(e)
                                        ? null
                                        : BorderSide(
                                            color: AppPallete.borderColor,
                                          ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
                SizedBox(height: 10),
                BlogEditor(controller: titleController, hintText: 'Blog Title'),
            
                SizedBox(height: 10),
                BlogEditor(controller: titleController, hintText: 'Blog Content'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
