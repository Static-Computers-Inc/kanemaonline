# Diff Details

Date : 2024-05-23 10:21:55

Directory /Users/kanema/Documents/Kanema/projects/kanemaonline/lib

Total : 61 files,  3354 codes, 21 comments, 298 blanks, all 3673 lines

[Summary](results.md) / [Details](details.md) / [Diff Summary](diff.md) / Diff Details

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [lib/api/auth_api.dart](/lib/api/auth_api.dart) | Dart | 52 | 5 | 4 | 61 |
| [lib/api/ip_lookup_api.dart](/lib/api/ip_lookup_api.dart) | Dart | 5 | 0 | 1 | 6 |
| [lib/api/mylist_api.dart](/lib/api/mylist_api.dart) | Dart | 85 | 6 | 11 | 102 |
| [lib/api/packages_api.dart](/lib/api/packages_api.dart) | Dart | 47 | 0 | 7 | 54 |
| [lib/api/payment_api.dart](/lib/api/payment_api.dart) | Dart | 202 | 3 | 27 | 232 |
| [lib/api/trending_api.dart](/lib/api/trending_api.dart) | Dart | 26 | 0 | 4 | 30 |
| [lib/api/users_api.dart](/lib/api/users_api.dart) | Dart | 33 | 0 | 7 | 40 |
| [lib/data/trends.dart](/lib/data/trends.dart) | Dart | -1,278 | 0 | -1 | -1,279 |
| [lib/helpers/constants/colors.dart](/lib/helpers/constants/colors.dart) | Dart | 2 | 0 | 1 | 3 |
| [lib/helpers/constants/values.dart](/lib/helpers/constants/values.dart) | Dart | 3 | 0 | 1 | 4 |
| [lib/helpers/fx/providers_init.dart](/lib/helpers/fx/providers_init.dart) | Dart | 20 | 0 | 4 | 24 |
| [lib/helpers/fx/url_launcher.dart](/lib/helpers/fx/url_launcher.dart) | Dart | 16 | 0 | 3 | 19 |
| [lib/helpers/fx/watch_bridge_functions.dart](/lib/helpers/fx/watch_bridge_functions.dart) | Dart | 104 | 3 | 14 | 121 |
| [lib/main.dart](/lib/main.dart) | Dart | 41 | 0 | 2 | 43 |
| [lib/providers/auth_provider.dart](/lib/providers/auth_provider.dart) | Dart | 9 | 1 | 0 | 10 |
| [lib/providers/my_list_provider.dart](/lib/providers/my_list_provider.dart) | Dart | 73 | 5 | 19 | 97 |
| [lib/providers/navigation_bar_provider.dart](/lib/providers/navigation_bar_provider.dart) | Dart | 9 | 0 | 3 | 12 |
| [lib/providers/packages_provider.dart](/lib/providers/packages_provider.dart) | Dart | 15 | 0 | 6 | 21 |
| [lib/providers/trending_provider.dart](/lib/providers/trending_provider.dart) | Dart | 15 | 0 | 4 | 19 |
| [lib/providers/tvs_provider.dart](/lib/providers/tvs_provider.dart) | Dart | -1 | 0 | 0 | -1 |
| [lib/providers/user_info_provider.dart](/lib/providers/user_info_provider.dart) | Dart | 62 | 1 | 15 | 78 |
| [lib/screens/auth/login_black_screens.dart](/lib/screens/auth/login_black_screens.dart) | Dart | 12 | 0 | 4 | 16 |
| [lib/screens/auth/otp_verify_screen.dart](/lib/screens/auth/otp_verify_screen.dart) | Dart | 21 | 0 | 4 | 25 |
| [lib/screens/auth/register.dart](/lib/screens/auth/register.dart) | Dart | 17 | 1 | 0 | 18 |
| [lib/screens/browser/browser_screen.dart](/lib/screens/browser/browser_screen.dart) | Dart | 71 | 3 | 8 | 82 |
| [lib/screens/generics/choose_country_popup.dart](/lib/screens/generics/choose_country_popup.dart) | Dart | 4 | 0 | 0 | 4 |
| [lib/screens/generics/receipt_screenshot.dart](/lib/screens/generics/receipt_screenshot.dart) | Dart | 184 | 2 | 12 | 198 |
| [lib/screens/home/homescreen.dart](/lib/screens/home/homescreen.dart) | Dart | 275 | -1 | 1 | 275 |
| [lib/screens/live_events/all_events_search_screen.dart](/lib/screens/live_events/all_events_search_screen.dart) | Dart | 68 | 0 | 5 | 73 |
| [lib/screens/live_events/live_events_screens.dart](/lib/screens/live_events/live_events_screens.dart) | Dart | 74 | 0 | 2 | 76 |
| [lib/screens/livetv/all_tvs_search_screen.dart](/lib/screens/livetv/all_tvs_search_screen.dart) | Dart | 138 | 0 | 9 | 147 |
| [lib/screens/livetv/livetv_screen.dart](/lib/screens/livetv/livetv_screen.dart) | Dart | 21 | 0 | 0 | 21 |
| [lib/screens/payments/single_item_sub.dart](/lib/screens/payments/single_item_sub.dart) | Dart | 227 | 1 | 7 | 235 |
| [lib/screens/players/live_tvs_player.dart](/lib/screens/players/live_tvs_player.dart) | Dart | 14 | 4 | 3 | 21 |
| [lib/screens/players/video_player.dart](/lib/screens/players/video_player.dart) | Dart | 0 | 0 | 1 | 1 |
| [lib/screens/profile/profile_screen.dart](/lib/screens/profile/profile_screen.dart) | Dart | 49 | 1 | 3 | 53 |
| [lib/screens/profile_screens/account/account_screen.dart](/lib/screens/profile_screens/account/account_screen.dart) | Dart | 103 | 0 | 2 | 105 |
| [lib/screens/profile_screens/account/edit_profile_screen.dart](/lib/screens/profile_screens/account/edit_profile_screen.dart) | Dart | 14 | 0 | 4 | 18 |
| [lib/screens/profile_screens/help/app_info_screen.dart](/lib/screens/profile_screens/help/app_info_screen.dart) | Dart | 67 | 0 | 7 | 74 |
| [lib/screens/profile_screens/help/help_screen.dart](/lib/screens/profile_screens/help/help_screen.dart) | Dart | 46 | 9 | 0 | 55 |
| [lib/screens/profile_screens/subscriptions/payment_gateway_screen.dart](/lib/screens/profile_screens/subscriptions/payment_gateway_screen.dart) | Dart | 778 | 2 | 27 | 807 |
| [lib/screens/profile_screens/subscriptions/select_package_screen.dart](/lib/screens/profile_screens/subscriptions/select_package_screen.dart) | Dart | 202 | 0 | 8 | 210 |
| [lib/screens/profile_screens/subscriptions/subscription_cofirm_page.dart](/lib/screens/profile_screens/subscriptions/subscription_cofirm_page.dart) | Dart | 29 | 0 | 4 | 33 |
| [lib/screens/profile_screens/subscriptions/subscription_failed_screen.dart](/lib/screens/profile_screens/subscriptions/subscription_failed_screen.dart) | Dart | 16 | 0 | 4 | 20 |
| [lib/screens/profile_screens/subscriptions/subscription_pending_page.dart](/lib/screens/profile_screens/subscriptions/subscription_pending_page.dart) | Dart | 86 | 0 | 6 | 92 |
| [lib/screens/profile_screens/subscriptions/subscription_screen.dart](/lib/screens/profile_screens/subscriptions/subscription_screen.dart) | Dart | 160 | 0 | 4 | 164 |
| [lib/screens/root_app.dart](/lib/screens/root_app.dart) | Dart | 8 | 0 | 0 | 8 |
| [lib/screens/search/search_all_screen.dart](/lib/screens/search/search_all_screen.dart) | Dart | 201 | 0 | 9 | 210 |
| [lib/screens/tests_screen.dart](/lib/screens/tests_screen.dart) | Dart | 37 | 2 | 4 | 43 |
| [lib/screens/videos/all_videos_search_screen.dart](/lib/screens/videos/all_videos_search_screen.dart) | Dart | 24 | 0 | 0 | 24 |
| [lib/screens/videos/videos_screen.dart](/lib/screens/videos/videos_screen.dart) | Dart | 92 | -6 | 0 | 86 |
| [lib/services/auth_service.dart](/lib/services/auth_service.dart) | Dart | 7 | 0 | 1 | 8 |
| [lib/test_screens/payperview.dart](/lib/test_screens/payperview.dart) | Dart | 24 | 0 | 4 | 28 |
| [lib/widgets/activity_loading_widget.dart](/lib/widgets/activity_loading_widget.dart) | Dart | 26 | 0 | 3 | 29 |
| [lib/widgets/checking_payment_popup.dart](/lib/widgets/checking_payment_popup.dart) | Dart | 134 | 2 | 7 | 143 |
| [lib/widgets/hero_widget.dart](/lib/widgets/hero_widget.dart) | Dart | 45 | -7 | 3 | 41 |
| [lib/widgets/payment_failed_popup.dart](/lib/widgets/payment_failed_popup.dart) | Dart | 216 | 0 | 5 | 221 |
| [lib/widgets/payment_success_popup.dart](/lib/widgets/payment_success_popup.dart) | Dart | 207 | 0 | 4 | 211 |
| [lib/widgets/subscribe_popup.dart](/lib/widgets/subscribe_popup.dart) | Dart | 120 | 0 | 4 | 124 |
| [lib/widgets/trending_list_sm_widget.dart](/lib/widgets/trending_list_sm_widget.dart) | Dart | -1 | 0 | 0 | -1 |
| [lib/wrapper.dart](/lib/wrapper.dart) | Dart | -2 | -16 | -3 | -21 |

[Summary](results.md) / [Details](details.md) / [Diff Summary](diff.md) / Diff Details