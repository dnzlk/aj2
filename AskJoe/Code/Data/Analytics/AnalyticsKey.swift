//
//  AnalyticsKey.swift
//  AskJoe
//
//  Created by Денис on 24.02.2023.
//

import Foundation

enum AnalyticsKey: String {

    // Onboarding
    case onboarding_skip
    case onboarding_lets_go

    // Main screen
    case main_settings_tap
    case main_see_all_history_tap
    case main_previous_chat_tap
    case main_prompt_tap
    case main_lets_start_tap

    // Feed
    case feed_started_loading
    case feed_loaded
    case feed_error_loading

    // History
    case history_delete_all_tap

    // Chat
    case chat_send_tap
    case chat_error
    case chat_prompt_tap
    case chat_share_message_tap
    case chat_copy_message_tap
    case chat_show_payment

    // Settings
    case settings_free_tries_tap // OLD

    // Payment
    case payment_show
    case payment_weekly_tap
    case payment_monthly_tap
    case payment_restore_tap
    case payment_close_tap
    case payment_start_tap
}


