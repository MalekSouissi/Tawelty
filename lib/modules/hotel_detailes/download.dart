import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
//import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as path;

class FileDownload extends StatefulWidget {
  final TargetPlatform platform;
  final random;
  FileDownload({required this.platform, this.random});
  @override
  _FileDownloadState createState() => _FileDownloadState();
}

class _FileDownloadState extends State<FileDownload> {
  late bool isLoading;
  bool _allowWriteFile = false;
  late TargetPlatform platform;

  List<Course> courseContent = [];

  String progress = "";
  late Dio dio;

  @override
  void initState() {
    super.initState();
    print(widget.random);
    dio = Dio();
    //final result =bwsService.printInvoicePDF('700');
    courseContent.add(Course(
        title: "Chapter 2",
        path: "http://37.187.198.241:3000/PrintInvoice/" +
            widget.random +
            ".pdf"));
    // String url =courseContent[0].path;
    // String extension=url.substring(url.lastIndexOf("/"));
  }

  // requestWritePermission() async {
  //   if (await Permission.storage.request().isGranted) {
  //     setState(() {
  //
  //       _allowWriteFile = true;
  //
  //     });
  //   }else
  //   {
  //     Map<Permission, PermissionStatus> statuses = await [
  //       Permission.storage,
  //     ].request();
  //   }
  //
  //
  // }

  Future<bool> _checkPermission() async {
    if (widget.platform == TargetPlatform.android) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      if (statuses[Permission.storage] == PermissionStatus.denied) {
        if (await Permission.contacts.request().isGranted) {
          // Either the permission was already granted before or the user just granted it.
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  // Future<String>getDirectoryPath() async
  // {
  //   Directory appDocDirectory = await getApplicationDocumentsDirectory();
  //   Directory directory= await new Directory(appDocDirectory.path+'/'+'dir');
  //   print(directory.path);
  //   return directory.path;
  // }

  _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      //print(DownloadsPathProvider.downloadsDirectory);
      // return await DownloadsPathProvider.downloadsDirectory;
      // return ExtStorage.getExternalStoragePublicDirectory(
      //     ExtStorage.DIRECTORY_DOWNLOADS);
    }

    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary

    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }

  Future downloadFile(String url, path) async {
    if (!_allowWriteFile) {
      //requestWritePermission();
      _checkPermission();
    }
    try {
      ProgressDialog progressDialog = ProgressDialog(context,
          dialogTransitionType: DialogTransitionType.Bubble,
          title: Text("Downloading File"));

      progressDialog.show();

      await dio.download(url, path, onReceiveProgress: (rec, total) {
        setState(() {
          isLoading = true;
          progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
          progressDialog.setMessage(Text("Dowloading $progress"));
        });
      });
      progressDialog.dismiss();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String url = courseContent[0].path;
    String extension = url.substring(url.lastIndexOf("/"));
    return Scaffold(
      body: Column(
        children: [
          getAppBarUI(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
                AppLocalizations(context).of("reservation_txt"),
              style: TextStyles(context).getBoldStyle(),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          CommonButton(
            padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
            buttonText: AppLocalizations(context).of("download"),
            onTap: () async {
              _getDownloadDirectory().then((value) {
                final savePath = path.join(
                  value.path,
                );

                File f = File(savePath + "$extension");
                if (f.existsSync()) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PDFScreen(f.path);
                  }));
                  return;
                }
                print(url);
                downloadFile(url, "$savePath/$extension");
              });
            },
          ),
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    // return Container(
    //   decoration: BoxDecoration(
    //     color: AppTheme.scaffoldBackgroundColor,
    //     boxShadow: <BoxShadow>[
    //       BoxShadow(
    //           color: Theme.of(context).dividerColor,
    //           offset: Offset(0, 2),
    //           blurRadius: 8.0),
    //     ],
    //   ),
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 16,
          right: 16,
          bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          //   Container(
          // alignment: Alignment.centerLeft,
          // width: AppBar().preferredSize.height,
          // height: AppBar().preferredSize.height,
          // child:
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              ),
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          //   ),
          Expanded(
            child: Center(
              child: Text(
                'Download',
                style: TextStyles(context).getTitleStyle(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          //   Container(
          //     width: AppBar().preferredSize.height,
          //     height: AppBar().preferredSize.height
          //   )
        ],
      ),
    );
    // );
  }
}

class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.file(
      File(pathPDF),
      key: _pdfViewerKey,
    );
  }
}

class Course {
  String title;
  String path;
  Course({required this.title, required this.path});
}
