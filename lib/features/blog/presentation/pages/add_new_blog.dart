import 'dart:io';

import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  List<String> selectedTopics = [''];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void dipsose() {
    super.dispose();
    titleController.dispose();
    bodyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.done_rounded),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                image != null
                    ? GestureDetector(
                        onTap: selectImage,
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          selectImage();
                        },
                        child: DottedBorder(
                          color: AppPallete.borderColor,
                          dashPattern: const [10, 4],
                          radius: const Radius.circular(10),
                          borderType: BorderType.RRect,
                          strokeCap: StrokeCap.round,
                          child: const SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: 60,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Select your image",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      'Technology',
                      'Business',
                      'Programming',
                      'Entertainment'
                    ]
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
                                label: Text(e),
                                side: selectedTopics.contains(e)
                                    ? const BorderSide(
                                        color: AppPallete.borderColor,
                                      )
                                    : null,
                                color: selectedTopics.contains(e)
                                    ? const MaterialStatePropertyAll(
                                        AppPallete.gradient1)
                                    : null,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 10),
                BlogEditor(
                  controller: titleController,
                  hintText: 'Blog Title',
                ),
                const SizedBox(
                  height: 10,
                ),
                BlogEditor(
                  controller: bodyController,
                  hintText: 'Blog Content',
                ),
              ],
            ),
          ),
        ));
  }
}
