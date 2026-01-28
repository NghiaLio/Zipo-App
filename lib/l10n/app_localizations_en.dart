// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get monday => 'Monday';

  @override
  String get fill_info => 'Please fill in all information';

  @override
  String get hello_signin => 'HELLO, SIGN IN';

  @override
  String get email_hint => 'Email address (e.g. joydeo@gmail.com)';

  @override
  String get password => 'Password';

  @override
  String get forgot_password => 'Forgot password?';

  @override
  String get signin_button => 'SIGN IN';

  @override
  String get dont_have_account => 'Don\'t have an account? ';

  @override
  String get signup_link => 'Sign up';

  @override
  String get enter_email => 'Please enter your email';

  @override
  String get email_not_correct => 'Invalid email format';

  @override
  String get enter_name => 'Please enter your name';

  @override
  String get name_too_short => 'Name must be at least 4 characters';

  @override
  String get enter_password => 'Please enter your password';

  @override
  String get password_too_short => 'Password must be at least 6 characters';

  @override
  String get enter_confirm_password => 'Please enter confirm password';

  @override
  String get confirm_password_not_match => 'Passwords do not match';

  @override
  String get create_account_title => 'CREATE ACCOUNT';

  @override
  String get full_name => 'Full Name';

  @override
  String get phone_or_email => 'Phone or Email';

  @override
  String get confirm_password => 'Confirm Password';

  @override
  String get signup_button => 'SIGN UP';

  @override
  String get already_have_account => 'Already have an account? ';

  @override
  String get signin_link => 'Sign in';

  @override
  String get enter_your_email => 'Please enter your email';

  @override
  String get incorrect_email => 'Incorrect email';

  @override
  String get reset_password_title => 'Reset Password';

  @override
  String get enter_email_to_reset => 'Enter your email to reset';

  @override
  String get email_address => 'Email Address';

  @override
  String get reset_instructions =>
      'We will send a password reset link to your email address.';

  @override
  String get send_reset_link => 'Send Reset Link';

  @override
  String get back_to_login => 'Back to Login';

  @override
  String get email_sent => 'Email Sent!';

  @override
  String get email_sent_details =>
      'A password reset link has been sent to your email address. Please check your inbox.';

  @override
  String get got_it => 'Got it';

  @override
  String get home_screen_title => 'Home Screen';

  @override
  String get logout_button => 'Logout';

  @override
  String get messages_tab => 'Messages';

  @override
  String get posts_tab => 'Posts';

  @override
  String get profile_tab => 'Profile';

  @override
  String get messages_title => 'Messages';

  @override
  String get user_not_found => 'User info not found';

  @override
  String get friend_list_load_error => 'Could not load friend list';

  @override
  String get no_friends => 'No friends yet';

  @override
  String get delete_message_success => 'Message deleted successfully';

  @override
  String get messages_load_error => 'Could not load messages';

  @override
  String get no_messages => 'No messages yet';

  @override
  String get loading_error => 'Error loading data';

  @override
  String get search_hint => 'Search...';

  @override
  String get notifications_action => 'Notifications';

  @override
  String get delete_action => 'Delete';

  @override
  String get unknown_user => 'Unknown User';

  @override
  String get start_conversation_hint => 'Start a conversation!';

  @override
  String get post_created_success => 'Post created successfully!';

  @override
  String get post_created_failed => 'Post creation failed!';

  @override
  String get posting_in_progress => 'Posting in progress...';

  @override
  String get posts_title => 'Posts';

  @override
  String post_load_error(Object error) {
    return 'Error loading posts: $error';
  }

  @override
  String get no_posts_message => 'No posts yet. Let\'s create a new post!';

  @override
  String get post_deleted_success => 'Post deleted';

  @override
  String get image_pick_error => 'Error picking image';

  @override
  String get video_pick_error => 'Error picking video';

  @override
  String get content_empty_error => 'Please enter post content';

  @override
  String get post_updated_success => 'Post updated successfully!';

  @override
  String get post_update_error => 'Error updating post';

  @override
  String get post_create_error => 'Error creating post';

  @override
  String get edit_post_title => 'Edit post';

  @override
  String get create_post_title => 'Create post';

  @override
  String get save_button => 'Save';

  @override
  String get post_button => 'Post';

  @override
  String get public_visibility => 'Public';

  @override
  String get what_on_your_mind => 'What\'s on your mind?';

  @override
  String get add_to_post => 'Add to post';

  @override
  String get edit_post_action => 'Edit Post';

  @override
  String get delete_post_action => 'Delete Post';

  @override
  String get cancel_action => 'Cancel';

  @override
  String get delete_confirm_title => 'Confirm Delete';

  @override
  String get delete_confirm_message =>
      'Are you sure you want to delete this post?';

  @override
  String get delete_button => 'Delete';

  @override
  String get empty_comment_error => 'You cannot post an empty comment';

  @override
  String get media_upload_failed => 'Media upload failed. Please try again.';

  @override
  String get pick_image_action => 'Pick image';

  @override
  String get pick_video_action => 'Pick video';

  @override
  String get image_pick_failed => 'Cannot pick image. Please try again.';

  @override
  String get video_pick_failed => 'Cannot pick video. Please try again.';

  @override
  String get comment_empty_save_error => 'Comment cannot be empty';

  @override
  String get delete_comment_title => 'Delete Comment';

  @override
  String get delete_comment_confirm =>
      'Are you sure you want to delete this comment?';

  @override
  String get edit_comment_action => 'Edit comment';

  @override
  String comments_header(Object count) {
    return 'Comments ($count)';
  }

  @override
  String get no_comments_message => 'No comments yet. Be the first to comment!';

  @override
  String replying_to(Object name) {
    return 'Replying to $name';
  }

  @override
  String get write_comment_hint => 'Write a comment...';

  @override
  String get post_author_label => 'Author';

  @override
  String get add_media_placeholder => 'Add photo/video';

  @override
  String get reply_action => 'Reply';

  @override
  String get comment_hint_edit => 'Comment content ...';

  @override
  String get comment_load_error => 'Could not load comments.';

  @override
  String get retry_button => 'Retry';

  @override
  String get user_info_not_found => 'User info not found';

  @override
  String get reload_button => 'Reload';

  @override
  String get posts_stat => 'Posts';

  @override
  String get friends_stat => 'Friends';

  @override
  String get personal_info_menu => 'Personal Info';

  @override
  String get friends_menu => 'Friends';

  @override
  String get notifications_menu => 'Notifications';

  @override
  String get about_menu => 'About';

  @override
  String get logout_menu => 'Logout';

  @override
  String get image_selected_success => 'Image selected';

  @override
  String image_pick_error_detail(Object error) {
    return 'Error picking image: $error';
  }

  @override
  String get name_empty_error => 'Name cannot be empty';

  @override
  String profile_update_error_detail(Object error) {
    return 'Error uploading image: $error';
  }

  @override
  String get info_saved_success => 'Info saved';

  @override
  String get cancel_edit_title => 'Discard changes?';

  @override
  String get cancel_edit_message => 'Changes will not be saved';

  @override
  String get stay_button => 'Stay';

  @override
  String get confirm_cancel_button => 'Discard';

  @override
  String get personal_info_title => 'Personal Info';

  @override
  String get display_name_label => 'Display Name';

  @override
  String get other_name_label => 'Other Name';

  @override
  String get phone_number_label => 'Phone Number';

  @override
  String get address_label => 'Address';

  @override
  String get other_info_section => 'Other Info';

  @override
  String get save_changes_button => 'Save Changes';

  @override
  String enter_field_hint(Object field) {
    return 'Enter $field';
  }

  @override
  String get friend_requests_tab_title => 'Friend Requests';

  @override
  String get friends_tab_title => 'Friends';

  @override
  String get search_hint_dots => 'Search...';

  @override
  String get no_results => 'No results found';

  @override
  String get remove_friend_title => 'Remove friend';

  @override
  String remove_friend_confirm(Object name) {
    return 'Are you sure you want to remove $name from your friend list?';
  }

  @override
  String remove_friend_success(Object name) {
    return 'Removed $name from friend list';
  }

  @override
  String get unfriend_action => 'Unfriend';

  @override
  String get no_friend_requests => 'No friend requests yet';

  @override
  String get accept_button => 'Confirm';

  @override
  String get reject_button => 'Delete';

  @override
  String get app_version => 'Version 1.0.0';

  @override
  String get about_app_section => 'About App';

  @override
  String get about_app_description =>
      'Zipo Social is a modern messaging app designed to connect people easily and securely. With a friendly interface and rich features, the app provides a great chat experience for users.';

  @override
  String get key_features_section => 'Key Features';

  @override
  String get messaging_feature_title => 'Real-time Messaging';

  @override
  String get messaging_feature_desc =>
      'Send and receive instant messages with friends';

  @override
  String get media_sharing_title => 'Media Sharing';

  @override
  String get media_sharing_desc => 'Share moments in high quality';

  @override
  String get friend_management_title => 'Friend Management';

  @override
  String get friend_management_desc => 'Connect and manage friend lists easily';

  @override
  String get smart_notifications_title => 'Smart Notifications';

  @override
  String get smart_notifications_desc => 'Get important notifications on time';

  @override
  String get high_security_title => 'High Security';

  @override
  String get high_security_desc => 'Data is encrypted and safely protected';

  @override
  String get about_us_section => 'About Us';

  @override
  String get about_us_description =>
      'Zipo Social is developed by a one-member team for the purpose of practicing, improving and developing Flutter programming skills.';

  @override
  String get contact_us_label => 'Contact us:';

  @override
  String get copyright_text => '© 2024 Maintain Chat App. All rights reserved.';

  @override
  String get settings_title => 'Settings';

  @override
  String get interface_section => 'Interface';

  @override
  String get storage_management_menu => 'Storage Management';

  @override
  String get storage_management_subtitle => 'View and free up space';

  @override
  String get security_menu => 'Security';

  @override
  String get security_subtitle => 'Password';

  @override
  String get help_menu => 'Help';

  @override
  String get help_subtitle => 'FAQ, contact support';

  @override
  String get other_section => 'Other';

  @override
  String get language_menu => 'Language';

  @override
  String get vietnamese_label => 'Tiếng Việt';

  @override
  String get english_label => 'English';

  @override
  String get select_language_title => 'Select Language';

  @override
  String get light_theme => 'Light';

  @override
  String get dark_theme => 'Dark';

  @override
  String get system_theme => 'System';

  @override
  String get select_theme_title => 'Select Theme';

  @override
  String get light_theme_desc => 'Light theme';

  @override
  String get dark_theme_desc => 'Dark theme';

  @override
  String get system_theme_desc => 'Follow system settings';

  @override
  String get font_size_menu => 'Font Size';

  @override
  String get select_font_size_title => 'Select Font Size';

  @override
  String get sample_message => 'Hello! This is a sample message';

  @override
  String get chat_wallpaper_menu => 'Chat Wallpaper';

  @override
  String get default_wallpaper => 'Default';

  @override
  String get green_wallpaper => 'Green';

  @override
  String get pink_wallpaper => 'Pink';

  @override
  String get orange_wallpaper => 'Orange';

  @override
  String get select_wallpaper_title => 'Select Wallpaper';

  @override
  String get cache_memory => 'Cache';

  @override
  String get optimize_performance => 'Optimize app performance';

  @override
  String get cache_description =>
      'Cache helps the app load faster by temporarily storing images, videos and other data. Clearing cache will free up storage space but may slow down the app during initial use.';

  @override
  String get clear_cache_button => 'Clear Cache';

  @override
  String get notice_label => 'Note';

  @override
  String get downloaded_media_notice =>
      'Downloaded images and videos will not be deleted';

  @override
  String get cache_recreation_notice =>
      'Cache data will be recreated when you use the app';

  @override
  String get speed_notice => 'The app may run slower after clearing cache';

  @override
  String get clear_cache_confirm_title => 'Confirm';

  @override
  String get clear_cache_confirm_message =>
      'Are you sure you want to clear cache? This will delete all temporary data.';

  @override
  String get clear_cache_success => 'Cleared cache successfully';

  @override
  String get reset_password_menu => 'Reset Password';

  @override
  String get protect_account_subtitle => 'Protect your account';

  @override
  String get security_description =>
      'To ensure your account safety, we recommend changing your password periodically. A strong password should have at least 8 characters, including uppercase, lowercase, numbers and special characters.';

  @override
  String get email_label => 'Email';

  @override
  String get enter_email_hint => 'Enter your email';

  @override
  String get send_button => 'Send';

  @override
  String get security_tips_title => 'Security Tips';

  @override
  String get strong_password_tip => 'Use a strong and unique password';

  @override
  String get periodic_change_tip =>
      'Change password periodically (every 3-6 months)';

  @override
  String get no_share_password_tip => 'Do not share password with others';

  @override
  String get two_factor_auth_tip =>
      'Enable 2-step authentication for enhanced security';

  @override
  String get invalid_email_error => 'Invalid email';

  @override
  String get reset_email_sent_success =>
      'Reset password email sent. Please check your inbox.';

  @override
  String get help_support_title => 'We\'re here to help';

  @override
  String get help_support_subtitle => 'Find answers and contact support';

  @override
  String get faq_section => 'Frequently Asked Questions';

  @override
  String get faq_how_to_send_msg_q => 'How to send a message?';

  @override
  String get faq_how_to_send_msg_a =>
      'Select a contact from the list or search, then enter the message in the chat box and press send.';

  @override
  String get faq_how_to_delete_msg_q => 'How to delete a message?';

  @override
  String get faq_how_to_delete_msg_a =>
      'Press and hold the message you want to delete, then select \"Delete\" from the menu. You can delete for yourself or for everyone.';

  @override
  String get faq_how_to_change_avatar_q => 'How to change profile picture?';

  @override
  String get faq_how_to_change_avatar_a =>
      'Go to Profile, tap on the current profile picture, then select \"Change photo\" to upload a new one from your gallery or take a photo.';

  @override
  String get faq_how_to_disable_notif_q => 'How to turn off notifications?';

  @override
  String get faq_how_to_disable_notif_a =>
      'Go to Settings > Notifications, then turn off the notification options you don\'t want to receive.';

  @override
  String get contact_support_section => 'Contact Support';

  @override
  String get contact_email_desc => 'Send us an email';

  @override
  String get contact_hotline_label => 'Hotline';

  @override
  String get contact_hotline_desc => 'Call for support (8:00 - 22:00)';

  @override
  String get contact_livechat_label => 'Live Chat';

  @override
  String get contact_livechat_desc => 'Fast response within a few minutes';

  @override
  String get contact_website_desc => 'Access help center';

  @override
  String get average_response_time =>
      'Average response time: 2-4 business hours';

  @override
  String get no_data_message => 'No data';

  @override
  String get error_occurred => 'An error occurred';

  @override
  String get send_friend_request_failed => 'Send friend request failed';

  @override
  String get revoke_invitation => 'Revoke';

  @override
  String get add_friend_action => 'Add friend';

  @override
  String get loading_label => 'Loading...';

  @override
  String get storage_permission_denied => 'Storage permission denied';

  @override
  String download_success(Object fileName) {
    return 'Downloaded: $fileName';
  }

  @override
  String download_error(Object error) {
    return 'Error downloading: $error';
  }

  @override
  String get cannot_load_video => 'Cannot load video';

  @override
  String get just_now => 'Just now';

  @override
  String get me_label => 'Me';

  @override
  String get image_tag => '[Image]';

  @override
  String get video_tag => '[Video]';

  @override
  String get audio_tag => '[Audio]';

  @override
  String send_image_failed(Object error) {
    return 'Send image failed: $error';
  }

  @override
  String send_video_failed(Object error) {
    return 'Send video failed: $error';
  }

  @override
  String send_audio_failed(Object error) {
    return 'Send audio failed: $error';
  }

  @override
  String get sending_audio => 'Sending audio...';

  @override
  String get sending_video => 'Sending video...';

  @override
  String get sending_image => 'Sending image...';

  @override
  String get pick_image_label => 'Pick image';

  @override
  String get pick_video_label => 'Pick video';

  @override
  String get record_audio_label => 'Record audio';

  @override
  String get active_now_label => 'Active now';

  @override
  String get offline_label => 'Offline';

  @override
  String get view_profile_label => 'View profile';

  @override
  String get send_message_failed => 'Send message failed';

  @override
  String get delete_message_failed => 'Delete message failed';

  @override
  String load_messages_error(Object error) {
    return 'Error loading messages: $error';
  }

  @override
  String start_chat_hint(Object name) {
    return 'Start a conversation with $name!';
  }

  @override
  String get delete_message_action => 'Delete message';

  @override
  String get delete_message_confirm_title => 'Confirm delete message';

  @override
  String get delete_message_confirm_message =>
      'Are you sure you want to delete this message?';

  @override
  String replying_label(Object name) {
    return 'Replying to $name';
  }

  @override
  String get type_message_hint => 'Type a message...';

  @override
  String get auth_error_user_not_found => 'Account does not exist';

  @override
  String get auth_error_wrong_password => 'Incorrect password';

  @override
  String get auth_error_invalid_email => 'Invalid email';

  @override
  String get auth_error_user_disabled => 'Account has been disabled';

  @override
  String get auth_error_too_many_requests =>
      'Too many requests. Please try again later';

  @override
  String get auth_error_network_failed => 'Network connection error';

  @override
  String get auth_error_invalid_credential => 'Email or password is incorrect';

  @override
  String get auth_error_email_already_in_use => 'Email is already in use';

  @override
  String get auth_error_weak_password =>
      'Weak password. Please choose a stronger one';

  @override
  String get auth_error_operation_not_allowed =>
      'Registration feature is disabled';

  @override
  String get auth_error_default => 'Operation failed';

  @override
  String get auth_login_failed => 'Login failed';

  @override
  String get auth_register_failed => 'Account creation failed';

  @override
  String get auth_check_failed => 'Error checking authentication';

  @override
  String get auth_reset_failed => 'Reset password failed, try again later';

  @override
  String get me_label_chat => 'Me';

  @override
  String get select_image => 'Select image';

  @override
  String get select_video => 'Select video';

  @override
  String get record_audio => 'Record audio';

  @override
  String get recording_status => 'Recording...';

  @override
  String get sending_audio_status => 'Sending audio...';

  @override
  String get sending_video_status => 'Sending video...';

  @override
  String get sending_image_status => 'Sending image...';

  @override
  String get view_profile_menu => 'View profile';

  @override
  String get send_image_failed_chat => 'Send image failed';

  @override
  String get send_video_failed_chat => 'Send video failed';

  @override
  String get send_audio_failed_chat => 'Send audio failed';

  @override
  String get mic_permission_needed => 'Microphone permission needed to record';

  @override
  String get mic_permission_settings =>
      'Please grant microphone permission in Settings';

  @override
  String get start_recording_error => 'Error starting recording';

  @override
  String get stop_recording_error => 'Error stopping recording';

  @override
  String replying_to_status(Object name) {
    return 'Replying to $name';
  }

  @override
  String get create_post_success => 'Post created successfully!';

  @override
  String get create_post_failed => 'Post creation failed!';

  @override
  String get posting_placeholder => 'Posting in progress...';

  @override
  String get post_deleted_message => 'Post has been deleted';

  @override
  String error_loading_posts(Object error) {
    return 'Error loading posts: $error';
  }

  @override
  String get save_action => 'Save';

  @override
  String get post_action => 'Post';

  @override
  String get post_hint => 'What\'s on your mind?';

  @override
  String get select_image_error => 'Error selecting image';

  @override
  String get select_video_error => 'Error selecting video';

  @override
  String get enter_post_content_error => 'Please enter post content';

  @override
  String get post_updated_message => 'Post updated successfully!';

  @override
  String get update_post_error => 'Error updating post';

  @override
  String get create_post_error => 'Error creating post';

  @override
  String get confirm_delete_title => 'Confirm delete';

  @override
  String get confirm_delete_post_message =>
      'Are you sure you want to delete this post?';

  @override
  String comments_count(Object count) {
    return 'Comments ($count)';
  }

  @override
  String replying_to_comment(Object name) {
    return 'Replying to $name';
  }

  @override
  String get upload_media_failed => 'Media upload failed. Please try again.';

  @override
  String get select_media_error => 'Could not select media. Please try again.';

  @override
  String get delete_comment_action => 'Delete comment';

  @override
  String get comment_hint => 'Write a comment...';

  @override
  String get fail_loading_comments =>
      'Could not load comments. Please try again.';

  @override
  String get error_label => 'Error';

  @override
  String get friends_title => 'Friends';

  @override
  String get friend_requests_tab => 'Friend requests';

  @override
  String get no_friends_message => 'No friends yet';

  @override
  String get no_results_message => 'No results found';

  @override
  String get no_friend_requests_message => 'No friend requests yet';

  @override
  String get accept_action => 'Accept';

  @override
  String get reject_action => 'Reject';

  @override
  String get about_title => 'About';

  @override
  String version_label(Object version) {
    return 'Version $version';
  }

  @override
  String get main_features_section => 'Main Features';

  @override
  String get realtime_messaging_title => 'Real-time Messaging';

  @override
  String get realtime_messaging_desc =>
      'Send and receive messages instantly with friends';

  @override
  String get contact_info =>
      'Email: support@maintainchat.com\nWebsite: www.maintainchat.com\nHotline: 1900-xxxx';

  @override
  String get notification_label => 'Notification';

  @override
  String get start_chat_invitation => 'Let\'s start the conversation!';

  @override
  String get error_occurred_message => 'An error occurred';

  @override
  String get friend_request_fail => 'Failed to send friend request';

  @override
  String get revoke_action => 'Revoke';

  @override
  String download_success_message(Object fileName) {
    return 'Downloaded: $fileName';
  }

  @override
  String download_error_message(Object error) {
    return 'Error downloading: $error';
  }

  @override
  String get could_not_load_video => 'Could not load video';

  @override
  String get just_now_label => 'Just now';
}
