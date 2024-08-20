import 'package:flutter/cupertino.dart';

class WidgetKeys {
  // Auth screen
  static const authEmailKey = Key('auth_email');
  static const authPasswordKey = Key('auth_password');
  static const authSignInKey = Key('auth_sign_in');
  static const authForgotPasswordKey = Key('auth_forgot_password');
  static const authSwitchModeKey = Key('auth_switch_mode');
  static const authSignInWithFbKey = Key('auth_sign_in_with_fb');
  static const authSignInWithGoogleKey = Key('auth_sign_in_with_google');
  static const dialogOkButton = Key('dialog_ok_button');

  // Create or Update expenses screen
  static const addExpensesNameKey = Key('add_expenses_name');
  static const addExpensesAmountKey = Key('add_expenses_amount');
  static const addExpensesSaveKey = Key('add_expenses_save');
  static const addExpensesSelectDateKey = Key('add_expenses_select_date');

  // Edit profile screen
  static const editProfileUsernameKey = Key('edit_profile_username');
  static const editProfileSaveKey = Key('edit_profile_save');

  // Expenses list screen
  static const expensesItemMenuEditKey = Key('expenses_item_menu_edit');
  static const expensesItemMenuCancelKey = Key('expenses_item_menu_cancel');

  // Settings screen
  static const settingsLogoutButtonKey = Key('settings_logout_button');
  static const settingsDeleteAccountButtonKey =
      Key('settings_delete_account_button');

  //Forgot password
  static const forgotPasswordEmailKey = Key('forgot_password_email');
  static const forgotPasswordResetKey = Key('forgot_password_reset');
}
