import 'dart:developer';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  static final SupabaseClient _supabaseClient = Supabase.instance.client;

  static Future<void> uploadFile(
    String bucketName,
    String filePath,
    File file,
  ) async {
    try {
      await _supabaseClient.storage.from(bucketName).upload(filePath, file);
    } catch (e) {
      log('Exception during file upload: $e');
      throw Exception('File upload failed: $e');
    }
  }

  static Future<String> getFileUrl(String bucketName, String filePath) async {
    try {
      final String publicUrl = _supabaseClient.storage
          .from(bucketName)
          .getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      log('Exception during getting file URL: $e');
      throw Exception('Getting file URL failed: $e');
    }
  }

  static Future<void> deleteFile(String bucketName, String filePath) async {
    try {
      await _supabaseClient.storage.from(bucketName).remove([filePath]);
    } catch (e) {
      log('Exception during file deletion: $e');
      throw Exception('File deletion failed: $e');
    }
  }

  static Future<bool> fileExists(
    String bucketName,
    String filePath,
    String fileName,
  ) async {
    try {
      final response = await _supabaseClient.storage
          .from(bucketName)
          .list(path: filePath);
      return response.any((file) => file.name == fileName);
    } catch (e) {
      log('Exception during checking file existence: $e');
      throw Exception('Checking file existence failed: $e');
    }
  }
}
