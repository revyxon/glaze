import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import '../../providers/settings_provider.dart';
import '../../utils/app_enums.dart';

// Re-export enums for convenience
export '../../utils/app_enums.dart' show IconPack, AppIconType, FontFamily;

/// =============================================================================
/// PREMIUM ICON MAPPINGS - Best icons for each purpose
/// =============================================================================
/// Each pack uses its BEST variant:
/// - Material Symbols: Rounded style with balanced weight
/// - Lucide: Clean stroke icons (default style)
/// - Remix: FILL variants for solid premium look
/// - BoxIcons: SOLID (bxs_) variants
/// - HeroIcons: Solid style for navigation, outline for actions
/// - Phosphor: Bold weight for prominence
/// - Eva: Filled variants
/// - Tabler: Default (stroke-based, unique)
/// - Fluent: Filled variants for modern look
/// - Cupertino: Native iOS style
/// =============================================================================
class _IconMappings {
  // ═══════════════════════════════════════════════════════════════════════════
  // 1. MATERIAL SYMBOLS (Google) - Rounded, Modern, Balanced
  // ═══════════════════════════════════════════════════════════════════════════
  static final Map<AppIconType, IconData> materialSymbols = {
    // Navigation - Distinctive & Clear
    AppIconType.home: Symbols.home_rounded,
    AppIconType.enquiry: Symbols.request_quote_rounded,
    AppIconType.agreement: Symbols.handshake_rounded,
    AppIconType.settings: Symbols.settings_rounded, // Gear
    // Actions - Bold & Recognizable
    AppIconType.add: Symbols.add_rounded, // Simple plus
    AppIconType.remove: Symbols.remove_rounded, // Simple minus
    AppIconType.edit: Symbols.edit_rounded,
    AppIconType.delete: Symbols.delete_rounded,
    AppIconType.share: Symbols.share_rounded,
    AppIconType.print: Symbols.print_rounded,
    AppIconType.sync: Symbols.sync_rounded,
    AppIconType.refresh: Symbols.refresh_rounded,
    AppIconType.search: Symbols.search_rounded,
    AppIconType.copy: Symbols.content_copy_rounded,
    AppIconType.close: Symbols.close_rounded,
    AppIconType.back: Symbols.arrow_back_rounded,
    AppIconType.arrowRight: Symbols.arrow_forward_rounded,
    AppIconType.more: Symbols.more_vert_rounded,
    AppIconType.check: Symbols.check_rounded,
    AppIconType.play: Symbols.play_arrow_rounded,
    AppIconType.pause: Symbols.pause_rounded,
    AppIconType.sun: Symbols.light_mode_rounded,
    AppIconType.moon: Symbols.dark_mode_rounded,

    // Content - Domain-Specific
    AppIconType.customer: Symbols.person_rounded,
    AppIconType.window: Symbols.window_rounded, // Glass window
    AppIconType.measurement: Symbols.straighten_rounded, // Ruler
    AppIconType.measure: Symbols.straighten_rounded, // Same as measurement
    AppIconType.surface: Symbols.crop_square_rounded, // Surface area
    AppIconType.glass: Symbols.blur_on_rounded, // Glass/transparency effect
    AppIconType.calculator: Symbols.calculate_rounded,
    AppIconType.calendar: Symbols.calendar_month_rounded,
    AppIconType.location: Symbols.pin_drop_rounded,
    AppIconType.phone: Symbols.call_rounded,
    AppIconType.notification: Symbols.notifications_active_rounded,

    // Settings - Configuration Icons
    AppIconType.theme: Symbols.contrast_rounded,
    AppIconType.palette: Symbols.palette_rounded,
    AppIconType.textSize: Symbols.format_size_rounded,
    AppIconType.font: Symbols.font_download_rounded,
    AppIconType.icons: Symbols.interests_rounded,
    AppIconType.database: Symbols.database_rounded,
    AppIconType.upload: Symbols.cloud_upload_rounded,
    AppIconType.download: Symbols.cloud_download_rounded,
    AppIconType.info: Symbols.info_rounded,
    AppIconType.code: Symbols.code_rounded,
    AppIconType.device: Symbols.phone_android_rounded,
    AppIconType.rocket: Symbols.rocket_launch_rounded,
    AppIconType.premium: Symbols.workspace_premium_rounded,

    // Misc - Status & Utility
    AppIconType.warning: Symbols.warning_rounded,
    AppIconType.error: Symbols.error_rounded,
    AppIconType.success: Symbols.check_circle_rounded,
    AppIconType.folder: Symbols.folder_rounded,
    AppIconType.file: Symbols.description_rounded,
    AppIconType.sparkle: Symbols.auto_awesome_rounded,
    AppIconType.lock: Symbols.lock_rounded,
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. LUCIDE - Clean, Modern Stroke Icons
  // ═══════════════════════════════════════════════════════════════════════════
  static final Map<AppIconType, IconData> lucide = {
    // Navigation
    AppIconType.home: LucideIcons.home,
    AppIconType.enquiry: LucideIcons.fileQuestion,
    AppIconType.agreement: LucideIcons.fileCheck,
    AppIconType.settings: LucideIcons.settings, // Gear icon
    // Actions
    AppIconType.add: LucideIcons.plus, // Simple plus
    AppIconType.remove: LucideIcons.minus, // Simple minus
    AppIconType.edit: LucideIcons.pencil,
    AppIconType.delete: LucideIcons.trash2,
    AppIconType.share: LucideIcons.share2,
    AppIconType.print: LucideIcons.printer,
    AppIconType.sync: LucideIcons.refreshCw,
    AppIconType.refresh: LucideIcons.rotateCw,
    AppIconType.search: LucideIcons.search,
    AppIconType.copy: LucideIcons.copy,
    AppIconType.close: LucideIcons.x,
    AppIconType.back: LucideIcons.chevronLeft,
    AppIconType.arrowRight: LucideIcons.chevronRight,
    AppIconType.more: LucideIcons.moreVertical,
    AppIconType.check: LucideIcons.checkCircle2,
    AppIconType.play: LucideIcons.playCircle,
    AppIconType.pause: LucideIcons.pauseCircle,
    AppIconType.sun: LucideIcons.sun,
    AppIconType.moon: LucideIcons.moon,

    // Content
    AppIconType.customer: LucideIcons.userCircle2,
    AppIconType.window: LucideIcons.panelTop, // Window panel
    AppIconType.measurement: LucideIcons.ruler,
    AppIconType.measure: LucideIcons.ruler,
    AppIconType.surface: LucideIcons.square,
    AppIconType.glass: LucideIcons.diamond,
    AppIconType.calculator: LucideIcons.calculator,
    AppIconType.calendar: LucideIcons.calendarDays,
    AppIconType.location: LucideIcons.mapPin,
    AppIconType.phone: LucideIcons.phone,
    AppIconType.notification: LucideIcons.bellRing,

    // Settings
    AppIconType.theme: LucideIcons.sunMoon,
    AppIconType.palette: LucideIcons.palette,
    AppIconType.textSize: LucideIcons.type,
    AppIconType.font: LucideIcons.type,
    AppIconType.icons: LucideIcons.shapes,
    AppIconType.database: LucideIcons.database,
    AppIconType.upload: LucideIcons.uploadCloud,
    AppIconType.download: LucideIcons.downloadCloud,
    AppIconType.info: LucideIcons.info,
    AppIconType.code: LucideIcons.code2,
    AppIconType.device: LucideIcons.smartphone,
    AppIconType.rocket: LucideIcons.rocket,
    AppIconType.premium: LucideIcons.crown,

    // Misc
    AppIconType.warning: LucideIcons.alertTriangle,
    AppIconType.error: LucideIcons.alertCircle,
    AppIconType.success: LucideIcons.checkCircle,
    AppIconType.folder: LucideIcons.folderOpen,
    AppIconType.file: LucideIcons.fileText,
    AppIconType.sparkle: LucideIcons.sparkles,
    AppIconType.lock: LucideIcons.lock,
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. REMIX - FILL Variants for Premium Solid Look
  // ═══════════════════════════════════════════════════════════════════════════
  static final Map<AppIconType, IconData> remix = {
    // Navigation
    AppIconType.home: Remix.home_5_fill,
    AppIconType.enquiry: Remix.questionnaire_fill,
    AppIconType.agreement: Remix.hand_heart_fill,
    AppIconType.settings: Remix.settings_3_fill, // Gear icon
    // Actions
    AppIconType.add: Remix.add_line, // Simple plus
    AppIconType.remove: Remix.subtract_line, // Simple minus
    AppIconType.edit: Remix.edit_2_fill,
    AppIconType.delete: Remix.delete_bin_5_fill,
    AppIconType.share: Remix.share_forward_fill,
    AppIconType.print: Remix.printer_fill,
    AppIconType.sync: Remix.loop_left_fill,
    AppIconType.refresh: Remix.refresh_fill,
    AppIconType.search: Remix.search_2_fill,
    AppIconType.copy: Remix.file_copy_fill,
    AppIconType.close: Remix.close_circle_fill,
    AppIconType.back: Remix.arrow_left_s_fill,
    AppIconType.arrowRight: Remix.arrow_right_s_fill,
    AppIconType.more: Remix.more_2_fill,
    AppIconType.check: Remix.checkbox_circle_fill,
    AppIconType.play: Remix.play_circle_fill,
    AppIconType.pause: Remix.pause_circle_fill,
    AppIconType.sun: Remix.sun_fill,
    AppIconType.moon: Remix.moon_fill,

    // Content
    AppIconType.customer: Remix.user_4_fill,
    AppIconType.window: Remix.window_2_fill,
    AppIconType.measurement: Remix.ruler_fill,
    AppIconType.measure: Remix.ruler_fill,
    AppIconType.surface: Remix.shape_fill,
    AppIconType.glass: Remix.blur_off_fill,
    AppIconType.calculator: Remix.calculator_fill,
    AppIconType.calendar: Remix.calendar_2_fill,
    AppIconType.location: Remix.map_pin_2_fill,
    AppIconType.phone: Remix.phone_fill,
    AppIconType.notification: Remix.notification_4_fill,

    // Settings
    AppIconType.theme: Remix.contrast_2_fill,
    AppIconType.palette: Remix.palette_fill,
    AppIconType.textSize: Remix.font_size_2,
    AppIconType.font: Remix.font_color,
    AppIconType.icons: Remix.apps_2_fill,
    AppIconType.database: Remix.database_2_fill,
    AppIconType.upload: Remix.upload_cloud_2_fill,
    AppIconType.download: Remix.download_cloud_2_fill,
    AppIconType.info: Remix.information_fill,
    AppIconType.code: Remix.code_s_slash_fill,
    AppIconType.device: Remix.smartphone_fill,
    AppIconType.rocket: Remix.rocket_2_fill,
    AppIconType.premium: Remix.vip_crown_fill,

    // Misc
    AppIconType.warning: Remix.alarm_warning_fill,
    AppIconType.error: Remix.error_warning_fill,
    AppIconType.success: Remix.checkbox_circle_fill,
    AppIconType.folder: Remix.folder_5_fill,
    AppIconType.file: Remix.file_text_fill,
    AppIconType.sparkle: Remix.sparkling_2_fill,
    AppIconType.lock: Remix.lock_2_fill,
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // 4. BOXICONS - SOLID (bxs_) Variants for Bold Look
  // ═══════════════════════════════════════════════════════════════════════════
  static final Map<AppIconType, IconData> boxicons = {
    // Navigation
    AppIconType.home: Boxicons.bxs_home_circle,
    AppIconType.enquiry: Boxicons.bxs_help_circle,
    AppIconType.agreement: Boxicons.bxs_certification,
    AppIconType.settings: Boxicons.bxs_cog, // Gear icon
    // Actions
    AppIconType.add: Boxicons.bx_plus, // Simple plus
    AppIconType.remove: Boxicons.bx_minus, // Simple minus
    AppIconType.edit: Boxicons.bxs_edit,
    AppIconType.delete: Boxicons.bxs_trash_alt,
    AppIconType.share: Boxicons.bxs_share_alt,
    AppIconType.print: Boxicons.bx_printer,
    AppIconType.sync: Boxicons.bx_sync,
    AppIconType.refresh: Boxicons.bx_refresh,
    AppIconType.search: Boxicons.bx_search_alt_2,
    AppIconType.copy: Boxicons.bx_copy,
    AppIconType.close: Boxicons.bxs_x_circle,
    AppIconType.back: Boxicons.bxs_chevron_left,
    AppIconType.arrowRight: Boxicons.bxs_chevron_right,
    AppIconType.more: Boxicons.bx_dots_vertical_rounded,
    AppIconType.check: Boxicons.bxs_check_circle,
    AppIconType.play: Boxicons.bxs_right_arrow,
    AppIconType.pause: Boxicons.bx_pause,
    AppIconType.sun: Boxicons.bxs_sun,
    AppIconType.moon: Boxicons.bxs_moon,

    // Content
    AppIconType.customer: Boxicons.bxs_user_circle,
    AppIconType.window: Boxicons.bxs_window_alt,
    AppIconType.measurement: Boxicons.bx_ruler,
    AppIconType.measure: Boxicons.bx_ruler,
    AppIconType.surface: Boxicons.bxs_square_rounded,
    AppIconType.glass: Boxicons.bxs_droplet_half,
    AppIconType.calculator: Boxicons.bxs_calculator,
    AppIconType.calendar: Boxicons.bxs_calendar,
    AppIconType.location: Boxicons.bxs_map_pin,
    AppIconType.phone: Boxicons.bxs_phone,
    AppIconType.notification: Boxicons.bxs_bell_ring,

    // Settings
    AppIconType.theme: Boxicons.bxs_adjust_alt,
    AppIconType.palette: Boxicons.bxs_palette,
    AppIconType.textSize: Boxicons.bx_font_size,
    AppIconType.font: Boxicons.bx_font_family,
    AppIconType.icons: Boxicons.bxs_grid_alt,
    AppIconType.database: Boxicons.bxs_data,
    AppIconType.upload: Boxicons.bxs_cloud_upload,
    AppIconType.download: Boxicons.bxs_cloud_download,
    AppIconType.info: Boxicons.bxs_info_circle,
    AppIconType.code: Boxicons.bxs_terminal,
    AppIconType.device: Boxicons.bxs_devices,
    AppIconType.rocket: Boxicons.bxs_rocket,
    AppIconType.premium: Boxicons.bxs_crown,

    // Misc
    AppIconType.warning: Boxicons.bxs_error,
    AppIconType.error: Boxicons.bxs_error_circle,
    AppIconType.success: Boxicons.bxs_badge_check,
    AppIconType.folder: Boxicons.bxs_folder_open,
    AppIconType.file: Boxicons.bxs_file_doc,
    AppIconType.sparkle: Boxicons.bxs_magic_wand,
    AppIconType.lock: Boxicons.bxs_lock_alt,
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // 5. HEROICONS - Mixed Solid/Outline for Balance
  // ═══════════════════════════════════════════════════════════════════════════
  static final Map<AppIconType, dynamic> heroicons = {
    // Navigation - Solid for prominence
    AppIconType.home: HeroIcons.home,
    AppIconType.enquiry: HeroIcons.questionMarkCircle,
    AppIconType.agreement: HeroIcons.documentCheck,
    AppIconType.settings: HeroIcons.cog6Tooth,

    // Actions
    AppIconType.add: HeroIcons.plusCircle,
    AppIconType.remove: HeroIcons.minusCircle,
    AppIconType.edit: HeroIcons.pencilSquare,
    AppIconType.delete: HeroIcons.trash,
    AppIconType.share: HeroIcons.share,
    AppIconType.print: HeroIcons.printer,
    AppIconType.sync: HeroIcons.arrowPath,
    AppIconType.refresh: HeroIcons.arrowPathRoundedSquare,
    AppIconType.search: HeroIcons.magnifyingGlass,
    AppIconType.copy: HeroIcons.documentDuplicate,
    AppIconType.close: HeroIcons.xCircle,
    AppIconType.back: HeroIcons.chevronLeft,
    AppIconType.arrowRight: HeroIcons.chevronRight,
    AppIconType.more: HeroIcons.ellipsisVertical,
    AppIconType.check: HeroIcons.checkCircle,
    AppIconType.play: HeroIcons.playCircle,
    AppIconType.pause: HeroIcons.pauseCircle,
    AppIconType.sun: HeroIcons.sun,
    AppIconType.moon: HeroIcons.moon,

    // Content
    AppIconType.customer: HeroIcons.userCircle,
    AppIconType.window: HeroIcons.window,
    AppIconType.measurement: HeroIcons.scale,
    AppIconType.measure: HeroIcons.scale,
    AppIconType.surface: HeroIcons.square2Stack,
    AppIconType.glass: HeroIcons.beaker,
    AppIconType.calculator: HeroIcons.calculator,
    AppIconType.calendar: HeroIcons.calendarDays,
    AppIconType.location: HeroIcons.mapPin,
    AppIconType.phone: HeroIcons.phone,
    AppIconType.notification: HeroIcons.bellAlert,

    // Settings
    AppIconType.theme: HeroIcons.moon,
    AppIconType.palette: HeroIcons.swatch,
    AppIconType.textSize: HeroIcons.bars3BottomLeft,
    AppIconType.font: HeroIcons.language,
    AppIconType.icons: HeroIcons.squares2x2,
    AppIconType.database: HeroIcons.circleStack,
    AppIconType.upload: HeroIcons.cloudArrowUp,
    AppIconType.download: HeroIcons.cloudArrowDown,
    AppIconType.info: HeroIcons.informationCircle,
    AppIconType.code: HeroIcons.commandLine,
    AppIconType.device: HeroIcons.devicePhoneMobile,
    AppIconType.rocket: HeroIcons.rocketLaunch,
    AppIconType.premium: HeroIcons.star,

    // Misc
    AppIconType.warning: HeroIcons.exclamationTriangle,
    AppIconType.error: HeroIcons.exclamationCircle,
    AppIconType.success: HeroIcons.checkBadge,
    AppIconType.folder: HeroIcons.folderOpen,
    AppIconType.file: HeroIcons.documentText,
    AppIconType.sparkle: HeroIcons.sparkles,
    AppIconType.lock: HeroIcons.lockClosed,
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // 6. PHOSPHOR - Bold Weight for Prominence
  // ═══════════════════════════════════════════════════════════════════════════
  static final Map<AppIconType, dynamic> phosphor = {
    // Navigation
    AppIconType.home: PhosphorIcons.house,
    AppIconType.enquiry: PhosphorIcons.chatCenteredText,
    AppIconType.agreement: PhosphorIcons.handshake,
    AppIconType.settings: PhosphorIcons.gear,

    // Actions
    AppIconType.add: PhosphorIcons.plusCircle,
    AppIconType.remove: PhosphorIcons.minusCircle,
    AppIconType.edit: PhosphorIcons.pencilSimple,
    AppIconType.delete: PhosphorIcons.trash,
    AppIconType.share: PhosphorIcons.shareNetwork,
    AppIconType.print: PhosphorIcons.printer,
    AppIconType.sync: PhosphorIcons.arrowsClockwise,
    AppIconType.refresh: PhosphorIcons.arrowClockwise,
    AppIconType.search: PhosphorIcons.magnifyingGlass,
    AppIconType.copy: PhosphorIcons.copy,
    AppIconType.close: PhosphorIcons.xCircle,
    AppIconType.back: PhosphorIcons.caretCircleLeft,
    AppIconType.arrowRight: PhosphorIcons.caretCircleRight,
    AppIconType.more: PhosphorIcons.dotsThreeVertical,
    AppIconType.check: PhosphorIcons.checkCircle,
    AppIconType.play: PhosphorIcons.playCircle,
    AppIconType.pause: PhosphorIcons.pauseCircle,
    AppIconType.sun: PhosphorIcons.sun,
    AppIconType.moon: PhosphorIcons.moon,

    // Content
    AppIconType.customer: PhosphorIcons.userCircle,
    AppIconType.window: PhosphorIcons.squaresFour,
    AppIconType.measurement: PhosphorIcons.ruler,
    AppIconType.measure: PhosphorIcons.ruler,
    AppIconType.surface: PhosphorIcons.square,
    AppIconType.glass: PhosphorIcons.drop,
    AppIconType.calculator: PhosphorIcons.calculator,
    AppIconType.calendar: PhosphorIcons.calendar,
    AppIconType.location: PhosphorIcons.mapPin,
    AppIconType.phone: PhosphorIcons.phone,
    AppIconType.notification: PhosphorIcons.bellRinging,

    // Settings
    AppIconType.theme: PhosphorIcons.circleHalf,
    AppIconType.palette: PhosphorIcons.palette,
    AppIconType.textSize: PhosphorIcons.textT,
    AppIconType.font: PhosphorIcons.textAa,
    AppIconType.icons: PhosphorIcons.squaresFour,
    AppIconType.database: PhosphorIcons.database,
    AppIconType.upload: PhosphorIcons.cloudArrowUp,
    AppIconType.download: PhosphorIcons.cloudArrowDown,
    AppIconType.info: PhosphorIcons.info,
    AppIconType.code: PhosphorIcons.terminal,
    AppIconType.device: PhosphorIcons.deviceMobile,
    AppIconType.rocket: PhosphorIcons.rocketLaunch,
    AppIconType.premium: PhosphorIcons.crown,

    // Misc
    AppIconType.warning: PhosphorIcons.warning,
    AppIconType.error: PhosphorIcons.warningCircle,
    AppIconType.success: PhosphorIcons.sealCheck,
    AppIconType.folder: PhosphorIcons.folderOpen,
    AppIconType.file: PhosphorIcons.fileText,
    AppIconType.sparkle: PhosphorIcons.sparkle,
    AppIconType.lock: PhosphorIcons.lockKey,
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // 7. EVA - Filled Variants for iOS-like Feel
  // ═══════════════════════════════════════════════════════════════════════════
  static final Map<AppIconType, IconData> eva = {
    // Navigation
    AppIconType.home: EvaIcons.home,
    AppIconType.enquiry: EvaIcons.messageCircle,
    AppIconType.agreement: EvaIcons.checkmarkSquare2,
    AppIconType.settings: EvaIcons.settings2,

    // Actions
    AppIconType.add: EvaIcons.plusCircle,
    AppIconType.remove: EvaIcons.minusCircle,
    AppIconType.edit: EvaIcons.edit2,
    AppIconType.delete: EvaIcons.trash2,
    AppIconType.share: EvaIcons.share,
    AppIconType.print: EvaIcons.printer,
    AppIconType.sync: EvaIcons.refresh,
    AppIconType.refresh: EvaIcons.sync,
    AppIconType.search: EvaIcons.search,
    AppIconType.copy: EvaIcons.copyOutline,
    AppIconType.close: EvaIcons.closeCircle,
    AppIconType.back: EvaIcons.arrowIosBack,
    AppIconType.arrowRight: EvaIcons.arrowIosForward,
    AppIconType.more: EvaIcons.moreVertical,
    AppIconType.check: EvaIcons.checkmarkCircle2,
    AppIconType.play: EvaIcons.playCircle,
    AppIconType.pause: EvaIcons.pauseCircle,
    AppIconType.sun: EvaIcons.sun,
    AppIconType.moon: EvaIcons.moon,

    // Content
    AppIconType.customer: EvaIcons.person,
    AppIconType.window: EvaIcons.grid,
    AppIconType.measurement: EvaIcons.activity,
    AppIconType.measure: EvaIcons.activity,
    AppIconType.surface: EvaIcons.square,
    AppIconType.glass: EvaIcons.droplet,
    AppIconType.calculator: EvaIcons.hash,
    AppIconType.calendar: EvaIcons.calendar,
    AppIconType.location: EvaIcons.pin,
    AppIconType.phone: EvaIcons.phone,
    AppIconType.notification: EvaIcons.bell,

    // Settings
    AppIconType.theme: EvaIcons.colorPicker,
    AppIconType.palette: EvaIcons.colorPalette,
    AppIconType.textSize: EvaIcons.text,
    AppIconType.font: EvaIcons.text,
    AppIconType.icons: EvaIcons.grid,
    AppIconType.database: EvaIcons.hardDrive,
    AppIconType.upload: EvaIcons.cloudUpload,
    AppIconType.download: EvaIcons.cloudDownload,
    AppIconType.info: EvaIcons.info,
    AppIconType.code: EvaIcons.code,
    AppIconType.device: EvaIcons.smartphone,
    AppIconType.rocket: EvaIcons.navigation2,
    AppIconType.premium: EvaIcons.award,

    // Misc
    AppIconType.warning: EvaIcons.alertTriangle,
    AppIconType.error: EvaIcons.alertCircle,
    AppIconType.success: EvaIcons.checkmarkCircle2,
    AppIconType.folder: EvaIcons.folder,
    AppIconType.file: EvaIcons.fileText,
    AppIconType.sparkle: EvaIcons.star,
    AppIconType.lock: EvaIcons.lock,
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // 8. TABLER - Unique Stroke-Based Design
  // ═══════════════════════════════════════════════════════════════════════════
  static final Map<AppIconType, IconData> tabler = {
    // Navigation
    AppIconType.home: TablerIcons.home_2,
    AppIconType.enquiry: TablerIcons.message_question,
    AppIconType.agreement: TablerIcons.certificate,
    AppIconType.settings: TablerIcons.adjustments_horizontal,

    // Actions
    AppIconType.add: TablerIcons.circle_plus,
    AppIconType.remove: TablerIcons.circle_minus,
    AppIconType.edit: TablerIcons.edit,
    AppIconType.delete: TablerIcons.trash_x,
    AppIconType.share: TablerIcons.share_2,
    AppIconType.print: TablerIcons.printer,
    AppIconType.sync: TablerIcons.refresh,
    AppIconType.refresh: TablerIcons.rotate_clockwise,
    AppIconType.search: TablerIcons.search,
    AppIconType.copy: TablerIcons.copy,
    AppIconType.close: TablerIcons.x,
    AppIconType.back: TablerIcons.chevron_left,
    AppIconType.arrowRight: TablerIcons.chevron_right,
    AppIconType.more: TablerIcons.dots_vertical,
    AppIconType.check: TablerIcons.circle_check,
    AppIconType.play: TablerIcons.player_play,
    AppIconType.pause: TablerIcons.player_pause,
    AppIconType.sun: TablerIcons.sun,
    AppIconType.moon: TablerIcons.moon,

    // Content
    AppIconType.customer: TablerIcons.user_circle,
    AppIconType.window: TablerIcons.app_window,
    AppIconType.measurement: TablerIcons.ruler_2,
    AppIconType.measure: TablerIcons.ruler_2,
    AppIconType.surface: TablerIcons.square,
    AppIconType.glass: TablerIcons.droplet_half_2,
    AppIconType.calculator: TablerIcons.calculator,
    AppIconType.calendar: TablerIcons.calendar_event,
    AppIconType.location: TablerIcons.map_pin,
    AppIconType.phone: TablerIcons.phone,
    AppIconType.notification: TablerIcons.bell_ringing,

    // Settings
    AppIconType.theme: TablerIcons.contrast_2,
    AppIconType.palette: TablerIcons.palette,
    AppIconType.textSize: TablerIcons.text_resize,
    AppIconType.font: TablerIcons.typography,
    AppIconType.icons: TablerIcons.apps,
    AppIconType.database: TablerIcons.database,
    AppIconType.upload: TablerIcons.cloud_upload,
    AppIconType.download: TablerIcons.cloud_download,
    AppIconType.info: TablerIcons.info_circle,
    AppIconType.code: TablerIcons.terminal_2,
    AppIconType.device: TablerIcons.device_mobile,
    AppIconType.rocket: TablerIcons.rocket,
    AppIconType.premium: TablerIcons.crown,

    // Misc
    AppIconType.warning: TablerIcons.alert_triangle,
    AppIconType.error: TablerIcons.alert_circle,
    AppIconType.success: TablerIcons.rosette_discount_check,
    AppIconType.folder: TablerIcons.folder_open,
    AppIconType.file: TablerIcons.file_description,
    AppIconType.sparkle: TablerIcons.sparkles,
    AppIconType.lock: TablerIcons.lock,
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // 9. FLUENT - Modern Microsoft Design (Filled)
  // ═══════════════════════════════════════════════════════════════════════════
  static final Map<AppIconType, IconData> fluent = {
    // Navigation
    AppIconType.home: FluentIcons.home_24_filled,
    AppIconType.enquiry: FluentIcons.chat_help_24_filled,
    AppIconType.agreement: FluentIcons.handshake_24_filled,
    AppIconType.settings: FluentIcons.settings_24_filled,

    // Actions
    AppIconType.add: FluentIcons.add_circle_24_filled,
    AppIconType.remove: FluentIcons.subtract_circle_24_filled,
    AppIconType.edit: FluentIcons.edit_24_filled,
    AppIconType.delete: FluentIcons.delete_24_filled,
    AppIconType.share: FluentIcons.share_24_filled,
    AppIconType.print: FluentIcons.print_24_filled,
    AppIconType.sync: FluentIcons.arrow_sync_24_filled,
    AppIconType.refresh: FluentIcons.arrow_clockwise_24_filled,
    AppIconType.search: FluentIcons.search_24_filled,
    AppIconType.copy: FluentIcons.copy_24_filled,
    AppIconType.close: FluentIcons.dismiss_circle_24_filled,
    AppIconType.back: FluentIcons.arrow_left_24_filled,
    AppIconType.arrowRight: FluentIcons.arrow_right_24_filled,
    AppIconType.more: FluentIcons.more_vertical_24_filled,
    AppIconType.check: FluentIcons.checkmark_circle_24_filled,
    AppIconType.play: FluentIcons.play_24_filled,
    AppIconType.pause: FluentIcons.pause_24_filled,
    AppIconType.sun: FluentIcons.weather_sunny_24_filled,
    AppIconType.moon: FluentIcons.weather_moon_24_filled,

    // Content
    AppIconType.customer: FluentIcons.person_circle_24_filled,
    AppIconType.window: FluentIcons.window_24_filled,
    AppIconType.measurement: FluentIcons.ruler_24_filled,
    AppIconType.measure: FluentIcons.ruler_24_filled,
    AppIconType.surface: FluentIcons.square_24_filled,
    AppIconType.glass: FluentIcons.drop_24_filled,
    AppIconType.calculator: FluentIcons.calculator_24_filled,
    AppIconType.calendar: FluentIcons.calendar_24_filled,
    AppIconType.location: FluentIcons.location_24_filled,
    AppIconType.phone: FluentIcons.call_24_filled,
    AppIconType.notification: FluentIcons.alert_24_filled,

    // Settings
    AppIconType.theme: FluentIcons.dark_theme_24_filled,
    AppIconType.palette: FluentIcons.color_24_filled,
    AppIconType.textSize: FluentIcons.text_font_size_24_filled,
    AppIconType.font: FluentIcons.text_font_24_filled,
    AppIconType.icons: FluentIcons.grid_24_filled,
    AppIconType.database: FluentIcons.database_24_filled,
    AppIconType.upload: FluentIcons.arrow_upload_24_filled,
    AppIconType.download: FluentIcons.arrow_download_24_filled,
    AppIconType.info: FluentIcons.info_24_filled,
    AppIconType.code: FluentIcons.code_24_filled,
    AppIconType.device: FluentIcons.phone_24_filled,
    AppIconType.rocket: FluentIcons.rocket_24_filled,
    AppIconType.premium: FluentIcons.premium_24_filled,

    // Misc
    AppIconType.warning: FluentIcons.warning_24_filled,
    AppIconType.error: FluentIcons.error_circle_24_filled,
    AppIconType.success: FluentIcons.checkmark_circle_24_filled,
    AppIconType.folder: FluentIcons.folder_24_filled,
    AppIconType.file: FluentIcons.document_24_filled,
    AppIconType.sparkle: FluentIcons.sparkle_24_filled,
    AppIconType.lock: FluentIcons.lock_closed_24_filled,
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // 10. CUPERTINO - Native iOS Style
  // ═══════════════════════════════════════════════════════════════════════════
  static final Map<AppIconType, IconData> cupertino = {
    // Navigation
    AppIconType.home: CupertinoIcons.house_fill,
    AppIconType.enquiry: CupertinoIcons.chat_bubble_text_fill,
    AppIconType.agreement: CupertinoIcons.doc_checkmark_fill,
    AppIconType.settings: CupertinoIcons.gear_alt_fill,

    // Actions
    AppIconType.add: CupertinoIcons.plus_circle_fill,
    AppIconType.remove: CupertinoIcons.minus_circle_fill,
    AppIconType.edit: CupertinoIcons.pencil_circle_fill,
    AppIconType.delete: CupertinoIcons.trash_fill,
    AppIconType.share: CupertinoIcons.share_up,
    AppIconType.print: CupertinoIcons.printer_fill,
    AppIconType.sync: CupertinoIcons.arrow_2_circlepath,
    AppIconType.refresh: CupertinoIcons.arrow_clockwise,
    AppIconType.search: CupertinoIcons.search,
    AppIconType.copy: CupertinoIcons.doc_on_doc_fill,
    AppIconType.close: CupertinoIcons.xmark_circle_fill,
    AppIconType.back: CupertinoIcons.chevron_left,
    AppIconType.arrowRight: CupertinoIcons.chevron_right,
    AppIconType.more: CupertinoIcons.ellipsis_vertical,
    AppIconType.check: CupertinoIcons.checkmark_circle_fill,
    AppIconType.play: CupertinoIcons.play_circle_fill,
    AppIconType.pause: CupertinoIcons.pause_circle_fill,
    AppIconType.sun: CupertinoIcons.sun_max_fill,
    AppIconType.moon: CupertinoIcons.moon_fill,

    // Content
    AppIconType.customer: CupertinoIcons.person_circle_fill,
    AppIconType.window: CupertinoIcons.rectangle_grid_1x2_fill,
    AppIconType.measurement: CupertinoIcons.slider_horizontal_3,
    AppIconType.measure: CupertinoIcons.slider_horizontal_3,
    AppIconType.surface: CupertinoIcons.square_fill,
    AppIconType.glass: CupertinoIcons.drop_fill,
    AppIconType.calculator: CupertinoIcons.plus_slash_minus,
    AppIconType.calendar: CupertinoIcons.calendar_today,
    AppIconType.location: CupertinoIcons.location_fill,
    AppIconType.phone: CupertinoIcons.phone_fill,
    AppIconType.notification: CupertinoIcons.bell_fill,

    // Settings
    AppIconType.theme: CupertinoIcons.circle_lefthalf_fill,
    AppIconType.palette: CupertinoIcons.paintbrush_fill,
    AppIconType.textSize: CupertinoIcons.textformat_size,
    AppIconType.font: CupertinoIcons.textformat,
    AppIconType.icons: CupertinoIcons.square_grid_2x2_fill,
    AppIconType.database: CupertinoIcons.tray_full_fill,
    AppIconType.upload: CupertinoIcons.cloud_upload_fill,
    AppIconType.download: CupertinoIcons.cloud_download_fill,
    AppIconType.info: CupertinoIcons.info_circle_fill,
    AppIconType.code: CupertinoIcons.chevron_left_slash_chevron_right,
    AppIconType.device: CupertinoIcons.device_phone_portrait,
    AppIconType.rocket: CupertinoIcons.rocket_fill,
    AppIconType.premium: CupertinoIcons.star_fill,

    // Misc
    AppIconType.warning: CupertinoIcons.exclamationmark_triangle_fill,
    AppIconType.error: CupertinoIcons.exclamationmark_circle_fill,
    AppIconType.success: CupertinoIcons.checkmark_seal_fill,
    AppIconType.folder: CupertinoIcons.folder_fill,
    AppIconType.file: CupertinoIcons.doc_text_fill,
    AppIconType.sparkle: CupertinoIcons.sparkles,
    AppIconType.lock: CupertinoIcons.lock_fill,
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // GETTER - Returns the correct icon for pack
  // ═══════════════════════════════════════════════════════════════════════════
  static dynamic get(AppIconType type, IconPack pack) {
    switch (pack) {
      case IconPack.material:
        return materialSymbols[type] ?? Symbols.help_rounded;
      case IconPack.fluent:
        return fluent[type] ?? FluentIcons.question_24_regular;
      case IconPack.cupertino:
        return cupertino[type] ?? CupertinoIcons.question;
      case IconPack.phosphor:
        return phosphor[type] ?? PhosphorIcons.question;
      case IconPack.remix:
        return remix[type] ?? Remix.question_line;
      case IconPack.lucide:
        return lucide[type] ?? LucideIcons.helpCircle;
      case IconPack.tabler:
        return tabler[type] ?? TablerIcons.help;
      case IconPack.heroicons:
        return heroicons[type] ?? HeroIcons.questionMarkCircle;
      case IconPack.eva:
        return eva[type] ?? EvaIcons.questionMarkCircleOutline;
      case IconPack.boxicons:
        return boxicons[type] ?? Boxicons.bx_question_mark;
    }
  }
}

/// =============================================================================
/// UNIVERSAL APP ICON WIDGET
/// =============================================================================
class AppIcon extends StatelessWidget {
  final dynamic icon;
  final double? size;
  final Color? color;
  final IconPack? overridePack;

  const AppIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.overridePack,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final pack = overridePack ?? settings.iconPack;

    dynamic data;
    if (icon is AppIconType) {
      data = _IconMappings.get(icon, pack);
    } else {
      data = icon;
    }

    // Material Symbols - Custom weight/grade for premium
    if (pack == IconPack.material && data is IconData) {
      return Icon(
        data,
        size: size ?? 24,
        color: color,
        weight: 400,
        grade: 0,
        opticalSize: 24,
        fill: 0.0,
      );
    }

    // HeroIcons (Widget-based)
    if (data is HeroIcons) {
      return HeroIcon(
        data,
        size: size,
        color: color,
        style: HeroIconStyle.solid,
      );
    }

    // Phosphor Icons (Function-based - returns IconData)
    if (data is Function) {
      return Icon(data(PhosphorIconsStyle.fill), size: size, color: color);
    }

    // Default IconData
    if (data is IconData) {
      return Icon(data, size: size, color: color);
    }

    // Widget fallback
    if (data is Widget) {
      return SizedBox(width: size, height: size, child: data);
    }

    // Safety fallback
    return Icon(Icons.help_outline_rounded, size: size, color: color);
  }
}
