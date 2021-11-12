import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
//import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as path;


class FileDownload extends StatefulWidget{
  final TargetPlatform platform;
  final random;
FileDownload({required this.platform,this.random});
  @override
  _FileDownloadState createState() => _FileDownloadState();
}

class _FileDownloadState extends State<FileDownload> {
  late bool isLoading;
  bool _allowWriteFile=false;
  late TargetPlatform platform;


  List<Course>courseContent= [];


  String progress="";
  late Dio dio;

  @override
  void initState() {

    super.initState();
    print(widget.random);
    dio=Dio();
    //final result =bwsService.printInvoicePDF('700');
    courseContent.add(Course(title:"Chapter 2",path:"http://10.0.2.2:3000/PrintInvoice/"+widget.random+".pdf"));
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
      // print(DownloadsPathProvider.downloadsDirectory);
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

  Future downloadFile(String url,path) async {
    if(!_allowWriteFile)
    {
      //requestWritePermission();
      _checkPermission();
    }
    try{
      ProgressDialog progressDialog=ProgressDialog(context,dialogTransitionType: DialogTransitionType.Bubble,title: Text("Downloading File"));

      progressDialog.show();



      await dio.download(url, path,onReceiveProgress: (rec,total){
        setState(() {
          isLoading=true;
          progress=((rec/total)*100).toStringAsFixed(0)+"%";
          progressDialog.setMessage(Text( "Dowloading $progress"));
        });

      });
      progressDialog.dismiss();

    }catch( e)
    {

      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String url =courseContent[0].path;
    String extension=url.substring(url.lastIndexOf("/"));
    return Scaffold(
      body:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Your reservation is added succesfully,download your voucher',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xFFAF8F61).withOpacity(0.8),
                  child: TextButton(

                    onPressed: ()async{
                      _getDownloadDirectory().then((value) {
                        final savePath = path.join(value.path,);

                        File f=File(savePath+"$extension");
                        if(f.existsSync())
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return PDFScreen(f.path);
                          }));
                          return;
                        }
                        print(url);
                        downloadFile(url,"$savePath/$extension");
                      });

                    }, child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.download_outlined,color: Colors.white,),
                        Text("Download",style: TextStyle(fontSize: 18,color: Colors.white),),
                      ],
                    ),),
                ),
              ],
            ),
          ),
        ),

    );
  }
}
class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return  SfPdfViewer.file(
      File(pathPDF),
      key: _pdfViewerKey,
    );
  }
}

class Course{
  String title;
  String path;
  Course({required this.title,required this.path});
}