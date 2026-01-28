import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @hello.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào'**
  String get hello;

  /// No description provided for @monday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ hai'**
  String get monday;

  /// No description provided for @fill_info.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập đầy đủ thông tin'**
  String get fill_info;

  /// No description provided for @hello_signin.
  ///
  /// In vi, this message translates to:
  /// **'XIN CHÀO, ĐĂNG NHẬP'**
  String get hello_signin;

  /// No description provided for @email_hint.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ email (ví dụ: joydeo@gmail.com)'**
  String get email_hint;

  /// No description provided for @password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get password;

  /// No description provided for @forgot_password.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgot_password;

  /// No description provided for @signin_button.
  ///
  /// In vi, this message translates to:
  /// **'ĐĂNG NHẬP'**
  String get signin_button;

  /// No description provided for @dont_have_account.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản? '**
  String get dont_have_account;

  /// No description provided for @signup_link.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get signup_link;

  /// No description provided for @enter_email.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email'**
  String get enter_email;

  /// No description provided for @email_not_correct.
  ///
  /// In vi, this message translates to:
  /// **'Email không đúng định dạng'**
  String get email_not_correct;

  /// No description provided for @enter_name.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên'**
  String get enter_name;

  /// No description provided for @name_too_short.
  ///
  /// In vi, this message translates to:
  /// **'Tên phải ít nhất 4 ký tự'**
  String get name_too_short;

  /// No description provided for @enter_password.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu'**
  String get enter_password;

  /// No description provided for @password_too_short.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu phải ít nhất 6 ký tự'**
  String get password_too_short;

  /// No description provided for @enter_confirm_password.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập lại mật khẩu'**
  String get enter_confirm_password;

  /// No description provided for @confirm_password_not_match.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu không trùng khớp'**
  String get confirm_password_not_match;

  /// No description provided for @create_account_title.
  ///
  /// In vi, this message translates to:
  /// **'TẠO TÀI KHOẢN'**
  String get create_account_title;

  /// No description provided for @full_name.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get full_name;

  /// No description provided for @phone_or_email.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại hoặc Email'**
  String get phone_or_email;

  /// No description provided for @confirm_password.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get confirm_password;

  /// No description provided for @signup_button.
  ///
  /// In vi, this message translates to:
  /// **'ĐĂNG KÝ'**
  String get signup_button;

  /// No description provided for @already_have_account.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản? '**
  String get already_have_account;

  /// No description provided for @signin_link.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get signin_link;

  /// No description provided for @enter_your_email.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email của bạn'**
  String get enter_your_email;

  /// No description provided for @incorrect_email.
  ///
  /// In vi, this message translates to:
  /// **'Email không chính xác'**
  String get incorrect_email;

  /// No description provided for @reset_password_title.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mật khẩu'**
  String get reset_password_title;

  /// No description provided for @enter_email_to_reset.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email của bạn để đặt lại'**
  String get enter_email_to_reset;

  /// No description provided for @email_address.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ Email'**
  String get email_address;

  /// No description provided for @reset_instructions.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi sẽ gửi một liên kết đặt lại mật khẩu đến địa chỉ email của bạn.'**
  String get reset_instructions;

  /// No description provided for @send_reset_link.
  ///
  /// In vi, this message translates to:
  /// **'Gửi liên kết đặt lại'**
  String get send_reset_link;

  /// No description provided for @back_to_login.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại Đăng nhập'**
  String get back_to_login;

  /// No description provided for @email_sent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi Email!'**
  String get email_sent;

  /// No description provided for @email_sent_details.
  ///
  /// In vi, this message translates to:
  /// **'Một liên kết đặt lại mật khẩu đã được gửi đến địa chỉ email của bạn. Vui lòng kiểm tra hộp thư đến.'**
  String get email_sent_details;

  /// No description provided for @got_it.
  ///
  /// In vi, this message translates to:
  /// **'Đã hiểu'**
  String get got_it;

  /// No description provided for @home_screen_title.
  ///
  /// In vi, this message translates to:
  /// **'Màn hình chính'**
  String get home_screen_title;

  /// No description provided for @logout_button.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout_button;

  /// No description provided for @messages_tab.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn'**
  String get messages_tab;

  /// No description provided for @posts_tab.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết'**
  String get posts_tab;

  /// No description provided for @profile_tab.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get profile_tab;

  /// No description provided for @messages_title.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn'**
  String get messages_title;

  /// No description provided for @user_not_found.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thông tin người dùng'**
  String get user_not_found;

  /// No description provided for @friend_list_load_error.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh sách bạn bè'**
  String get friend_list_load_error;

  /// No description provided for @no_friends.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bạn bè nào'**
  String get no_friends;

  /// No description provided for @delete_message_success.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tin nhắn thành công'**
  String get delete_message_success;

  /// No description provided for @messages_load_error.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải tin nhắn'**
  String get messages_load_error;

  /// No description provided for @no_messages.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tin nhắn nào'**
  String get no_messages;

  /// No description provided for @loading_error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi tải dữ liệu'**
  String get loading_error;

  /// No description provided for @search_hint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm...'**
  String get search_hint;

  /// No description provided for @notifications_action.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notifications_action;

  /// No description provided for @delete_action.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete_action;

  /// No description provided for @unknown_user.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng không xác định'**
  String get unknown_user;

  /// No description provided for @start_conversation_hint.
  ///
  /// In vi, this message translates to:
  /// **'Hãy bắt đầu cuộc trò chuyện!'**
  String get start_conversation_hint;

  /// No description provided for @post_created_success.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết đã được tạo thành công!'**
  String get post_created_success;

  /// No description provided for @post_created_failed.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết tạo thất bại!'**
  String get post_created_failed;

  /// No description provided for @posting_in_progress.
  ///
  /// In vi, this message translates to:
  /// **'Đang đăng bài viết...'**
  String get posting_in_progress;

  /// No description provided for @posts_title.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết'**
  String get posts_title;

  /// No description provided for @post_load_error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tải bài viết: {error}'**
  String post_load_error(Object error);

  /// No description provided for @no_posts_message.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài viết nào. Hãy tạo bài viết mới!'**
  String get no_posts_message;

  /// No description provided for @post_deleted_success.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết đã được xóa'**
  String get post_deleted_success;

  /// No description provided for @image_pick_error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi chọn ảnh'**
  String get image_pick_error;

  /// No description provided for @video_pick_error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi chọn video'**
  String get video_pick_error;

  /// No description provided for @content_empty_error.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập nội dung bài viết'**
  String get content_empty_error;

  /// No description provided for @post_updated_success.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết đã được cập nhật!'**
  String get post_updated_success;

  /// No description provided for @post_update_error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi cập nhật bài viết'**
  String get post_update_error;

  /// No description provided for @post_create_error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi tạo bài viết'**
  String get post_create_error;

  /// No description provided for @edit_post_title.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa bài viết'**
  String get edit_post_title;

  /// No description provided for @create_post_title.
  ///
  /// In vi, this message translates to:
  /// **'Tạo bài viết'**
  String get create_post_title;

  /// No description provided for @save_button.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save_button;

  /// No description provided for @post_button.
  ///
  /// In vi, this message translates to:
  /// **'Đăng'**
  String get post_button;

  /// No description provided for @public_visibility.
  ///
  /// In vi, this message translates to:
  /// **'Công khai'**
  String get public_visibility;

  /// No description provided for @what_on_your_mind.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang nghĩ gì?'**
  String get what_on_your_mind;

  /// No description provided for @add_to_post.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vào bài viết'**
  String get add_to_post;

  /// No description provided for @edit_post_action.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa bài viết'**
  String get edit_post_action;

  /// No description provided for @delete_post_action.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bài viết'**
  String get delete_post_action;

  /// No description provided for @cancel_action.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel_action;

  /// No description provided for @delete_confirm_title.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận xóa'**
  String get delete_confirm_title;

  /// No description provided for @delete_confirm_message.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xóa bài viết này không?'**
  String get delete_confirm_message;

  /// No description provided for @delete_button.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete_button;

  /// No description provided for @empty_comment_error.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không thể gửi bình luận trống'**
  String get empty_comment_error;

  /// No description provided for @media_upload_failed.
  ///
  /// In vi, this message translates to:
  /// **'Tải lên media thất bại. Vui lòng thử lại.'**
  String get media_upload_failed;

  /// No description provided for @pick_image_action.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh'**
  String get pick_image_action;

  /// No description provided for @pick_video_action.
  ///
  /// In vi, this message translates to:
  /// **'Chọn video'**
  String get pick_video_action;

  /// No description provided for @image_pick_failed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể chọn ảnh. Vui lòng thử lại.'**
  String get image_pick_failed;

  /// No description provided for @video_pick_failed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể chọn video. Vui lòng thử lại.'**
  String get video_pick_failed;

  /// No description provided for @comment_empty_save_error.
  ///
  /// In vi, this message translates to:
  /// **'Bình luận không thể để trống'**
  String get comment_empty_save_error;

  /// No description provided for @delete_comment_title.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bình luận'**
  String get delete_comment_title;

  /// No description provided for @delete_comment_confirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xóa bình luận này?'**
  String get delete_comment_confirm;

  /// No description provided for @edit_comment_action.
  ///
  /// In vi, this message translates to:
  /// **'Sửa bình luận'**
  String get edit_comment_action;

  /// No description provided for @comments_header.
  ///
  /// In vi, this message translates to:
  /// **'Bình luận ({count})'**
  String comments_header(Object count);

  /// No description provided for @no_comments_message.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bình luận nào. Hãy là người đầu tiên bình luận!'**
  String get no_comments_message;

  /// No description provided for @replying_to.
  ///
  /// In vi, this message translates to:
  /// **'Đang phản hồi {name}'**
  String replying_to(Object name);

  /// No description provided for @write_comment_hint.
  ///
  /// In vi, this message translates to:
  /// **'Viết bình luận...'**
  String get write_comment_hint;

  /// No description provided for @post_author_label.
  ///
  /// In vi, this message translates to:
  /// **'Tác giả'**
  String get post_author_label;

  /// No description provided for @add_media_placeholder.
  ///
  /// In vi, this message translates to:
  /// **'Thêm ảnh/video'**
  String get add_media_placeholder;

  /// No description provided for @reply_action.
  ///
  /// In vi, this message translates to:
  /// **'Phản hồi'**
  String get reply_action;

  /// No description provided for @comment_hint_edit.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung bình luận ...'**
  String get comment_hint_edit;

  /// No description provided for @comment_load_error.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải bình luận.'**
  String get comment_load_error;

  /// No description provided for @retry_button.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry_button;

  /// No description provided for @user_info_not_found.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thông tin người dùng'**
  String get user_info_not_found;

  /// No description provided for @reload_button.
  ///
  /// In vi, this message translates to:
  /// **'Tải lại'**
  String get reload_button;

  /// No description provided for @posts_stat.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết'**
  String get posts_stat;

  /// No description provided for @friends_stat.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get friends_stat;

  /// No description provided for @personal_info_menu.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cá nhân'**
  String get personal_info_menu;

  /// No description provided for @friends_menu.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get friends_menu;

  /// No description provided for @notifications_menu.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notifications_menu;

  /// No description provided for @about_menu.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu'**
  String get about_menu;

  /// No description provided for @logout_menu.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout_menu;

  /// No description provided for @image_selected_success.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh đã được chọn'**
  String get image_selected_success;

  /// No description provided for @image_pick_error_detail.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi chọn ảnh: {error}'**
  String image_pick_error_detail(Object error);

  /// No description provided for @name_empty_error.
  ///
  /// In vi, this message translates to:
  /// **'Tên không được để trống'**
  String get name_empty_error;

  /// No description provided for @profile_update_error_detail.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi tải ảnh lên: {error}'**
  String profile_update_error_detail(Object error);

  /// No description provided for @info_saved_success.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu thông tin'**
  String get info_saved_success;

  /// No description provided for @cancel_edit_title.
  ///
  /// In vi, this message translates to:
  /// **'Hủy chỉnh sửa?'**
  String get cancel_edit_title;

  /// No description provided for @cancel_edit_message.
  ///
  /// In vi, this message translates to:
  /// **'Các thay đổi sẽ không được lưu'**
  String get cancel_edit_message;

  /// No description provided for @stay_button.
  ///
  /// In vi, this message translates to:
  /// **'Ở lại'**
  String get stay_button;

  /// No description provided for @confirm_cancel_button.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get confirm_cancel_button;

  /// No description provided for @personal_info_title.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cá nhân'**
  String get personal_info_title;

  /// No description provided for @display_name_label.
  ///
  /// In vi, this message translates to:
  /// **'Tên hiển thị'**
  String get display_name_label;

  /// No description provided for @other_name_label.
  ///
  /// In vi, this message translates to:
  /// **'Tên khác'**
  String get other_name_label;

  /// No description provided for @phone_number_label.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get phone_number_label;

  /// No description provided for @address_label.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ'**
  String get address_label;

  /// No description provided for @other_info_section.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin khác'**
  String get other_info_section;

  /// No description provided for @save_changes_button.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get save_changes_button;

  /// No description provided for @enter_field_hint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập {field}'**
  String enter_field_hint(Object field);

  /// No description provided for @friend_requests_tab_title.
  ///
  /// In vi, this message translates to:
  /// **'Lời mời kết bạn'**
  String get friend_requests_tab_title;

  /// No description provided for @friends_tab_title.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get friends_tab_title;

  /// No description provided for @search_hint_dots.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm...'**
  String get search_hint_dots;

  /// No description provided for @no_results.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy kết quả'**
  String get no_results;

  /// No description provided for @remove_friend_title.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bạn bè'**
  String get remove_friend_title;

  /// No description provided for @remove_friend_confirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xóa {name} khỏi danh sách bạn bè?'**
  String remove_friend_confirm(Object name);

  /// No description provided for @remove_friend_success.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa {name} khỏi danh sách bạn bè'**
  String remove_friend_success(Object name);

  /// No description provided for @unfriend_action.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bạn bè'**
  String get unfriend_action;

  /// No description provided for @no_friend_requests.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lời mời kết bạn nào'**
  String get no_friend_requests;

  /// No description provided for @accept_button.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get accept_button;

  /// No description provided for @reject_button.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get reject_button;

  /// No description provided for @app_version.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản 1.0.0'**
  String get app_version;

  /// No description provided for @about_app_section.
  ///
  /// In vi, this message translates to:
  /// **'Về ứng dụng'**
  String get about_app_section;

  /// No description provided for @about_app_description.
  ///
  /// In vi, this message translates to:
  /// **'Zipo Social là một ứng dụng nhắn tin hiện đại được thiết kế để kết nối mọi người một cách dễ dàng và bảo mật. Với giao diện thân thiện và tính năng phong phú, ứng dụng mang đến trải nghiệm trò chuyện tuyệt vời cho người dùng.'**
  String get about_app_description;

  /// No description provided for @key_features_section.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng chính'**
  String get key_features_section;

  /// No description provided for @messaging_feature_title.
  ///
  /// In vi, this message translates to:
  /// **'Nhắn tin thời gian thực'**
  String get messaging_feature_title;

  /// No description provided for @messaging_feature_desc.
  ///
  /// In vi, this message translates to:
  /// **'Gửi và nhận tin nhắn tức thì với bạn bè'**
  String get messaging_feature_desc;

  /// No description provided for @media_sharing_title.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ hình ảnh & video'**
  String get media_sharing_title;

  /// No description provided for @media_sharing_desc.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ khoảnh khắc với chất lượng cao'**
  String get media_sharing_desc;

  /// No description provided for @friend_management_title.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý bạn bè'**
  String get friend_management_title;

  /// No description provided for @friend_management_desc.
  ///
  /// In vi, this message translates to:
  /// **'Kết nối và quản lý danh sách bạn bè dễ dàng'**
  String get friend_management_desc;

  /// No description provided for @smart_notifications_title.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo thông minh'**
  String get smart_notifications_title;

  /// No description provided for @smart_notifications_desc.
  ///
  /// In vi, this message translates to:
  /// **'Nhận thông báo quan trọng kịp thời'**
  String get smart_notifications_desc;

  /// No description provided for @high_security_title.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật cao'**
  String get high_security_title;

  /// No description provided for @high_security_desc.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu được mã hóa và bảo vệ an toàn'**
  String get high_security_desc;

  /// No description provided for @about_us_section.
  ///
  /// In vi, this message translates to:
  /// **'Về chúng tôi'**
  String get about_us_section;

  /// No description provided for @about_us_description.
  ///
  /// In vi, this message translates to:
  /// **'Zipo Social được phát triển bởi đội ngũ một thành viên với mục đích thực hành, nâng cao và phát triển kỹ năng lập trình Flutter.'**
  String get about_us_description;

  /// No description provided for @contact_us_label.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ với chúng tôi:'**
  String get contact_us_label;

  /// No description provided for @copyright_text.
  ///
  /// In vi, this message translates to:
  /// **'© 2024 Maintain Chat App. Tất cả quyền được bảo lưu.'**
  String get copyright_text;

  /// No description provided for @settings_title.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings_title;

  /// No description provided for @interface_section.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get interface_section;

  /// No description provided for @storage_management_menu.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý bộ nhớ'**
  String get storage_management_menu;

  /// No description provided for @storage_management_subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Xem và giải phóng dung lượng'**
  String get storage_management_subtitle;

  /// No description provided for @security_menu.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật'**
  String get security_menu;

  /// No description provided for @security_subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get security_subtitle;

  /// No description provided for @help_menu.
  ///
  /// In vi, this message translates to:
  /// **'Trợ giúp'**
  String get help_menu;

  /// No description provided for @help_subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi thường gặp, liên hệ hỗ trợ'**
  String get help_subtitle;

  /// No description provided for @other_section.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get other_section;

  /// No description provided for @language_menu.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language_menu;

  /// No description provided for @vietnamese_label.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese_label;

  /// No description provided for @english_label.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get english_label;

  /// No description provided for @select_language_title.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get select_language_title;

  /// No description provided for @light_theme.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get light_theme;

  /// No description provided for @dark_theme.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get dark_theme;

  /// No description provided for @system_theme.
  ///
  /// In vi, this message translates to:
  /// **'Tự động'**
  String get system_theme;

  /// No description provided for @select_theme_title.
  ///
  /// In vi, this message translates to:
  /// **'Chọn giao diện'**
  String get select_theme_title;

  /// No description provided for @light_theme_desc.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện sáng'**
  String get light_theme_desc;

  /// No description provided for @dark_theme_desc.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện tối'**
  String get dark_theme_desc;

  /// No description provided for @system_theme_desc.
  ///
  /// In vi, this message translates to:
  /// **'Theo cài đặt hệ thống'**
  String get system_theme_desc;

  /// No description provided for @font_size_menu.
  ///
  /// In vi, this message translates to:
  /// **'Cỡ chữ'**
  String get font_size_menu;

  /// No description provided for @select_font_size_title.
  ///
  /// In vi, this message translates to:
  /// **'Chọn cỡ chữ'**
  String get select_font_size_title;

  /// No description provided for @sample_message.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào! Đây là tin nhắn mẫu'**
  String get sample_message;

  /// No description provided for @chat_wallpaper_menu.
  ///
  /// In vi, this message translates to:
  /// **'Hình nền chat'**
  String get chat_wallpaper_menu;

  /// No description provided for @default_wallpaper.
  ///
  /// In vi, this message translates to:
  /// **'Mặc định'**
  String get default_wallpaper;

  /// No description provided for @green_wallpaper.
  ///
  /// In vi, this message translates to:
  /// **'Xanh lá'**
  String get green_wallpaper;

  /// No description provided for @pink_wallpaper.
  ///
  /// In vi, this message translates to:
  /// **'Hồng'**
  String get pink_wallpaper;

  /// No description provided for @orange_wallpaper.
  ///
  /// In vi, this message translates to:
  /// **'Cam'**
  String get orange_wallpaper;

  /// No description provided for @select_wallpaper_title.
  ///
  /// In vi, this message translates to:
  /// **'Chọn hình nền'**
  String get select_wallpaper_title;

  /// No description provided for @cache_memory.
  ///
  /// In vi, this message translates to:
  /// **'Bộ nhớ đệm'**
  String get cache_memory;

  /// No description provided for @optimize_performance.
  ///
  /// In vi, this message translates to:
  /// **'Tối ưu hiệu suất ứng dụng'**
  String get optimize_performance;

  /// No description provided for @cache_description.
  ///
  /// In vi, this message translates to:
  /// **'Bộ nhớ đệm giúp ứng dụng tải nhanh hơn bằng cách lưu trữ tạm thời hình ảnh, video và dữ liệu khác. Việc xóa bộ nhớ đệm sẽ giải phóng không gian lưu trữ nhưng có thể làm chậm ứng dụng trong lần sử dụng đầu tiên.'**
  String get cache_description;

  /// No description provided for @clear_cache_button.
  ///
  /// In vi, this message translates to:
  /// **'Giải phóng bộ nhớ đệm'**
  String get clear_cache_button;

  /// No description provided for @notice_label.
  ///
  /// In vi, this message translates to:
  /// **'Lưu ý'**
  String get notice_label;

  /// No description provided for @downloaded_media_notice.
  ///
  /// In vi, this message translates to:
  /// **'Hình ảnh và video đã tải xuống sẽ không bị xóa'**
  String get downloaded_media_notice;

  /// No description provided for @cache_recreation_notice.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu đệm sẽ được tạo lại khi bạn sử dụng ứng dụng'**
  String get cache_recreation_notice;

  /// No description provided for @speed_notice.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng có thể chạy chậm hơn sau khi xóa đệm'**
  String get speed_notice;

  /// No description provided for @clear_cache_confirm_title.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get clear_cache_confirm_title;

  /// No description provided for @clear_cache_confirm_message.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn giải phóng bộ nhớ đệm? Thao tác này sẽ xóa tất cả dữ liệu tạm thời.'**
  String get clear_cache_confirm_message;

  /// No description provided for @clear_cache_success.
  ///
  /// In vi, this message translates to:
  /// **'Đã giải phóng bộ nhớ đệm thành công'**
  String get clear_cache_success;

  /// No description provided for @reset_password_menu.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mật khẩu'**
  String get reset_password_menu;

  /// No description provided for @protect_account_subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Bảo vệ tài khoản của bạn'**
  String get protect_account_subtitle;

  /// No description provided for @security_description.
  ///
  /// In vi, this message translates to:
  /// **'Để đảm bảo an toàn cho tài khoản của bạn, chúng tôi khuyến nghị thay đổi mật khẩu định kỳ. Mật khẩu mạnh nên có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.'**
  String get security_description;

  /// No description provided for @email_label.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get email_label;

  /// No description provided for @enter_email_hint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email của bạn'**
  String get enter_email_hint;

  /// No description provided for @send_button.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get send_button;

  /// No description provided for @security_tips_title.
  ///
  /// In vi, this message translates to:
  /// **'Mẹo bảo mật'**
  String get security_tips_title;

  /// No description provided for @strong_password_tip.
  ///
  /// In vi, this message translates to:
  /// **'Sử dụng mật khẩu mạnh và độc nhất'**
  String get strong_password_tip;

  /// No description provided for @periodic_change_tip.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi mật khẩu định kỳ (3-6 tháng/lần)'**
  String get periodic_change_tip;

  /// No description provided for @no_share_password_tip.
  ///
  /// In vi, this message translates to:
  /// **'Không chia sẻ mật khẩu với người khác'**
  String get no_share_password_tip;

  /// No description provided for @two_factor_auth_tip.
  ///
  /// In vi, this message translates to:
  /// **'Bật xác thực 2 bước để tăng cường bảo mật'**
  String get two_factor_auth_tip;

  /// No description provided for @invalid_email_error.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ'**
  String get invalid_email_error;

  /// No description provided for @reset_email_sent_success.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi email đặt lại mật khẩu. Vui lòng kiểm tra hộp thư của bạn.'**
  String get reset_email_sent_success;

  /// No description provided for @help_support_title.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi sẵn sàng hỗ trợ'**
  String get help_support_title;

  /// No description provided for @help_support_subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tìm câu trả lời và liên hệ hỗ trợ'**
  String get help_support_subtitle;

  /// No description provided for @faq_section.
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi thường gặp'**
  String get faq_section;

  /// No description provided for @faq_how_to_send_msg_q.
  ///
  /// In vi, this message translates to:
  /// **'Làm thế nào để gửi tin nhắn?'**
  String get faq_how_to_send_msg_q;

  /// No description provided for @faq_how_to_send_msg_a.
  ///
  /// In vi, this message translates to:
  /// **'Chọn người liên hệ từ danh sách hoặc tìm kiếm, sau đó nhập tin nhắn ở ô chat và nhấn gửi.'**
  String get faq_how_to_send_msg_a;

  /// No description provided for @faq_how_to_delete_msg_q.
  ///
  /// In vi, this message translates to:
  /// **'Làm thế nào để xóa tin nhắn?'**
  String get faq_how_to_delete_msg_q;

  /// No description provided for @faq_how_to_delete_msg_a.
  ///
  /// In vi, this message translates to:
  /// **'Nhấn giữ vào tin nhắn bạn muốn xóa, sau đó chọn \"Xóa\" từ menu hiện lên. Bạn có thể xóa cho mình hoặc cho tất cả mọi người.'**
  String get faq_how_to_delete_msg_a;

  /// No description provided for @faq_how_to_change_avatar_q.
  ///
  /// In vi, this message translates to:
  /// **'Làm thế nào để thay đổi ảnh đại diện?'**
  String get faq_how_to_change_avatar_q;

  /// No description provided for @faq_how_to_change_avatar_a.
  ///
  /// In vi, this message translates to:
  /// **'Vào phần Hồ sơ, chạm vào ảnh đại diện hiện tại, sau đó chọn \"Thay đổi ảnh\" để tải ảnh mới từ thư viện hoặc chụp ảnh.'**
  String get faq_how_to_change_avatar_a;

  /// No description provided for @faq_how_to_disable_notif_q.
  ///
  /// In vi, this message translates to:
  /// **'Làm thế nào để tắt thông báo?'**
  String get faq_how_to_disable_notif_q;

  /// No description provided for @faq_how_to_disable_notif_a.
  ///
  /// In vi, this message translates to:
  /// **'Vào Cài đặt > Thông báo, sau đó tắt các tùy chọn thông báo bạn không muốn nhận.'**
  String get faq_how_to_disable_notif_a;

  /// No description provided for @contact_support_section.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ hỗ trợ'**
  String get contact_support_section;

  /// No description provided for @contact_email_desc.
  ///
  /// In vi, this message translates to:
  /// **'Gửi email cho chúng tôi'**
  String get contact_email_desc;

  /// No description provided for @contact_hotline_label.
  ///
  /// In vi, this message translates to:
  /// **'Hotline'**
  String get contact_hotline_label;

  /// No description provided for @contact_hotline_desc.
  ///
  /// In vi, this message translates to:
  /// **'Gọi điện hỗ trợ (8:00 - 22:00)'**
  String get contact_hotline_desc;

  /// No description provided for @contact_livechat_label.
  ///
  /// In vi, this message translates to:
  /// **'Trò chuyện trực tuyến'**
  String get contact_livechat_label;

  /// No description provided for @contact_livechat_desc.
  ///
  /// In vi, this message translates to:
  /// **'Phản hồi nhanh trong vài phút'**
  String get contact_livechat_desc;

  /// No description provided for @contact_website_desc.
  ///
  /// In vi, this message translates to:
  /// **'Truy cập trung tâm trợ giúp'**
  String get contact_website_desc;

  /// No description provided for @average_response_time.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian phản hồi trung bình: 2-4 giờ làm việc'**
  String get average_response_time;

  /// No description provided for @no_data_message.
  ///
  /// In vi, this message translates to:
  /// **'Không có dữ liệu'**
  String get no_data_message;

  /// No description provided for @error_occurred.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi'**
  String get error_occurred;

  /// No description provided for @send_friend_request_failed.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời mời kết bạn thất bại'**
  String get send_friend_request_failed;

  /// No description provided for @revoke_invitation.
  ///
  /// In vi, this message translates to:
  /// **'Thu hồi'**
  String get revoke_invitation;

  /// No description provided for @add_friend_action.
  ///
  /// In vi, this message translates to:
  /// **'Kết bạn'**
  String get add_friend_action;

  /// No description provided for @loading_label.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải...'**
  String get loading_label;

  /// No description provided for @storage_permission_denied.
  ///
  /// In vi, this message translates to:
  /// **'Quyền truy cập bộ nhớ bị từ chối'**
  String get storage_permission_denied;

  /// No description provided for @download_success.
  ///
  /// In vi, this message translates to:
  /// **'Đã tải xuống: {fileName}'**
  String download_success(Object fileName);

  /// No description provided for @download_error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi tải xuống: {error}'**
  String download_error(Object error);

  /// No description provided for @cannot_load_video.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải video'**
  String get cannot_load_video;

  /// No description provided for @just_now.
  ///
  /// In vi, this message translates to:
  /// **'Vừa xong'**
  String get just_now;

  /// No description provided for @me_label.
  ///
  /// In vi, this message translates to:
  /// **'Tôi'**
  String get me_label;

  /// No description provided for @image_tag.
  ///
  /// In vi, this message translates to:
  /// **'[Hình ảnh]'**
  String get image_tag;

  /// No description provided for @video_tag.
  ///
  /// In vi, this message translates to:
  /// **'[Video]'**
  String get video_tag;

  /// No description provided for @audio_tag.
  ///
  /// In vi, this message translates to:
  /// **'[Audio]'**
  String get audio_tag;

  /// No description provided for @send_image_failed.
  ///
  /// In vi, this message translates to:
  /// **'Gửi ảnh thất bại: {error}'**
  String send_image_failed(Object error);

  /// No description provided for @send_video_failed.
  ///
  /// In vi, this message translates to:
  /// **'Gửi video thất bại: {error}'**
  String send_video_failed(Object error);

  /// No description provided for @send_audio_failed.
  ///
  /// In vi, this message translates to:
  /// **'Gửi audio thất bại: {error}'**
  String send_audio_failed(Object error);

  /// No description provided for @sending_audio.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi audio...'**
  String get sending_audio;

  /// No description provided for @sending_video.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi video...'**
  String get sending_video;

  /// No description provided for @sending_image.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi ảnh...'**
  String get sending_image;

  /// No description provided for @pick_image_label.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh'**
  String get pick_image_label;

  /// No description provided for @pick_video_label.
  ///
  /// In vi, this message translates to:
  /// **'Chọn video'**
  String get pick_video_label;

  /// No description provided for @record_audio_label.
  ///
  /// In vi, this message translates to:
  /// **'Ghi âm'**
  String get record_audio_label;

  /// No description provided for @active_now_label.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get active_now_label;

  /// No description provided for @offline_label.
  ///
  /// In vi, this message translates to:
  /// **'Offline'**
  String get offline_label;

  /// No description provided for @view_profile_label.
  ///
  /// In vi, this message translates to:
  /// **'Xem trang cá nhân'**
  String get view_profile_label;

  /// No description provided for @send_message_failed.
  ///
  /// In vi, this message translates to:
  /// **'Gửi tin nhắn thất bại'**
  String get send_message_failed;

  /// No description provided for @delete_message_failed.
  ///
  /// In vi, this message translates to:
  /// **'Xoá tin nhắn thất bại'**
  String get delete_message_failed;

  /// No description provided for @load_messages_error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tải tin nhắn: {error}'**
  String load_messages_error(Object error);

  /// No description provided for @start_chat_hint.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu cuộc trò chuyện với {name}!'**
  String start_chat_hint(Object name);

  /// No description provided for @delete_message_action.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tin nhắn'**
  String get delete_message_action;

  /// No description provided for @delete_message_confirm_title.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận xóa tin nhắn'**
  String get delete_message_confirm_title;

  /// No description provided for @delete_message_confirm_message.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xóa tin nhắn này không?'**
  String get delete_message_confirm_message;

  /// No description provided for @replying_label.
  ///
  /// In vi, this message translates to:
  /// **'Đang trả lời {name}'**
  String replying_label(Object name);

  /// No description provided for @type_message_hint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tin nhắn...'**
  String get type_message_hint;

  /// No description provided for @auth_error_user_not_found.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản không tồn tại'**
  String get auth_error_user_not_found;

  /// No description provided for @auth_error_wrong_password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu không đúng'**
  String get auth_error_wrong_password;

  /// No description provided for @auth_error_invalid_email.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ'**
  String get auth_error_invalid_email;

  /// No description provided for @auth_error_user_disabled.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản đã bị vô hiệu hóa'**
  String get auth_error_user_disabled;

  /// No description provided for @auth_error_too_many_requests.
  ///
  /// In vi, this message translates to:
  /// **'Quá nhiều lần thử. Vui lòng thử lại sau'**
  String get auth_error_too_many_requests;

  /// No description provided for @auth_error_network_failed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi kết nối mạng'**
  String get auth_error_network_failed;

  /// No description provided for @auth_error_invalid_credential.
  ///
  /// In vi, this message translates to:
  /// **'Email hoặc mật khẩu không đúng'**
  String get auth_error_invalid_credential;

  /// No description provided for @auth_error_email_already_in_use.
  ///
  /// In vi, this message translates to:
  /// **'Email đã được sử dụng'**
  String get auth_error_email_already_in_use;

  /// No description provided for @auth_error_weak_password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn'**
  String get auth_error_weak_password;

  /// No description provided for @auth_error_operation_not_allowed.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng đăng ký đã bị tắt'**
  String get auth_error_operation_not_allowed;

  /// No description provided for @auth_error_default.
  ///
  /// In vi, this message translates to:
  /// **'Thao tác thất bại'**
  String get auth_error_default;

  /// No description provided for @auth_login_failed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập thất bại'**
  String get auth_login_failed;

  /// No description provided for @auth_register_failed.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản thất bại'**
  String get auth_register_failed;

  /// No description provided for @auth_check_failed.
  ///
  /// In vi, this message translates to:
  /// **'Có lỗi khi kiểm tra xác thực'**
  String get auth_check_failed;

  /// No description provided for @auth_reset_failed.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mật khẩu thất bại, thử lại sau'**
  String get auth_reset_failed;

  /// No description provided for @me_label_chat.
  ///
  /// In vi, this message translates to:
  /// **'Tôi'**
  String get me_label_chat;

  /// No description provided for @select_image.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh'**
  String get select_image;

  /// No description provided for @select_video.
  ///
  /// In vi, this message translates to:
  /// **'Chọn video'**
  String get select_video;

  /// No description provided for @record_audio.
  ///
  /// In vi, this message translates to:
  /// **'Ghi âm'**
  String get record_audio;

  /// No description provided for @recording_status.
  ///
  /// In vi, this message translates to:
  /// **'Đang ghi âm...'**
  String get recording_status;

  /// No description provided for @sending_audio_status.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi audio...'**
  String get sending_audio_status;

  /// No description provided for @sending_video_status.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi video...'**
  String get sending_video_status;

  /// No description provided for @sending_image_status.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi ảnh...'**
  String get sending_image_status;

  /// No description provided for @view_profile_menu.
  ///
  /// In vi, this message translates to:
  /// **'Xem trang cá nhân'**
  String get view_profile_menu;

  /// No description provided for @send_image_failed_chat.
  ///
  /// In vi, this message translates to:
  /// **'Gửi ảnh thất bại'**
  String get send_image_failed_chat;

  /// No description provided for @send_video_failed_chat.
  ///
  /// In vi, this message translates to:
  /// **'Gửi video thất bại'**
  String get send_video_failed_chat;

  /// No description provided for @send_audio_failed_chat.
  ///
  /// In vi, this message translates to:
  /// **'Gửi audio thất bại'**
  String get send_audio_failed_chat;

  /// No description provided for @mic_permission_needed.
  ///
  /// In vi, this message translates to:
  /// **'Cần quyền truy cập microphone để ghi âm'**
  String get mic_permission_needed;

  /// No description provided for @mic_permission_settings.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng cấp quyền microphone trong Settings'**
  String get mic_permission_settings;

  /// No description provided for @start_recording_error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi bắt đầu ghi âm'**
  String get start_recording_error;

  /// No description provided for @stop_recording_error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi dừng ghi âm'**
  String get stop_recording_error;

  /// No description provided for @replying_to_status.
  ///
  /// In vi, this message translates to:
  /// **'Đang trả lời {name}'**
  String replying_to_status(Object name);

  /// No description provided for @create_post_success.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết đã được tạo thành công!'**
  String get create_post_success;

  /// No description provided for @create_post_failed.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết tạo thất bại!'**
  String get create_post_failed;

  /// No description provided for @posting_placeholder.
  ///
  /// In vi, this message translates to:
  /// **'Đang đăng bài viết...'**
  String get posting_placeholder;

  /// No description provided for @post_deleted_message.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết đã được xóa'**
  String get post_deleted_message;

  /// No description provided for @error_loading_posts.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tải bài viết: {error}'**
  String error_loading_posts(Object error);

  /// No description provided for @save_action.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save_action;

  /// No description provided for @post_action.
  ///
  /// In vi, this message translates to:
  /// **'Đăng'**
  String get post_action;

  /// No description provided for @post_hint.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang nghĩ gì?'**
  String get post_hint;

  /// No description provided for @select_image_error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi chọn ảnh'**
  String get select_image_error;

  /// No description provided for @select_video_error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi chọn video'**
  String get select_video_error;

  /// No description provided for @enter_post_content_error.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập nội dung bài viết'**
  String get enter_post_content_error;

  /// No description provided for @post_updated_message.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết đã được cập nhật!'**
  String get post_updated_message;

  /// No description provided for @update_post_error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi cập nhật bài viết'**
  String get update_post_error;

  /// No description provided for @create_post_error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi tạo bài viết'**
  String get create_post_error;

  /// No description provided for @confirm_delete_title.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận xóa'**
  String get confirm_delete_title;

  /// No description provided for @confirm_delete_post_message.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xóa bài viết này không?'**
  String get confirm_delete_post_message;

  /// No description provided for @comments_count.
  ///
  /// In vi, this message translates to:
  /// **'Bình luận ({count})'**
  String comments_count(Object count);

  /// No description provided for @replying_to_comment.
  ///
  /// In vi, this message translates to:
  /// **'Đang phản hồi {name}'**
  String replying_to_comment(Object name);

  /// No description provided for @upload_media_failed.
  ///
  /// In vi, this message translates to:
  /// **'Tải lên media thất bại. Vui lòng thử lại.'**
  String get upload_media_failed;

  /// No description provided for @select_media_error.
  ///
  /// In vi, this message translates to:
  /// **'Không thể chọn media. Vui lòng thử lại.'**
  String get select_media_error;

  /// No description provided for @delete_comment_action.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bình luận'**
  String get delete_comment_action;

  /// No description provided for @comment_hint.
  ///
  /// In vi, this message translates to:
  /// **'Viết bình luận...'**
  String get comment_hint;

  /// No description provided for @fail_loading_comments.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải bình luận. Vui lòng thử lại.'**
  String get fail_loading_comments;

  /// No description provided for @error_label.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi'**
  String get error_label;

  /// No description provided for @friends_title.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get friends_title;

  /// No description provided for @friend_requests_tab.
  ///
  /// In vi, this message translates to:
  /// **'Lời mời kết bạn'**
  String get friend_requests_tab;

  /// No description provided for @no_friends_message.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bạn bè nào'**
  String get no_friends_message;

  /// No description provided for @no_results_message.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy kết quả'**
  String get no_results_message;

  /// No description provided for @no_friend_requests_message.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lời mời kết bạn nào'**
  String get no_friend_requests_message;

  /// No description provided for @accept_action.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get accept_action;

  /// No description provided for @reject_action.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get reject_action;

  /// No description provided for @about_title.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu'**
  String get about_title;

  /// No description provided for @version_label.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản {version}'**
  String version_label(Object version);

  /// No description provided for @main_features_section.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng chính'**
  String get main_features_section;

  /// No description provided for @realtime_messaging_title.
  ///
  /// In vi, this message translates to:
  /// **'Nhắn tin thời gian thực'**
  String get realtime_messaging_title;

  /// No description provided for @realtime_messaging_desc.
  ///
  /// In vi, this message translates to:
  /// **'Gửi và nhận tin nhắn tức thì với bạn bè'**
  String get realtime_messaging_desc;

  /// No description provided for @contact_info.
  ///
  /// In vi, this message translates to:
  /// **'Email: support@maintainchat.com\nWebsite: www.maintainchat.com\nHotline: 1900-xxxx'**
  String get contact_info;

  /// No description provided for @notification_label.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notification_label;

  /// No description provided for @start_chat_invitation.
  ///
  /// In vi, this message translates to:
  /// **'Hãy bắt đầu cuộc trò chuyện!'**
  String get start_chat_invitation;

  /// No description provided for @error_occurred_message.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi'**
  String get error_occurred_message;

  /// No description provided for @friend_request_fail.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời mời kết bạn thất bại'**
  String get friend_request_fail;

  /// No description provided for @revoke_action.
  ///
  /// In vi, this message translates to:
  /// **'Thu hồi'**
  String get revoke_action;

  /// No description provided for @download_success_message.
  ///
  /// In vi, this message translates to:
  /// **'Đã tải xuống: {fileName}'**
  String download_success_message(Object fileName);

  /// No description provided for @download_error_message.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi tải xuống: {error}'**
  String download_error_message(Object error);

  /// No description provided for @could_not_load_video.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải video'**
  String get could_not_load_video;

  /// No description provided for @just_now_label.
  ///
  /// In vi, this message translates to:
  /// **'Vừa xong'**
  String get just_now_label;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
