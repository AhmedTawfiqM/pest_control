import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ar', 'SA'),
  ];

  // General
  String get appName => _localizedValues[locale.languageCode]!['app_name']!;
  String get yes => _localizedValues[locale.languageCode]!['yes']!;
  String get no => _localizedValues[locale.languageCode]!['no']!;
  String get ok => _localizedValues[locale.languageCode]!['ok']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get close => _localizedValues[locale.languageCode]!['close']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get success => _localizedValues[locale.languageCode]!['success']!;

  // Auth
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get register => _localizedValues[locale.languageCode]!['register']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get confirmPassword => _localizedValues[locale.languageCode]!['confirm_password']!;
  String get name => _localizedValues[locale.languageCode]!['name']!;
  String get phone => _localizedValues[locale.languageCode]!['phone']!;
  String get loginTitle => _localizedValues[locale.languageCode]!['login_title']!;
  String get loginSubtitle => _localizedValues[locale.languageCode]!['login_subtitle']!;
  String get registerTitle => _localizedValues[locale.languageCode]!['register_title']!;
  String get registerSubtitle => _localizedValues[locale.languageCode]!['register_subtitle']!;
  String get forgotPassword => _localizedValues[locale.languageCode]!['forgot_password']!;
  String get dontHaveAccount => _localizedValues[locale.languageCode]!['dont_have_account']!;
  String get alreadyHaveAccount => _localizedValues[locale.languageCode]!['already_have_account']!;

  // Dashboard
  String get dashboard => _localizedValues[locale.languageCode]!['dashboard']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get visitHistory => _localizedValues[locale.languageCode]!['visit_history']!;
  String get startNewVisit => _localizedValues[locale.languageCode]!['start_new_visit']!;
  String get visitInProgress => _localizedValues[locale.languageCode]!['visit_in_progress']!;
  String get active => _localizedValues[locale.languageCode]!['active']!;
  String get endVisit => _localizedValues[locale.languageCode]!['end_visit']!;
  String get serviceReport => _localizedValues[locale.languageCode]!['service_report']!;
  String get reportAdded => _localizedValues[locale.languageCode]!['report_added']!;

  // Visit
  String get customer => _localizedValues[locale.languageCode]!['customer']!;
  String get project => _localizedValues[locale.languageCode]!['project']!;
  String get selectCustomer => _localizedValues[locale.languageCode]!['select_customer']!;
  String get selectProject => _localizedValues[locale.languageCode]!['select_project']!;
  String get searchCustomers => _localizedValues[locale.languageCode]!['search_customers']!;
  String get searchProjects => _localizedValues[locale.languageCode]!['search_projects']!;
  String get startVisit => _localizedValues[locale.languageCode]!['start_visit']!;
  String get visitDetails => _localizedValues[locale.languageCode]!['visit_details']!;
  String get viewDetails => _localizedValues[locale.languageCode]!['view_details']!;
  String get openReport => _localizedValues[locale.languageCode]!['open_report']!;
  String get addReport => _localizedValues[locale.languageCode]!['add_report']!;
  String get viewReport => _localizedValues[locale.languageCode]!['view_report']!;

  // Visit Details
  String get started => _localizedValues[locale.languageCode]!['started']!;
  String get date => _localizedValues[locale.languageCode]!['date']!;
  String get startTime => _localizedValues[locale.languageCode]!['start_time']!;
  String get endTime => _localizedValues[locale.languageCode]!['end_time']!;
  String get duration => _localizedValues[locale.languageCode]!['duration']!;
  String get visitId => _localizedValues[locale.languageCode]!['visit_id']!;
  String get supervisor => _localizedValues[locale.languageCode]!['supervisor']!;
  String get teamMembers => _localizedValues[locale.languageCode]!['team_members']!;
  String get notAssigned => _localizedValues[locale.languageCode]!['not_assigned']!;

  // Service Report
  String get pestControl => _localizedValues[locale.languageCode]!['pest_control']!;
  String get chemicals => _localizedValues[locale.languageCode]!['chemicals']!;
  String get controlledPests => _localizedValues[locale.languageCode]!['controlled_pests']!;
  String get chemicalsUsed => _localizedValues[locale.languageCode]!['chemicals_used']!;
  String get availablePests => _localizedValues[locale.languageCode]!['available_pests']!;
  String get dragDropPests => _localizedValues[locale.languageCode]!['drag_drop_pests']!;
  String get selectChemicals => _localizedValues[locale.languageCode]!['select_chemicals']!;
  String get quantity => _localizedValues[locale.languageCode]!['quantity']!;
  String get submitReport => _localizedValues[locale.languageCode]!['submit_report']!;
  String get reportSubmitted => _localizedValues[locale.languageCode]!['report_submitted']!;
  String get dropPestsHere => _localizedValues[locale.languageCode]!['drop_pests_here']!;
  String get noPestsControlled => _localizedValues[locale.languageCode]!['no_pests_controlled']!;
  String get noChemicalsUsed => _localizedValues[locale.languageCode]!['no_chemicals_used']!;
  String get reportInformation => _localizedValues[locale.languageCode]!['report_information']!;
  String get reportId => _localizedValues[locale.languageCode]!['report_id']!;
  String get status => _localizedValues[locale.languageCode]!['status']!;
  String get completed => _localizedValues[locale.languageCode]!['completed']!;
  String get noServiceReport => _localizedValues[locale.languageCode]!['no_service_report']!;

  // Team Selection
  String get selectTeamMembers => _localizedValues[locale.languageCode]!['select_team_members']!;
  String get selectAtLeastOne => _localizedValues[locale.languageCode]!['select_at_least_one']!;
  String get saveContinue => _localizedValues[locale.languageCode]!['save_continue']!;
  String get noTeamMembers => _localizedValues[locale.languageCode]!['no_team_members']!;

  // Profile
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get selectLanguage => _localizedValues[locale.languageCode]!['select_language']!;
  String get english => _localizedValues[locale.languageCode]!['english']!;
  String get arabic => _localizedValues[locale.languageCode]!['arabic']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get logoutConfirm => _localizedValues[locale.languageCode]!['logout_confirm']!;

  // Messages
  String get visitStarted => _localizedValues[locale.languageCode]!['visit_started']!;
  String get visitEnded => _localizedValues[locale.languageCode]!['visit_ended']!;
  String get selectTeamMembersMsg => _localizedValues[locale.languageCode]!['select_team_members_msg']!;
  String get endVisitConfirm => _localizedValues[locale.languageCode]!['end_visit_confirm']!;
  String get languageChanged => _localizedValues[locale.languageCode]!['language_changed']!;

  // Localized Values
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'Pest Control Manager',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'close': 'Close',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',

      // Auth
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'name': 'Name',
      'phone': 'Phone',
      'login_title': 'Welcome Back',
      'login_subtitle': 'Sign in to continue',
      'register_title': 'Create Account',
      'register_subtitle': 'Sign up to get started',
      'forgot_password': 'Forgot Password?',
      'dont_have_account': "Don't have an account?",
      'already_have_account': 'Already have an account?',

      // Dashboard
      'dashboard': 'Dashboard',
      'profile': 'Profile',
      'visit_history': 'Visit History',
      'start_new_visit': 'Start New Visit',
      'visit_in_progress': 'Visit In Progress',
      'active': 'ACTIVE',
      'end_visit': 'End Visit',
      'service_report': 'Service Report',
      'report_added': 'Report Added',

      // Visit
      'customer': 'Customer',
      'project': 'Project',
      'select_customer': 'Select Customer',
      'select_project': 'Select Project',
      'search_customers': 'Search customers...',
      'search_projects': 'Search projects...',
      'start_visit': 'Start Visit',
      'visit_details': 'Visit Details',
      'view_details': 'View Details',
      'open_report': 'Open Report',
      'add_report': 'Add Report',
      'view_report': 'View Report',

      // Visit Details
      'started': 'Started',
      'date': 'Date',
      'start_time': 'Start Time',
      'end_time': 'End Time',
      'duration': 'Duration',
      'visit_id': 'Visit ID',
      'supervisor': 'Supervisor',
      'team_members': 'Team Members',
      'not_assigned': 'Not assigned',

      // Service Report
      'pest_control': 'Pest Control',
      'chemicals': 'Chemicals',
      'controlled_pests': 'Controlled Pests',
      'chemicals_used': 'Chemicals Used',
      'available_pests': 'Available Pests',
      'drag_drop_pests': 'Drag & drop pests into the controlled container',
      'select_chemicals': 'Select chemicals used and enter quantities',
      'quantity': 'Quantity',
      'submit_report': 'Submit Service Report',
      'report_submitted': 'Service report submitted successfully',
      'drop_pests_here': 'Drop pests here',
      'no_pests_controlled': 'No pests were controlled during this visit',
      'no_chemicals_used': 'No chemicals were used during this visit',
      'report_information': 'Report Information',
      'report_id': 'Report ID',
      'status': 'Status',
      'completed': 'Completed',
      'no_service_report': 'No Service Report',

      // Team Selection
      'select_team_members': 'Select Team Members',
      'select_at_least_one': 'Please select at least one team member',
      'save_continue': 'Save & Continue',
      'no_team_members': 'No team members available',

      // Profile
      'language': 'Language',
      'select_language': 'Select Language',
      'english': 'English',
      'arabic': 'Arabic',
      'logout': 'Logout',
      'logout_confirm': 'Are you sure you want to logout?',

      // Messages
      'visit_started': 'Visit started successfully!',
      'visit_ended': 'Visit ended successfully! Please select team members.',
      'select_team_members_msg': 'Select team members who participated',
      'end_visit_confirm': 'Are you sure you want to end this visit?\n\nYou will be asked to select team members who participated.',
      'language_changed': 'Language changed successfully',
    },
    'ar': {
      'app_name': 'مدير مكافحة الآفات',
      'yes': 'نعم',
      'no': 'لا',
      'ok': 'موافق',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'close': 'إغلاق',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'success': 'نجح',

      // Auth
      'login': 'تسجيل الدخول',
      'register': 'التسجيل',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'name': 'الاسم',
      'phone': 'الهاتف',
      'login_title': 'مرحباً بعودتك',
      'login_subtitle': 'سجل الدخول للمتابعة',
      'register_title': 'إنشاء حساب',
      'register_subtitle': 'سجل للبدء',
      'forgot_password': 'نسيت كلمة المرور؟',
      'dont_have_account': 'ليس لديك حساب؟',
      'already_have_account': 'لديك حساب بالفعل؟',

      // Dashboard
      'dashboard': 'لوحة التحكم',
      'profile': 'الملف الشخصي',
      'visit_history': 'سجل الزيارات',
      'start_new_visit': 'بدء زيارة جديدة',
      'visit_in_progress': 'زيارة قيد التنفيذ',
      'active': 'نشط',
      'end_visit': 'إنهاء الزيارة',
      'service_report': 'تقرير الخدمة',
      'report_added': 'تم إضافة التقرير',

      // Visit
      'customer': 'العميل',
      'project': 'المشروع',
      'select_customer': 'اختر العميل',
      'select_project': 'اختر المشروع',
      'search_customers': 'البحث عن العملاء...',
      'search_projects': 'البحث عن المشاريع...',
      'start_visit': 'بدء الزيارة',
      'visit_details': 'تفاصيل الزيارة',
      'view_details': 'عرض التفاصيل',
      'open_report': 'فتح التقرير',
      'add_report': 'إضافة تقرير',
      'view_report': 'عرض التقرير',

      // Visit Details
      'started': 'بدأت',
      'date': 'التاريخ',
      'start_time': 'وقت البدء',
      'end_time': 'وقت الانتهاء',
      'duration': 'المدة',
      'visit_id': 'رقم الزيارة',
      'supervisor': 'المشرف',
      'team_members': 'أعضاء الفريق',
      'not_assigned': 'غير محدد',

      // Service Report
      'pest_control': 'مكافحة الآفات',
      'chemicals': 'المواد الكيميائية',
      'controlled_pests': 'الآفات المكافحة',
      'chemicals_used': 'المواد الكيميائية المستخدمة',
      'available_pests': 'الآفات المتاحة',
      'drag_drop_pests': 'اسحب وأفلت الآفات في الحاوية المكافحة',
      'select_chemicals': 'حدد المواد الكيميائية المستخدمة وأدخل الكميات',
      'quantity': 'الكمية',
      'submit_report': 'إرسال تقرير الخدمة',
      'report_submitted': 'تم إرسال تقرير الخدمة بنجاح',
      'drop_pests_here': 'أفلت الآفات هنا',
      'no_pests_controlled': 'لم يتم مكافحة أي آفات خلال هذه الزيارة',
      'no_chemicals_used': 'لم يتم استخدام أي مواد كيميائية خلال هذه الزيارة',
      'report_information': 'معلومات التقرير',
      'report_id': 'رقم التقرير',
      'status': 'الحالة',
      'completed': 'مكتمل',
      'no_service_report': 'لا يوجد تقرير خدمة',

      // Team Selection
      'select_team_members': 'اختر أعضاء الفريق',
      'select_at_least_one': 'يرجى اختيار عضو واحد على الأقل',
      'save_continue': 'حفظ ومتابعة',
      'no_team_members': 'لا يوجد أعضاء فريق متاحين',

      // Profile
      'language': 'اللغة',
      'select_language': 'اختر اللغة',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
      'logout': 'تسجيل الخروج',
      'logout_confirm': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',

      // Messages
      'visit_started': 'تم بدء الزيارة بنجاح!',
      'visit_ended': 'تم إنهاء الزيارة بنجاح! يرجى اختيار أعضاء الفريق.',
      'select_team_members_msg': 'اختر أعضاء الفريق الذين شاركوا',
      'end_visit_confirm': 'هل أنت متأكد أنك تريد إنهاء هذه الزيارة؟\n\nسيُطلب منك اختيار أعضاء الفريق الذين شاركوا.',
      'language_changed': 'تم تغيير اللغة بنجاح',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

