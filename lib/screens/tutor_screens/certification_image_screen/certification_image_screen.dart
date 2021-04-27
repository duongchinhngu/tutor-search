import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/notifications/notification_methods.dart';
import 'package:tutor_search_system/cubits/image_cubit.dart';
import 'package:tutor_search_system/repositories/image_repository.dart';
import 'package:tutor_search_system/screens/common_ui/full_screen_image.dart';
import 'package:tutor_search_system/screens/common_ui/no_data_screen.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/states/image_state.dart';

class CertificationImageScreen extends StatefulWidget {
  @override
  _CertificationImageScreenState createState() =>
      _CertificationImageScreenState();
}

class _CertificationImageScreenState extends State<CertificationImageScreen> {
  @override
  void initState() {
    registerOnFirebase();
    getMessage(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocProvider(
          create: (context) => ImageCubit(ImageRepository()),
          child: BlocBuilder<ImageCubit, ImageState>(builder: (context, state) {
            //
            final imageCubit = context.watch<ImageCubit>();
            imageCubit
                // .getTuteeTransactionByTuteeId(authorizedTutor.id);
                .getImageByEmail(authorizedTutor.email, 'certification');
            //
            if (state is ImageErrorState) {
              // return ErrorScreen();
              return Text(state.errorMessage);
            } else if (state is InitialImageState) {
              return buildLoadingIndicator();
            } else if (state is ImageNoDataState) {
              return NoDataScreen();
            } else if (state is ImageListLoadedState) {
              List<String> certificationImages = [
                'https://lakeridgeumcyoungadults.files.wordpress.com/2019/11/27706588173_e1c1327bb3_b.jpg'
              ];
              //
              certificationImages = state.images
                  .replaceFirst(']', '')
                  .replaceFirst('[', '')
                  .split(', ');
              //
              return Container(
                width: double.infinity,
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 5, left: 5),
                child: Wrap(
                  runAlignment: WrapAlignment.spaceBetween,
                  runSpacing: 5,
                  spacing: 5,
                  children: List.generate(certificationImages.length, (index) {
                    //view photo in fullscreen
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImage(
                              imageWidget: Image.network(
                                certificationImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 114,
                        width: 114,
                        child: Image.network(
                          certificationImages[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
                ),
              );
            }
          })),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: mainColor,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: backgroundColor,
          size: 15,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Text(
        'Certification',
      ),
      // actions: [Icon(Icons.sort)],
    );
  }
}
