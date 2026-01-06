// ignore_for_file: file_names

import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:maintain_chat_app/models/message_models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintain_chat_app/services/storageService.dart';

class FileService {
  static Future<String> processFilePicked(
    XFile? file,
    MessageType messType,
    String folderPath,
    String fileName,
    String bucketName,
  ) async {
    // check image or video on storage and return url
    String fileUrl = "";
    final String fullPath = '$folderPath/$fileName';
    final bool isExist = await StorageService.fileExists(
      bucketName,
      '$folderPath/',
      fileName,
    );

    if (isExist) {
      fileUrl = await StorageService.getFileUrl(bucketName, fullPath);
      return fileUrl;
    } else {
      if (file != null) {
        await StorageService.uploadFile(bucketName, fullPath, File(file.path));
        // get file url
        fileUrl = await StorageService.getFileUrl(bucketName, fullPath);
        return fileUrl;
      } else {
        throw Exception('No file selected');
      }
    }
  }

  Future<String?> pickImage(String folderPath,String bucketName) async {
    try {
      //selected image from gallery
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      return await processFilePicked(
        image,
        MessageType.Image,
        folderPath,
        image.name,
        bucketName,
      );
    } on PlatformException catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String?> pickImageByCamera(String folderPath, String bucketName) async {
    try {
      //selected image from camera
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return null;
      return await processFilePicked(
        image,
        MessageType.Image,
        folderPath,
        image.name,
        bucketName,
      );
    } on PlatformException catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String?> pickVideo(String folderPath, String bucketName) async {
    try {
      final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (video == null) return null;
      return await processFilePicked(
        video,
        MessageType.Video,
        folderPath,
        video.name,
        bucketName,
      );
    } on PlatformException catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String?> uploadAudioFile(
    File audioFile,
    String folderPath,
    String fileName,
    String bucketName,
  ) async {
    try {
      return await processFilePicked(
        XFile(audioFile.path),
        MessageType.Audio,
        folderPath,
        fileName,
        bucketName,
      );
    } on PlatformException catch (e) {
      log(e.toString());
      return null;
    }
  }
}
