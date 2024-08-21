
import 'dart:io';

import 'package:blog_app/core/common/cubits/cubit/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blog_page.dart';

class AddNewBlogPage extends StatefulWidget {
  static route()=> MaterialPageRoute(builder: (context)=> AddNewBlogPage(),);
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController=TextEditingController();
  final contentController=TextEditingController();
  final formKey=GlobalKey<FormState>();
  List<String> SelectedTopics=[];
  File ?image;
  void selectImage()async{
    final pickedImage= await pickImage();
if(pickedImage!=null) {
  setState(() {
    image = pickedImage;
  });
}
  }
  @override
  void dispose(){
    titleController.dispose();
    super.dispose();
    contentController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            if(formKey.currentState!.validate() && SelectedTopics.length>=1&&image!=null){
            final posterId=(context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
              context.read<BlogBloc>().add(BlogUpload(
                posterId: posterId,
                title: titleController.text.trim(),
                content: contentController.text.trim(),
                image: image!,
                topics: SelectedTopics,));
            }
          }, icon: Icon(Icons.done_rounded)),
        ],
      ),
      body:BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state){
            if(state is BlogFailure){
              showSnackBar(context, state.error);

            }
            else if(state is BlogSuccess){
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                    (route) => false,
              );
            }
          },
      builder: (context, state) {
        if (state is BlogLoading) {
      return const Loader();
    }
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                image!=null?

                GestureDetector(
                  onTap: selectImage,
                  child: SizedBox(
                        width: double.infinity,
                          height: 300,

                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(image!,fit:BoxFit.fill,)), ),
                )
                    :
               GestureDetector(
                 onTap: (){
                   selectImage();
                 },
                 child: DottedBorder(
                   color: AppPallete.borderColor,
                   dashPattern: [25,4],
                     radius:Radius.circular(10),
                   child: Container(
                    height: 300,
                     width: double.infinity,

                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.folder_open,size: 40,),
                         SizedBox(height: 15,),
                         Text('Select your image',style:TextStyle(
                           fontSize: 15,
                         ),),
                       ],
                     ),
                   )
                 ),
               ),
                SizedBox(height: 30,),
                SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child:Row(
                   children: [
                     'Technology',
                     'Business',
                     'Programming',
                     'Entertainment'
                     ].map((e)=>Padding(
                       padding: const EdgeInsets.all(5.0),
                       child: GestureDetector(
                         onTap: (){
                           if(SelectedTopics.contains(e)){
                             SelectedTopics.remove(e);
                           }
                           else{
                             SelectedTopics.add(e);
                           }

                           setState(() {

                           });
                         },
                         child: Chip(
                           color: SelectedTopics.contains(e)?MaterialStatePropertyAll(AppPallete.gradient1):null,
                         side: BorderSide(

                           color: AppPallete.borderColor,
                         ),
                         label:Text(e),
                                        ),
                       ),
                     ),).toList(),
                 ),
               ),
                SizedBox(height: 20,),
                BlogEditor(controller: titleController, hintText: 'Blog title',),
                SizedBox(height: 20,),
                BlogEditor(controller: contentController, hintText: 'Blog content',),


              ],
            ),
          ),
        ),
      );},),
    );
  }
}
