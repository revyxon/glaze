import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:heroicons/heroicons.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../providers/settings_provider.dart';
import '../../utils/app_enums.dart';

// Re-export enums for convenience
export '../../utils/app_enums.dart' show IconPack, AppIconType, FontFamily;

/// Icon mappings for all 10+ packs
/// Uses dynamic types to support different icon libraries conventions
class _IconMappings {
  // 1. Material Symbols (Google)
  static final Map<AppIconType, IconData> materialSymbols = {
    AppIconType.home: Symbols.home_rounded,
    AppIconType.enquiry: Symbols.assignment_rounded,
    AppIconType.agreement: Symbols.handshake_rounded,
    AppIconType.settings: Symbols.settings_rounded,
    AppIconType.add: Symbols.add_rounded,
    AppIconType.remove: Symbols.remove_rounded,
    AppIconType.edit: Symbols.edit_rounded,
    AppIconType.delete: Symbols.delete_rounded,
    AppIconType.share: Symbols.share_rounded,
    AppIconType.print: Symbols.print_rounded,
    AppIconType.sync: Symbols.sync_rounded,
    AppIconType.search: Symbols.search_rounded,
    AppIconType.close: Symbols.close_rounded,
    AppIconType.back: Symbols.arrow_back_rounded,
    AppIconType.arrowRight: Symbols.arrow_forward_rounded,
    AppIconType.more: Symbols.more_vert_rounded,
    AppIconType.check: Symbols.check_rounded,
    AppIconType.play: Symbols.play_arrow_rounded,
    AppIconType.pause: Symbols.pause_rounded,
    AppIconType.customer: Symbols.person_rounded,
    AppIconType.window: Symbols.window_rounded,
    AppIconType.measurement: Symbols.straighten_rounded,
    AppIconType.calculator: Symbols.calculate_rounded,
    AppIconType.calendar: Symbols.calendar_today_rounded,
    AppIconType.location: Symbols.location_on_rounded,
    AppIconType.phone: Symbols.call_rounded,
    AppIconType.notification: Symbols.notifications_rounded,
    AppIconType.theme: Symbols.dark_mode_rounded,
    AppIconType.sun: Symbols.light_mode_rounded,
    AppIconType.moon: Symbols.dark_mode_rounded,
    AppIconType.palette: Symbols.palette_rounded,
    AppIconType.textSize: Symbols.text_fields_rounded,
    AppIconType.font: Symbols.font_download_rounded,
    AppIconType.icons: Symbols.apps_rounded,
    AppIconType.database: Symbols.storage_rounded,
    AppIconType.upload: Symbols.cloud_upload_rounded,
    AppIconType.download: Symbols.cloud_download_rounded,
    AppIconType.rocket: Symbols.rocket_launch_rounded,
    AppIconType.info: Symbols.info_rounded,
    AppIconType.code: Symbols.code_rounded,
    AppIconType.device: Symbols.smartphone_rounded,
    AppIconType.warning: Symbols.warning_rounded,
    AppIconType.error: Symbols.error_rounded,
    AppIconType.success: Symbols.check_circle_rounded,
    AppIconType.folder: Symbols.folder_rounded,
    AppIconType.file: Symbols.description_rounded,
    AppIconType.sparkle: Symbols.auto_awesome_rounded,
    AppIconType.premium: Symbols.diamond_rounded,
    AppIconType.lock: Symbols.lock_rounded,
  };

  // 2. Lucide Icons
  static final Map<AppIconType, IconData> lucide = {
    AppIconType.home: LucideIcons.home,
    AppIconType.enquiry: LucideIcons.clipboardList,
    AppIconType.agreement: LucideIcons.fileSignature,
    AppIconType.settings: LucideIcons.settings,
    AppIconType.add: LucideIcons.plus,
    AppIconType.remove: LucideIcons.minus,
    AppIconType.edit: LucideIcons.pencil,
    AppIconType.delete: LucideIcons.trash2,
    AppIconType.share: LucideIcons.share2,
    AppIconType.print: LucideIcons.printer,
    AppIconType.sync: LucideIcons.refreshCw,
    AppIconType.search: LucideIcons.search,
    AppIconType.close: LucideIcons.x,
    AppIconType.back: LucideIcons.arrowLeft,
    AppIconType.arrowRight: LucideIcons.arrowRight,
    AppIconType.more: LucideIcons.moreVertical,
    AppIconType.check: LucideIcons.check,
    AppIconType.play: LucideIcons.play,
    AppIconType.pause: LucideIcons.pause,
    AppIconType.customer: LucideIcons.user,
    AppIconType.window: LucideIcons.appWindow,
    AppIconType.measurement: LucideIcons.ruler,
    AppIconType.calculator: LucideIcons.calculator,
    AppIconType.calendar: LucideIcons.calendar,
    AppIconType.location: LucideIcons.mapPin,
    AppIconType.phone: LucideIcons.phone,
    AppIconType.notification: LucideIcons.bell,
    AppIconType.theme: LucideIcons.moon,
    AppIconType.sun: LucideIcons.sun,
    AppIconType.moon: LucideIcons.moon,
    AppIconType.palette: LucideIcons.palette,
    AppIconType.textSize: LucideIcons.type,
    AppIconType.font: LucideIcons.caseSensitive,
    AppIconType.icons: LucideIcons.layoutGrid,
    AppIconType.database: LucideIcons.database,
    AppIconType.upload: LucideIcons.uploadCloud,
    AppIconType.download: LucideIcons.downloadCloud,
    AppIconType.rocket: LucideIcons.rocket,
    AppIconType.info: LucideIcons.info,
    AppIconType.code: LucideIcons.code2,
    AppIconType.device: LucideIcons.smartphone,
    AppIconType.warning: LucideIcons.alertTriangle,
    AppIconType.error: LucideIcons.alertCircle,
    AppIconType.success: LucideIcons.checkCircle2,
    AppIconType.folder: LucideIcons.folder,
    AppIconType.file: LucideIcons.fileText,
    AppIconType.sparkle: LucideIcons.sparkles,
    AppIconType.premium: LucideIcons.gem,
    AppIconType.lock: LucideIcons.lock,
  };

  // 3. HugeIcons - Uses HugeIconData (which indicates list path usually)
  // We use dynamic here to handle whatever HugeIcons returns
  static final Map<AppIconType, dynamic> huge = {
    AppIconType.home: HugeIcons.strokeRoundedHome01,
    AppIconType.enquiry: HugeIcons.strokeRoundedClipboard,
    AppIconType.agreement:
        HugeIcons.strokeRoundedFile02, // Changed from Contract01
    AppIconType.settings: HugeIcons.strokeRoundedSettings01,
    AppIconType.add: HugeIcons.strokeRoundedAdd01,
    AppIconType.remove: HugeIcons.strokeRoundedRemove01,
    AppIconType.edit: HugeIcons.strokeRoundedPencilEdit02,
    AppIconType.delete: HugeIcons.strokeRoundedDelete02,
    AppIconType.share: HugeIcons.strokeRoundedShare05,
    AppIconType.print: HugeIcons.strokeRoundedPrinter,
    AppIconType.sync: HugeIcons.strokeRoundedRefresh,
    AppIconType.search: HugeIcons.strokeRoundedSearch01,
    AppIconType.close: HugeIcons.strokeRoundedCancel01,
    AppIconType.back: HugeIcons.strokeRoundedArrowLeft01,
    AppIconType.arrowRight: HugeIcons.strokeRoundedArrowRight01,
    AppIconType.more: HugeIcons.strokeRoundedMoreVertical,
    AppIconType.check: HugeIcons.strokeRoundedTick01,
    AppIconType.play: HugeIcons.strokeRoundedPlay,
    AppIconType.pause: HugeIcons.strokeRoundedPause,
    AppIconType.customer: HugeIcons.strokeRoundedUser,
    AppIconType.window: HugeIcons.strokeRoundedWebDesign01,
    AppIconType.measurement: HugeIcons.strokeRoundedRuler,
    AppIconType.calculator: HugeIcons.strokeRoundedCalculator01,
    AppIconType.calendar: HugeIcons.strokeRoundedCalendar03,
    AppIconType.location: HugeIcons.strokeRoundedLocation01,
    AppIconType.phone: HugeIcons.strokeRoundedCall02,
    AppIconType.notification: HugeIcons.strokeRoundedNotification03,
    AppIconType.theme: HugeIcons.strokeRoundedMoon02,
    AppIconType.sun: HugeIcons.strokeRoundedSun03,
    AppIconType.moon: HugeIcons.strokeRoundedMoon02,
    AppIconType.palette: HugeIcons.strokeRoundedPaintBoard,
    AppIconType.textSize: HugeIcons.strokeRoundedTextFont, // Proxy
    AppIconType.font: HugeIcons.strokeRoundedTextFont,
    AppIconType.icons: HugeIcons.strokeRoundedGrid,
    AppIconType.database: HugeIcons.strokeRoundedDatabase01,
    AppIconType.upload: HugeIcons.strokeRoundedCloudUpload,
    AppIconType.download: HugeIcons.strokeRoundedCloudDownload,
    AppIconType.rocket: HugeIcons.strokeRoundedRocket01,
    AppIconType.info: HugeIcons.strokeRoundedInformationCircle,
    AppIconType.code: HugeIcons.strokeRoundedCode,
    AppIconType.device: HugeIcons.strokeRoundedSmartPhone01,
    AppIconType.warning: HugeIcons.strokeRoundedAlert02,
    AppIconType.error: HugeIcons.strokeRoundedAlertCircle,
    AppIconType.success: HugeIcons.strokeRoundedCheckmarkCircle02,
    AppIconType.folder: HugeIcons.strokeRoundedFolder01,
    AppIconType.file: HugeIcons.strokeRoundedFile01,
    AppIconType.sparkle: HugeIcons.strokeRoundedClean,
    AppIconType.premium: HugeIcons.strokeRoundedDiamond01,
    AppIconType.lock: HugeIcons.strokeRoundedLockKey,
  };

  // 4. Remix Icons
  static final Map<AppIconType, IconData> remix = {
    AppIconType.home: Remix.home_4_line,
    AppIconType.enquiry: Remix.clipboard_line,
    AppIconType.agreement: Remix.file_paper_2_line,
    AppIconType.settings: Remix.settings_4_line,
    AppIconType.add: Remix.add_line,
    AppIconType.remove: Remix.subtract_line,
    AppIconType.edit: Remix.pencil_line,
    AppIconType.delete: Remix.delete_bin_line,
    AppIconType.share: Remix.share_line,
    AppIconType.print: Remix.printer_line,
    AppIconType.sync: Remix.refresh_line,
    AppIconType.search: Remix.search_line,
    AppIconType.close: Remix.close_line,
    AppIconType.back: Remix.arrow_left_line,
    AppIconType.arrowRight: Remix.arrow_right_line,
    AppIconType.more: Remix.more_2_fill,
    AppIconType.check: Remix.check_line,
    AppIconType.play: Remix.play_line,
    AppIconType.pause: Remix.pause_line,
    AppIconType.customer: Remix.user_3_line,
    AppIconType.window: Remix.window_line,
    AppIconType.measurement: Remix.ruler_line,
    AppIconType.calculator: Remix.calculator_line,
    AppIconType.calendar: Remix.calendar_line,
    AppIconType.location: Remix.map_pin_line,
    AppIconType.phone: Remix.phone_line,
    AppIconType.notification: Remix.notification_3_line,
    AppIconType.theme: Remix.moon_line,
    AppIconType.sun: Remix.sun_line,
    AppIconType.moon: Remix.moon_line,
    AppIconType.palette: Remix.palette_line,
    AppIconType.textSize: Remix.font_size,
    AppIconType.font: Remix.text,
    AppIconType.icons: Remix.grid_fill,
    AppIconType.database: Remix.database_2_line,
    AppIconType.upload: Remix.upload_cloud_2_line,
    AppIconType.download: Remix.download_cloud_2_line,
    AppIconType.rocket: Remix.rocket_line,
    AppIconType.info: Remix.information_line,
    AppIconType.code: Remix.code_s_slash_line,
    AppIconType.device: Remix.smartphone_line,
    AppIconType.warning: Remix.alert_line,
    AppIconType.error: Remix.error_warning_line,
    AppIconType.success: Remix.checkbox_circle_line,
    AppIconType.folder: Remix.folder_3_line,
    AppIconType.file: Remix.file_text_line,
    AppIconType.sparkle: Remix.magic_line,
    AppIconType.premium: Remix.vip_diamond_line,
    AppIconType.lock: Remix.lock_line,
  };

  // 5. BoxIcons
  static final Map<AppIconType, IconData> boxicons = {
    AppIconType.home: Boxicons.bx_home_alt_2,
    AppIconType.enquiry: Boxicons.bx_clipboard,
    AppIconType.agreement: Boxicons.bx_file,
    AppIconType.settings: Boxicons.bx_cog,
    AppIconType.add: Boxicons.bx_plus,
    AppIconType.remove: Boxicons.bx_minus,
    AppIconType.edit: Boxicons.bx_pencil,
    AppIconType.delete: Boxicons.bx_trash,
    AppIconType.share: Boxicons.bx_share_alt,
    AppIconType.print: Boxicons.bx_printer,
    AppIconType.sync: Boxicons.bx_sync,
    AppIconType.search: Boxicons.bx_search,
    AppIconType.close: Boxicons.bx_x,
    AppIconType.back: Boxicons.bx_left_arrow_alt,
    AppIconType.arrowRight: Boxicons.bx_right_arrow_alt,
    AppIconType.more: Boxicons.bx_dots_vertical_rounded,
    AppIconType.check: Boxicons.bx_check,
    AppIconType.play: Boxicons.bx_play,
    AppIconType.pause: Boxicons.bx_pause,
    AppIconType.customer: Boxicons.bx_user,
    AppIconType.window: Boxicons.bx_window,
    AppIconType.measurement: Boxicons.bx_ruler,
    AppIconType.calculator: Boxicons.bx_calculator,
    AppIconType.calendar: Boxicons.bx_calendar,
    AppIconType.location: Boxicons.bx_map,
    AppIconType.phone: Boxicons.bx_phone,
    AppIconType.notification: Boxicons.bx_bell,
    AppIconType.theme: Boxicons.bx_moon,
    AppIconType.sun: Boxicons.bx_sun,
    AppIconType.moon: Boxicons.bx_moon,
    AppIconType.palette: Boxicons.bx_palette,
    AppIconType.textSize: Boxicons.bx_font_size,
    AppIconType.font: Boxicons.bx_font,
    AppIconType.icons: Boxicons.bx_grid_alt,
    AppIconType.database: Boxicons.bx_data,
    AppIconType.upload: Boxicons.bx_cloud_upload,
    AppIconType.download: Boxicons.bx_cloud_download,
    AppIconType.rocket: Boxicons.bx_rocket,
    AppIconType.info: Boxicons.bx_info_circle,
    AppIconType.code: Boxicons.bx_code_alt,
    AppIconType.device: Boxicons.bx_mobile,
    AppIconType.warning: Boxicons.bx_error,
    AppIconType.error: Boxicons.bx_error_circle,
    AppIconType.success: Boxicons.bx_check_circle,
    AppIconType.folder: Boxicons.bx_folder,
    AppIconType.file: Boxicons.bx_file_blank,
    AppIconType.sparkle: Boxicons.bxs_magic_wand,
    AppIconType.premium: Boxicons.bx_diamond,
    AppIconType.lock: Boxicons.bx_lock_alt,
  };

  // 6. HeroIcons - Returns HeroIcons enum
  static final Map<AppIconType, dynamic> heroicons = {
    AppIconType.home: HeroIcons.home,
    AppIconType.enquiry: HeroIcons.clipboardDocumentList,
    AppIconType.agreement: HeroIcons.documentText,
    AppIconType.settings: HeroIcons.cog6Tooth,
    AppIconType.add: HeroIcons.plus,
    AppIconType.remove: HeroIcons.minus,
    AppIconType.edit: HeroIcons.pencil,
    AppIconType.delete: HeroIcons.trash,
    AppIconType.share: HeroIcons.share,
    AppIconType.print: HeroIcons.printer,
    AppIconType.sync: HeroIcons.arrowPath,
    AppIconType.search: HeroIcons.magnifyingGlass,
    AppIconType.close: HeroIcons.xMark,
    AppIconType.back: HeroIcons.arrowLeft,
    AppIconType.arrowRight: HeroIcons.arrowRight,
    AppIconType.more: HeroIcons.ellipsisVertical,
    AppIconType.check: HeroIcons.check,
    AppIconType.play: HeroIcons.play,
    AppIconType.pause: HeroIcons.pause,
    AppIconType.customer: HeroIcons.user,
    AppIconType.window: HeroIcons.window,
    AppIconType.measurement: HeroIcons.scale,
    AppIconType.calculator: HeroIcons.calculator,
    AppIconType.calendar: HeroIcons.calendar,
    AppIconType.location: HeroIcons.mapPin,
    AppIconType.phone: HeroIcons.phone,
    AppIconType.notification: HeroIcons.bell,
    AppIconType.theme: HeroIcons.moon,
    AppIconType.sun: HeroIcons.sun,
    AppIconType.moon: HeroIcons.moon,
    AppIconType.palette: HeroIcons.swatch,
    AppIconType.textSize: HeroIcons.bars3BottomLeft,
    AppIconType.font: HeroIcons.language,
    AppIconType.icons: HeroIcons.squares2x2,
    AppIconType.database: HeroIcons.server,
    AppIconType.upload: HeroIcons.cloudArrowUp,
    AppIconType.download: HeroIcons.cloudArrowDown,
    AppIconType.rocket: HeroIcons.rocketLaunch,
    AppIconType.info: HeroIcons.informationCircle,
    AppIconType.code: HeroIcons.codeBracket,
    AppIconType.device: HeroIcons.devicePhoneMobile,
    AppIconType.warning: HeroIcons.exclamationTriangle,
    AppIconType.error: HeroIcons.exclamationCircle,
    AppIconType.success: HeroIcons.checkCircle,
    AppIconType.folder: HeroIcons.folder,
    AppIconType.file: HeroIcons.document,
    AppIconType.sparkle: HeroIcons.sparkles,
    AppIconType.premium: HeroIcons.trophy,
    AppIconType.lock: HeroIcons.lockClosed,
  };

  // 7. Phosphor Icons
  static final Map<AppIconType, dynamic> phosphor = {
    AppIconType.home: PhosphorIcons.house,
    AppIconType.enquiry: PhosphorIcons.clipboardText,
    AppIconType.agreement: PhosphorIcons.fileText,
    AppIconType.settings: PhosphorIcons.gear,
    AppIconType.add: PhosphorIcons.plus,
    AppIconType.remove: PhosphorIcons.minus,
    AppIconType.edit: PhosphorIcons.pencilSimple,
    AppIconType.delete: PhosphorIcons.trash,
    AppIconType.share: PhosphorIcons.shareNetwork,
    AppIconType.print: PhosphorIcons.printer,
    AppIconType.sync: PhosphorIcons.arrowsClockwise,
    AppIconType.search: PhosphorIcons.magnifyingGlass,
    AppIconType.close: PhosphorIcons.x,
    AppIconType.back: PhosphorIcons.arrowLeft,
    AppIconType.arrowRight: PhosphorIcons.arrowRight,
    AppIconType.more: PhosphorIcons.dotsThreeVertical,
    AppIconType.check: PhosphorIcons.check,
    AppIconType.play: PhosphorIcons.play,
    AppIconType.pause: PhosphorIcons.pause,
    AppIconType.customer: PhosphorIcons.user,
    AppIconType.window: PhosphorIcons.appWindow,
    AppIconType.measurement: PhosphorIcons.ruler,
    AppIconType.calculator: PhosphorIcons.calculator,
    AppIconType.calendar: PhosphorIcons.calendarBlank,
    AppIconType.location: PhosphorIcons.mapPin,
    AppIconType.phone: PhosphorIcons.phone,
    AppIconType.notification: PhosphorIcons.bell,
    AppIconType.theme: PhosphorIcons.moon,
    AppIconType.palette: PhosphorIcons.palette,
    AppIconType.textSize: PhosphorIcons.textT,
    AppIconType.font: PhosphorIcons.textAa,
    AppIconType.icons: PhosphorIcons.squaresFour,
    AppIconType.database: PhosphorIcons.database,
    AppIconType.upload: PhosphorIcons.cloudArrowUp,
    AppIconType.download: PhosphorIcons.cloudArrowDown,
    AppIconType.rocket: PhosphorIcons.rocket,
    AppIconType.info: PhosphorIcons.info,
    AppIconType.code: PhosphorIcons.code,
    AppIconType.device: PhosphorIcons.deviceMobile,
    AppIconType.warning: PhosphorIcons.warning,
    AppIconType.error: PhosphorIcons.warningCircle,
    AppIconType.success: PhosphorIcons.checkCircle,
    AppIconType.folder: PhosphorIcons.folder,
    AppIconType.file: PhosphorIcons.file,
    AppIconType.sparkle: PhosphorIcons.sparkle,
    AppIconType.premium: PhosphorIcons.diamond,
    AppIconType.lock: PhosphorIcons.lock,
  };

  // 8. Eva Icons
  static final Map<AppIconType, IconData> eva = {
    AppIconType.home: EvaIcons.homeOutline,
    AppIconType.enquiry: EvaIcons.clipboardOutline,
    AppIconType.agreement: EvaIcons.fileTextOutline,
    AppIconType.settings: EvaIcons.settings2Outline,
    AppIconType.add: EvaIcons.plus,
    AppIconType.remove: EvaIcons.minus,
    AppIconType.edit: EvaIcons.editOutline,
    AppIconType.delete: EvaIcons.trash2Outline,
    AppIconType.share: EvaIcons.shareOutline,
    AppIconType.print: EvaIcons.printerOutline,
    AppIconType.sync: EvaIcons.refreshOutline,
    AppIconType.search: EvaIcons.searchOutline,
    AppIconType.close: EvaIcons.close,
    AppIconType.back: EvaIcons.arrowBackOutline,
    AppIconType.arrowRight: EvaIcons.arrowForwardOutline,
    AppIconType.more: EvaIcons.moreVerticalOutline,
    AppIconType.check: EvaIcons.checkmark,
    AppIconType.play: EvaIcons.playCircleOutline,
    AppIconType.pause: EvaIcons.pauseCircleOutline,
    AppIconType.customer: EvaIcons.personOutline,
    AppIconType.window: EvaIcons.gridOutline,
    AppIconType.measurement: EvaIcons.moveOutline,
    AppIconType.calculator: EvaIcons.keypadOutline,
    AppIconType.calendar: EvaIcons.calendarOutline,
    AppIconType.location: EvaIcons.pinOutline,
    AppIconType.phone: EvaIcons.phoneOutline,
    AppIconType.notification: EvaIcons.bellOutline,
    AppIconType.theme: EvaIcons.moonOutline,
    AppIconType.sun: EvaIcons.sunOutline,
    AppIconType.moon: EvaIcons.moonOutline,
    AppIconType.palette: EvaIcons.colorPaletteOutline,
    AppIconType.textSize: EvaIcons.textOutline,
    AppIconType.font: EvaIcons.textOutline,
    AppIconType.icons: EvaIcons.gridOutline,
    AppIconType.database: EvaIcons.hardDriveOutline,
    AppIconType.upload: EvaIcons.cloudUploadOutline,
    AppIconType.download: EvaIcons.cloudDownloadOutline,
    AppIconType.rocket: EvaIcons.paperPlaneOutline,
    AppIconType.info: EvaIcons.infoOutline,
    AppIconType.code: EvaIcons.code,
    AppIconType.device: EvaIcons.smartphoneOutline,
    AppIconType.warning: EvaIcons.alertTriangleOutline,
    AppIconType.error: EvaIcons.alertCircleOutline,
    AppIconType.success: EvaIcons.checkmarkCircle2Outline,
    AppIconType.folder: EvaIcons.folderOutline,
    AppIconType.file: EvaIcons.fileOutline,
    AppIconType.sparkle: EvaIcons.starOutline,
    AppIconType.premium: EvaIcons.awardOutline,
    AppIconType.lock: EvaIcons.lockOutline,
  };

  // 9. Tabler Icons
  static final Map<AppIconType, IconData> tabler = {
    AppIconType.home: TablerIcons.home,
    AppIconType.enquiry: TablerIcons.clipboard_list,
    AppIconType.agreement: TablerIcons.file_text,
    AppIconType.settings: TablerIcons.settings,
    AppIconType.add: TablerIcons.plus,
    AppIconType.remove: TablerIcons.minus,
    AppIconType.edit: TablerIcons.pencil,
    AppIconType.delete: TablerIcons.trash,
    AppIconType.share: TablerIcons.share,
    AppIconType.print: TablerIcons.printer,
    AppIconType.sync: TablerIcons.refresh,
    AppIconType.search: TablerIcons.search,
    AppIconType.close: TablerIcons.x,
    AppIconType.back: TablerIcons.arrow_left,
    AppIconType.arrowRight: TablerIcons.arrow_right,
    AppIconType.more: TablerIcons.dots_vertical,
    AppIconType.check: TablerIcons.check,
    AppIconType.play: TablerIcons.player_play,
    AppIconType.pause: TablerIcons.player_pause,
    AppIconType.customer: TablerIcons.user,
    AppIconType.window: TablerIcons.app_window,
    AppIconType.measurement: TablerIcons.ruler,
    AppIconType.calculator: TablerIcons.calculator,
    AppIconType.calendar: TablerIcons.calendar,
    AppIconType.location: TablerIcons.map_pin,
    AppIconType.phone: TablerIcons.phone,
    AppIconType.notification: TablerIcons.bell,
    AppIconType.theme: TablerIcons.moon,
    AppIconType.palette: TablerIcons.color_swatch,
    AppIconType.textSize: TablerIcons.text_size,
    AppIconType.font: TablerIcons.typography,
    AppIconType.icons: TablerIcons.grid_dots,
    AppIconType.database: TablerIcons.database,
    AppIconType.upload: TablerIcons.cloud_upload,
    AppIconType.download: TablerIcons.cloud_download,
    AppIconType.rocket: TablerIcons.rocket,
    AppIconType.info: TablerIcons.info_circle,
    AppIconType.code: TablerIcons.code,
    AppIconType.device: TablerIcons.device_mobile,
    AppIconType.warning: TablerIcons.alert_triangle,
    AppIconType.error: TablerIcons.alert_circle,
    AppIconType.success: TablerIcons.circle_check,
    AppIconType.folder: TablerIcons.folder,
    AppIconType.file: TablerIcons.file,
    AppIconType.sparkle: TablerIcons.sparkles,
    AppIconType.premium: TablerIcons.diamond,
    AppIconType.lock: TablerIcons.lock,
  };

  // 12. Font Awesome
  static final Map<AppIconType, IconData> fontAwesome = {
    AppIconType.home: FontAwesomeIcons.house,
    AppIconType.enquiry: FontAwesomeIcons.clipboardList,
    AppIconType.agreement: FontAwesomeIcons.fileContract,
    AppIconType.settings: FontAwesomeIcons.gear,
    AppIconType.add: FontAwesomeIcons.plus,
    AppIconType.remove: FontAwesomeIcons.minus,
    AppIconType.edit: FontAwesomeIcons.pencil,
    AppIconType.delete: FontAwesomeIcons.trash,
    AppIconType.share: FontAwesomeIcons.shareNodes,
    AppIconType.print: FontAwesomeIcons.print,
    AppIconType.sync: FontAwesomeIcons.rotate,
    AppIconType.search: FontAwesomeIcons.magnifyingGlass,
    AppIconType.close: FontAwesomeIcons.xmark,
    AppIconType.back: FontAwesomeIcons.arrowLeft,
    AppIconType.arrowRight: FontAwesomeIcons.arrowRight,
    AppIconType.more: FontAwesomeIcons.ellipsisVertical,
    AppIconType.check: FontAwesomeIcons.check,
    AppIconType.play: FontAwesomeIcons.play,
    AppIconType.pause: FontAwesomeIcons.pause,
    AppIconType.customer: FontAwesomeIcons.user,
    AppIconType.window: FontAwesomeIcons.windowMaximize, // Proxy/Best match
    AppIconType.measurement: FontAwesomeIcons.ruler,
    AppIconType.calculator: FontAwesomeIcons.calculator,
    AppIconType.calendar: FontAwesomeIcons.calendar,
    AppIconType.location: FontAwesomeIcons.mapLocationDot,
    AppIconType.phone: FontAwesomeIcons.phone,
    AppIconType.notification: FontAwesomeIcons.bell,
    AppIconType.theme: FontAwesomeIcons.moon,
    AppIconType.sun: FontAwesomeIcons.sun,
    AppIconType.moon: FontAwesomeIcons.moon,
    AppIconType.palette: FontAwesomeIcons.palette,
    AppIconType.textSize: FontAwesomeIcons.font,
    AppIconType.font: FontAwesomeIcons.font,
    AppIconType.icons: FontAwesomeIcons.borderAll,
    AppIconType.database: FontAwesomeIcons.database,
    AppIconType.upload: FontAwesomeIcons.cloudArrowUp,
    AppIconType.download: FontAwesomeIcons.cloudArrowDown,
    AppIconType.rocket: FontAwesomeIcons.rocket,
    AppIconType.info: FontAwesomeIcons.circleInfo,
    AppIconType.code: FontAwesomeIcons.code,
    AppIconType.device: FontAwesomeIcons.mobile,
    AppIconType.warning: FontAwesomeIcons.triangleExclamation,
    AppIconType.error: FontAwesomeIcons.circleExclamation,
    AppIconType.success: FontAwesomeIcons.circleCheck,
    AppIconType.folder: FontAwesomeIcons.folder,
    AppIconType.file: FontAwesomeIcons.file,
    AppIconType.sparkle: FontAwesomeIcons.wandMagicSparkles,
    AppIconType.premium: FontAwesomeIcons.gem,
    AppIconType.lock: FontAwesomeIcons.lock,
  };

  // Fluent (Legagy)
  static final Map<AppIconType, IconData> fluent = {
    AppIconType.home: FluentIcons.home_24_regular,
    AppIconType.enquiry: FluentIcons.clipboard_task_24_regular,
    AppIconType.agreement: FluentIcons.document_24_regular,
    AppIconType.settings: FluentIcons.settings_24_regular,
    AppIconType.add: FluentIcons.add_24_regular,
    AppIconType.remove: FluentIcons.subtract_24_regular,
    AppIconType.edit: FluentIcons.edit_24_regular,
    AppIconType.delete: FluentIcons.delete_24_regular,
    AppIconType.share: FluentIcons.share_24_regular,
    AppIconType.print: FluentIcons.print_24_regular,
    AppIconType.sync: FluentIcons.arrow_sync_24_regular,
    AppIconType.search: FluentIcons.search_24_regular,
    AppIconType.close: FluentIcons.dismiss_24_regular,
    AppIconType.back: FluentIcons.arrow_left_24_regular,
    AppIconType.arrowRight: FluentIcons.arrow_right_24_regular,
    AppIconType.more: FluentIcons.more_vertical_24_regular,
    AppIconType.check: FluentIcons.checkmark_24_regular,
    AppIconType.play: FluentIcons.play_24_regular,
    AppIconType.pause: FluentIcons.pause_24_regular,
    AppIconType.customer: FluentIcons.person_24_regular,
    AppIconType.window: FluentIcons.window_24_regular,
    AppIconType.measurement: FluentIcons.ruler_24_regular,
    AppIconType.calculator: FluentIcons.calculator_24_regular,
    AppIconType.calendar: FluentIcons.calendar_ltr_24_regular,
    AppIconType.location: FluentIcons.location_24_regular,
    AppIconType.phone: FluentIcons.call_24_regular,
    AppIconType.notification: FluentIcons.alert_24_regular,
    AppIconType.theme: FluentIcons.dark_theme_24_regular,
    AppIconType.palette: FluentIcons.color_24_regular,
    AppIconType.textSize: FluentIcons.text_font_24_regular,
    AppIconType.font: FluentIcons.text_case_lowercase_24_regular,
    AppIconType.icons: FluentIcons.grid_24_regular,
    AppIconType.database: FluentIcons.database_24_regular,
    AppIconType.upload: FluentIcons.arrow_upload_24_regular,
    AppIconType.download: FluentIcons.arrow_download_24_regular,
    AppIconType.rocket: FluentIcons.rocket_24_regular,
    AppIconType.info: FluentIcons.info_24_regular,
    AppIconType.code: FluentIcons.code_24_regular,
    AppIconType.device: FluentIcons.phone_24_regular,
    AppIconType.warning: FluentIcons.warning_24_regular,
    AppIconType.error: FluentIcons.error_circle_24_regular,
    AppIconType.success: FluentIcons.checkmark_circle_24_regular,
    AppIconType.folder: FluentIcons.folder_24_regular,
    AppIconType.file: FluentIcons.document_24_regular,
    AppIconType.sparkle: FluentIcons.sparkle_24_filled,
    AppIconType.premium: FluentIcons.premium_24_regular,
    AppIconType.lock: FluentIcons.lock_closed_24_filled,
  };

  // Cupertino (Legacy)
  static final Map<AppIconType, IconData> cupertino = {
    AppIconType.home: CupertinoIcons.home,
    AppIconType.enquiry: CupertinoIcons.news,
    AppIconType.agreement: CupertinoIcons.doc_text,
    AppIconType.settings: CupertinoIcons.settings,
    AppIconType.add: CupertinoIcons.add,
    AppIconType.remove: CupertinoIcons.minus,
    AppIconType.edit: CupertinoIcons.pencil,
    AppIconType.delete: CupertinoIcons.delete,
    AppIconType.share: CupertinoIcons.share,
    AppIconType.print: CupertinoIcons.printer,
    AppIconType.sync: CupertinoIcons.arrow_2_circlepath,
    AppIconType.search: CupertinoIcons.search,
    AppIconType.close: CupertinoIcons.xmark,
    AppIconType.back: CupertinoIcons.back,
    AppIconType.arrowRight: CupertinoIcons.right_chevron,
    AppIconType.more: CupertinoIcons.ellipsis_vertical,
    AppIconType.check: CupertinoIcons.check_mark,
    AppIconType.play: CupertinoIcons.play_arrow,
    AppIconType.pause: CupertinoIcons.pause,
    AppIconType.customer: CupertinoIcons.person,
    AppIconType.window: CupertinoIcons.square,
    AppIconType.measurement: CupertinoIcons.slider_horizontal_3,
    AppIconType.calculator: CupertinoIcons.function,
    AppIconType.calendar: CupertinoIcons.calendar,
    AppIconType.location: CupertinoIcons.location,
    AppIconType.phone: CupertinoIcons.phone,
    AppIconType.notification: CupertinoIcons.bell,
    AppIconType.theme: CupertinoIcons.moon,
    AppIconType.sun: CupertinoIcons.sun_max,
    AppIconType.moon: CupertinoIcons.moon,
    AppIconType.palette: CupertinoIcons.paintbrush,
    AppIconType.textSize: CupertinoIcons.textformat_size,
    AppIconType.font: CupertinoIcons.textformat,
    AppIconType.icons: CupertinoIcons.square_grid_2x2,
    AppIconType.database: CupertinoIcons.square_stack_3d_up,
    AppIconType.upload: CupertinoIcons.cloud_upload,
    AppIconType.download: CupertinoIcons.cloud_download,
    AppIconType.rocket: CupertinoIcons.rocket_fill,
    AppIconType.info: CupertinoIcons.info,
    AppIconType.code: CupertinoIcons.chevron_left_slash_chevron_right,
    AppIconType.device: CupertinoIcons.device_phone_portrait,
    AppIconType.warning: CupertinoIcons.exclamationmark_triangle,
    AppIconType.error: CupertinoIcons.exclamationmark_circle,
    AppIconType.success: CupertinoIcons.checkmark_circle,
    AppIconType.folder: CupertinoIcons.folder,
    AppIconType.file: CupertinoIcons.doc,
    AppIconType.sparkle: CupertinoIcons.sparkles,
    AppIconType.premium: CupertinoIcons.star,
    AppIconType.lock: CupertinoIcons.lock_fill,
  };

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
      case IconPack.huge:
        return huge[type] ?? HugeIcons.strokeRoundedHelpCircle;
      case IconPack.fontAwesome:
        return fontAwesome[type] ?? FontAwesomeIcons.question;
    }
  }
}

/// Universal App Icon Widget
class AppIcon extends StatelessWidget {
  final dynamic
  icon; // Can be AppIconType, IconData, HeroIcons, Function (Phosphor), etc.
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
      data = icon; // Treat input as direct icon data
    }

    // Direct IconData via Override/Input (e.g. from Settings Sheet)
    // If the input was ALREADY IconData/etc (not AppIconType), we might want to respect that specifically.
    // However, the 'data' variable now holds the resolved icon regardless of source.

    // Check if we are in a special pack context but have raw IconData that might need special handling?
    // Generally 'data' is the source of truth now.

    if (pack == IconPack.material && data is IconData) {
      return Icon(
        data,
        size: size,
        color: color,
        weight: 500,
        grade: -25,
        fill: 0.0,
      );
    }

    // Hero Icons (Strictly Widgets)
    if (data is HeroIcons) {
      return HeroIcon(
        data,
        size: size,
        color: color,
        style: HeroIconStyle.outline, // Default to outline
      );
    }

    // Huge Icons - Fallback to standard Icon
    // if (pack == IconPack.huge && data is IconData) { ... }

    // Phosphor Icons (Function based)
    // If we passed PhosphorIcons.pencilSimple(PhosphorIconsStyle.regular) directly, it is an IconData/Widget?
    // PhosphorIcons.pencilSimple(...) returns an IconData usually? No, it returns 'IconData'.
    // If we passed the *function* from the map, it is 'Function'.
    if (data is Function) {
      return Icon(data(PhosphorIconsStyle.regular), size: size, color: color);
    }

    // Font Awesome (FaIcon Widget)
    // If pack is fontAwesome OR data came from FontAwesomeIcons (which are IconData), we should use FaIcon.
    // How to distinguish FontAwesome IconData from Material? They are both IconData.
    // We can rely on 'pack' if provided, or try to detect?
    // For the Settings Sheet, we pass specific icons. The pack might be 'SettingsProvider.iconPack' (current user setting).
    // If user has 'Material' selected, but we are showing the 'Font Awesome' row in settings with a FontAwesome icon:
    // 'pack' will be 'Material'. 'data' will be 'FontAwesomeIcons.fontAwesome'.
    // If we try to render FontAwesome icon with Material Icon widget, it might work or fail depending on fontFamily.
    // WE NEED TO ENSURE THE CORRECT WIDGET IS USED FOR THE SPECIFIC ICON DATA IF POSSIBLE.
    // BUT 'IconData' carries fontFamily. `Icon()` widget respects fontFamily.
    // `FaIcon()` is mainly for alignment?
    // Standard `Icon()` should work for FontAwesome implementation in `font_awesome_flutter`.
    // Let's try standard `Icon` for generic `IconData`.

    // Font Awesome Specific Check (if strictly needed)
    // Font Awesome Specific Check
    if (pack == IconPack.fontAwesome && data is IconData) {
      return FaIcon(data, size: size, color: color);
    }

    // Default Fallback
    if (data is IconData) {
      return Icon(data, size: size, color: color);
    }

    // Widget fallback (if data is already a widget?)
    if (data is Widget) {
      return SizedBox(width: size, height: size, child: data);
    }

    // Safety Fallback
    return Icon(Icons.help_outline_rounded, size: size, color: color);
  }
}
