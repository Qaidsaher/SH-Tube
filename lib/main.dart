import 'dart:async';
import 'dart:io'; // Used for Platform detection and file operations
import 'dart:math'; // Used for random simulation and min function

import 'package:dio/dio.dart'; // For network downloads
import 'package:file_picker/file_picker.dart'; // For directory selection
import 'package:flutter/foundation.dart'
    show kIsWeb; // To check if running on web
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'; // Cross-platform WebView
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart'; // To get default download paths

// --- Constants ---
const String kAppName = 'SH-Tube';
const Color kPrimaryColor = Colors.lightBlue; // Light blue primary color
const Color kSecondaryColor = Colors.blueAccent;

// --- Main Application Entry Point ---
void main() {
  // Ensure Flutter bindings are initialized for platform channel interactions
  WidgetsFlutterBinding.ensureInitialized();

  // Specific initialization needed for flutter_inappwebview on Android
  if (!kIsWeb && Platform.isAndroid) {
    InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(const MyApp());
}

// --- Root Application Widget ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      theme: ThemeData(
        // Using Material Design 3
        useMaterial3: true,
        // Define a modern, light blue color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryColor,
          brightness: Brightness.light,
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
          background: Colors.grey[50], // Slightly off-white background
          surface: Colors.white, // Card backgrounds, etc.
        ),
        // Customize typography for a cleaner look
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22.0,
          ), // Slightly bolder small headlines
          titleMedium: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ), // Standard titles
          bodyMedium: TextStyle(
            fontSize: 14.0,
            height: 1.4,
          ), // Readable body text
          bodySmall: TextStyle(
            fontSize: 12.0,
            color: Colors.grey,
          ), // Smaller text for details
        ),
        // Polish input fields
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0), // More rounded corners
            borderSide: BorderSide.none, // No border needed when filled
          ),
          filled: true,
          fillColor: Colors.grey[150], // Subtle fill color
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ), // Comfortable padding
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),
        // Style buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Consistent rounding
            ),
            elevation: 2, // Subtle shadow
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kSecondaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        // Style cards
        cardTheme: CardTheme(
          elevation: 1, // Lighter elevation for a cleaner look
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // More rounded cards
            side: BorderSide(
              color: Colors.grey[200]!,
              width: 0.5,
            ), // Subtle border
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        ),
        // App Bar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // Clean white app bar
          foregroundColor: Colors.black87, // Text/icons color
          elevation: 0.5, // Minimal shadow
          surfaceTintColor: Colors.transparent, // Prevent M3 tinting
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        // Navigation Elements Theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          elevation: 2,
        ),
        navigationRailTheme: NavigationRailThemeData(
          selectedIconTheme: IconThemeData(color: kPrimaryColor),
          unselectedIconTheme: IconThemeData(color: Colors.grey[600]),
          selectedLabelTextStyle: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelTextStyle: TextStyle(color: Colors.grey[600]),
          backgroundColor: Colors.white, // Clean background
          indicatorColor: kPrimaryColor.withOpacity(0.1), // Subtle indicator
        ),
        // TabBar Theme
        tabBarTheme: TabBarTheme(
          labelColor: kPrimaryColor,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: kPrimaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
      debugShowCheckedModeBanner: false, // Hide debug banner
      home: const SplashScreen(), // Start with the splash screen
    );
  }
}

// --- Splash Screen Widget ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward(); // Start animation
    _navigateToHome();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Navigate to the main app screen after a delay
  _navigateToHome() async {
    await Future.delayed(
      const Duration(milliseconds: 3000),
      () {},
    ); // 3-second delay
    if (mounted) {
      // Check if the widget is still in the tree
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          // Use PageRouteBuilder for a fade transition
          pageBuilder:
              (context, animation, secondaryAnimation) => const MyHomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor, // Use primary blue
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Modern App Logo Placeholder (e.g., stylized initials)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'SH',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                kAppName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 40),
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Main Application Page (Holds the different views) ---
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Index for BottomNavigationBar/NavigationRail
  AppSettings _settings = AppSettings(); // Holds user settings
  final List<DownloadItem> _activeDownloads = []; // List of active downloads
  final List<DownloadItem> _completedDownloads =
      []; // List of completed/failed downloads
  final Dio _dio = Dio(
    BaseOptions(
      // Set reasonable timeouts
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(
        minutes: 5,
      ), // Longer for potential large downloads
      // Configure Dio to not throw errors for status codes like 404
      // We will handle them manually in the download logic
      validateStatus: (status) {
        return status != null && status < 500; // Accept all statuses below 500
      },
    ),
  );
  int _currentConcurrentDownloads = 0; // Tracks currently running downloads

  // Controller for the browser URL bar
  final TextEditingController _urlController = TextEditingController();
  // Controller for the web view instance
  InAppWebViewController? _webViewController;
  // Initial URL for the web view
  final String _initialUrl =
      "https://duckduckgo.com"; // Privacy-focused search engine
  String _currentBrowserUrl = ""; // Store the current URL for the FAB action

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Load settings on startup
    _urlController.text = _initialUrl;
    _currentBrowserUrl = _initialUrl;
  }

  // Function to load settings (using defaults for this example)
  Future<void> _loadSettings() async {
    String? defaultPath;
    try {
      if (!kIsWeb) {
        // path_provider doesn't work on web
        // Prefer Downloads directory, fallback to Documents
        final directory =
            await getDownloadsDirectory() ??
            await getApplicationDocumentsDirectory();
        defaultPath = directory.path;
      } else {
        defaultPath = "/downloads"; // Placeholder for web
      }
    } catch (e) {
      print("Error getting default download directory: $e");
      // Fallback if path_provider fails
      defaultPath = "/downloads"; // Placeholder
    }

    setState(() {
      _settings = AppSettings(
        maxConcurrentDownloads: 3, // Default value
        downloadPath:
            defaultPath ?? "/downloads", // Use fetched path or fallback
      );
    });
  }

  // Function to update settings
  void _updateSettings(AppSettings newSettings) {
    setState(() {
      _settings = newSettings;
      // In a real app, persist settings here (e.g., SharedPreferences)
      print(
        "Settings updated: Max Downloads=${_settings.maxConcurrentDownloads}, Path=${_settings.downloadPath}",
      );
    });
    _processDownloadQueue(); // Re-evaluate queue after settings change
  }

  // --- Download Logic ---

  // Attempts to start a new download
  Future<void> _startDownload(String url, DownloadQuality quality) async {
    // **Limitation Note:** Extracting specific video/audio streams and qualities
    // from complex sites like YouTube requires dedicated libraries (e.g., youtube_explode_dart)
    // or backend processing. This example simulates quality selection and performs a
    // basic file download using Dio for demonstration. Audio extraction (e.g., using ffmpeg)
    // is beyond the scope of a simple Flutter app without native integration.

    // Basic validation: Ensure URL seems plausible and path exists (or can be created)
    // if (!Uri.tryParse(url)?.hasAbsolutePath ?? true) {
    //   _showSnackBar("Invalid URL provided for download.", isError: true);
    //   return;
    // }
    if (!(Uri.tryParse(url)?.hasAbsolutePath ?? false)) {
      _showSnackBar("Invalid URL provided for download.", isError: true);
      return;
    }

    // Ensure the download directory exists (create if not) - Crucial!
    try {
      final dir = Directory(_settings.downloadPath);
      if (!await dir.exists()) {
        await dir.create(
          recursive: true,
        ); // Create parent directories if needed
        print("Created download directory: ${_settings.downloadPath}");
      }
    } catch (e) {
      print("Error creating download directory: $e");
      _showSnackBar(
        "Cannot create download directory: ${_settings.downloadPath}. Please check path/permissions.",
        isError: true,
      );
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    String filename = _generateFilename(url, quality);
    final String filePath = '${_settings.downloadPath}/$filename';

    final newItem = DownloadItem(
      id: id,
      url: url, // Store the original URL requested by the user
      filename: filename,
      status: DownloadStatus.queued,
      quality: quality,
      filePath: filePath, // Store the intended final path
    );

    setState(() {
      _activeDownloads.add(newItem);
    });
    _showSnackBar("Added to download queue: ${newItem.filename}");
    _processDownloadQueue(); // Check if this new download can start immediately
  }

  // Generates a filename based on URL and quality
  String _generateFilename(String url, DownloadQuality quality) {
    Uri uri;
    try {
      uri = Uri.parse(url);
    } catch (_) {
      // Handle invalid URI gracefully
      return 'invalid_url_${DateTime.now().millisecondsSinceEpoch}.${quality == DownloadQuality.audioOnly ? 'mp3' : 'mp4'}';
    }

    String host = uri.host.replaceAll(
      RegExp(r'[^a-zA-Z0-9_\-\.]'),
      '_',
    ); // Sanitize host
    String pathSegment =
        uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'file';
    // Remove potentially invalid characters for filenames more aggressively
    pathSegment = pathSegment.replaceAll(RegExp(r'[<>:"/\\|?*%#]'), '_');
    // Limit length
    pathSegment =
        pathSegment.length > 50 ? pathSegment.substring(0, 50) : pathSegment;

    String qualitySuffix = quality.toString().split('.').last;
    String extension =
        quality == DownloadQuality.audioOnly
            ? 'mp3'
            : 'mp4'; // Simulated extension

    // Ensure filename doesn't start/end with spaces or dots
    String baseName = '${host}_${pathSegment}_$qualitySuffix'.replaceAll(
      RegExp(r'^\.+|\.+$|^ +| +$'),
      '',
    );
    if (baseName.isEmpty)
      baseName = 'download'; // Fallback if sanitization results in empty string

    return '$baseName.$extension';
  }

  // Process the download queue, starting downloads if slots are available
  void _processDownloadQueue() {
    int availableSlots =
        _settings.maxConcurrentDownloads - _currentConcurrentDownloads;
    if (availableSlots <= 0) return; // No slots available

    // Find queued downloads
    var queuedDownloads =
        _activeDownloads
            .where((d) => d.status == DownloadStatus.queued)
            .toList();

    // Start downloads up to the available slots
    for (int i = 0; i < min(availableSlots, queuedDownloads.length); i++) {
      _initiateActualDownload(queuedDownloads[i]);
    }
  }

  // Initiates the actual download process for a specific item
  Future<void> _initiateActualDownload(DownloadItem item) async {
    // Find item index safely
    int itemIndex = _activeDownloads.indexWhere((d) => d.id == item.id);
    if (itemIndex == -1 || !mounted) return; // Item removed or widget unmounted

    setState(() {
      _activeDownloads[itemIndex].status = DownloadStatus.downloading;
      _currentConcurrentDownloads++;
    });

    CancelToken cancelToken = CancelToken();
    _activeDownloads[itemIndex].cancelToken =
        cancelToken; // Store the cancel token

    try {
      // **Using Stable Sample Download URLs**
      String downloadUrl = _getSampleDownloadUrl(
        item.quality,
      ); // Use sample URL based on quality
      // String downloadUrl = item.url; // Use this line INSTEAD of the above for REAL downloads from user URL (HIGHLY UNRELIABLE without parsing)

      print(
        "Starting download: ${item.filename} from $downloadUrl to ${item.filePath}",
      );

      final response = await _dio.download(
        downloadUrl,
        item.filePath!, // Save to the designated path
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          // Update progress only if the item is still downloading and widget is mounted
          final currentIndex = _activeDownloads.indexWhere(
            (d) => d.id == item.id,
          );
          if (currentIndex != -1 &&
              _activeDownloads[currentIndex].status ==
                  DownloadStatus.downloading &&
              total > 0 &&
              mounted) {
            double progress = received / total;
            // Throttle setState calls for performance if needed, e.g., update every 1%
            // if ((progress * 100).toInt() > (_activeDownloads[currentIndex].progress * 100).toInt()) {
            setState(() {
              _activeDownloads[currentIndex].progress = progress;
            });
            // }
          }
        },
        // deleteOnError: true, // Remove partially downloaded file on error
      );

      // Check if cancelled before marking as complete
      if (cancelToken.isCancelled) {
        _handleDownloadCompletion(item.id, DownloadStatus.cancelled);
      } else if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // Successful download (HTTP 2xx)
        if (mounted)
          _handleDownloadCompletion(item.id, DownloadStatus.completed);
      } else {
        // Handle non-2xx status codes as errors (e.g., 404 Not Found, 403 Forbidden)
        String errorMsg =
            "HTTP Error ${response.statusCode}: ${response.statusMessage ?? 'Failed to download'}";
        print("Download failed for ${item.filename}: $errorMsg");
        if (mounted)
          _handleDownloadCompletion(
            item.id,
            DownloadStatus.failed,
            error: errorMsg,
          );
      }
    } on DioException catch (e) {
      String errorMsg;
      if (e.type == DioExceptionType.cancel) {
        errorMsg = "Cancelled by user";
        if (mounted)
          _handleDownloadCompletion(
            item.id,
            DownloadStatus.cancelled,
            error: errorMsg,
          );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMsg = "Network timeout";
        if (mounted)
          _handleDownloadCompletion(
            item.id,
            DownloadStatus.failed,
            error: errorMsg,
          );
      } else if (e.type == DioExceptionType.badResponse) {
        errorMsg =
            "Server error ${e.response?.statusCode}: ${e.response?.statusMessage ?? e.message}";
        if (mounted)
          _handleDownloadCompletion(
            item.id,
            DownloadStatus.failed,
            error: errorMsg,
          );
      } else if (e.type == DioExceptionType.connectionError) {
        errorMsg = "Network connection error";
        if (mounted)
          _handleDownloadCompletion(
            item.id,
            DownloadStatus.failed,
            error: errorMsg,
          );
      } else {
        errorMsg = "Download error: ${e.message ?? e.toString()}";
        if (mounted)
          _handleDownloadCompletion(
            item.id,
            DownloadStatus.failed,
            error: errorMsg,
          );
      }
      print("DioException for ${item.filename}: $e");
    } catch (e) {
      // Catch other potential errors (e.g., file system issues during save)
      String errorMsg = "An unexpected error occurred: $e";
      print("Generic Download Error for ${item.filename}: $e");
      if (mounted) {
        _handleDownloadCompletion(
          item.id,
          DownloadStatus.failed,
          error: errorMsg,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _currentConcurrentDownloads--;
        });
        _processDownloadQueue(); // Check if other downloads can start
      }
    }
  }

  // Provides sample download URLs based on quality (for testing)
  String _getSampleDownloadUrl(DownloadQuality quality) {
    // Using stable sample files from archive.org
    switch (quality) {
      case DownloadQuality.low:
        // Small MP4 video
        return "https://archive.org/download/SampleVideo1280x7205mb/SampleVideo_360x240_1mb.mp4";
      case DownloadQuality.medium:
        // Medium MP4 video
        return "https://archive.org/download/SampleVideo1280x7205mb/SampleVideo_1280x720_5mb.mp4";
      case DownloadQuality.high:
        // Using medium as high for now, find a larger public domain file if needed
        return "https://archive.org/download/SampleVideo1280x7205mb/SampleVideo_1280x720_5mb.mp4";
      case DownloadQuality.audioOnly:
        // Sample MP3 file
        return "https://archive.org/download/testmp3testfile/mpthreetest.mp3";
      default: // Fallback to low quality
        return "https://archive.org/download/SampleVideo1280x7205mb/SampleVideo_360x240_1mb.mp4";
    }
  }

  // Handle completion/failure/cancellation of a download identified by its ID
  void _handleDownloadCompletion(
    String itemId,
    DownloadStatus finalStatus, {
    String? error,
  }) {
    if (!mounted) return; // Ensure widget is still active

    setState(() {
      // Find the item in the active list
      final index = _activeDownloads.indexWhere((d) => d.id == itemId);
      if (index != -1) {
        final completedItem = _activeDownloads.removeAt(index);
        completedItem.status = finalStatus;
        completedItem.progress =
            (finalStatus == DownloadStatus.completed)
                ? 1.0
                : completedItem.progress;
        completedItem.error = error; // Store error message if failed
        completedItem.cancelToken = null; // Clear cancel token
        _completedDownloads.insert(
          0,
          completedItem,
        ); // Add to the top of completed list

        // Show feedback message
        if (finalStatus == DownloadStatus.completed) {
          _showSnackBar("Download completed: ${completedItem.filename}");
        } else if (finalStatus == DownloadStatus.failed) {
          _showSnackBar(
            "Download failed: ${completedItem.filename}${error != null ? ' ($error)' : ''}",
            isError: true,
          );
        } else if (finalStatus == DownloadStatus.cancelled) {
          _showSnackBar("Download cancelled: ${completedItem.filename}");
        }
      } else {
        print("Error: Could not find item with ID $itemId to complete.");
      }
    });
  }

  // Cancel an ongoing or queued download
  void _cancelDownload(DownloadItem item) {
    if (item.status == DownloadStatus.downloading) {
      item.cancelToken?.cancel("Download cancelled by user.");
      // The DioException handler or completion handler will move it to completed list with cancelled status
    } else if (item.status == DownloadStatus.queued && mounted) {
      // If it was only queued, remove directly and mark as cancelled
      setState(() {
        final index = _activeDownloads.indexWhere((d) => d.id == item.id);
        if (index != -1) {
          final cancelledItem = _activeDownloads.removeAt(index);
          cancelledItem.status = DownloadStatus.cancelled;
          _completedDownloads.insert(0, cancelledItem);
          _showSnackBar(
            "Download removed from queue: ${cancelledItem.filename}",
          );
        }
      });
    }
  }

  // Remove a download entry from the completed list
  void _removeCompletedDownload(DownloadItem item) {
    setState(() {
      _completedDownloads.removeWhere((d) => d.id == item.id);
      // Optionally, attempt to delete the actual file
      _deleteAssociatedFile(item);
    });
  }

  // Helper to attempt file deletion
  Future<void> _deleteAssociatedFile(DownloadItem item) async {
    if (item.filePath != null && !kIsWeb) {
      // Cannot delete files directly on web
      try {
        final file = File(item.filePath!);
        if (await file.exists()) {
          await file.delete();
          print("Deleted file: ${item.filePath}");
          _showSnackBar("Removed file: ${item.filename}");
        }
      } catch (e) {
        print("Error deleting file ${item.filePath}: $e");
        _showSnackBar("Error deleting file: ${item.filename}", isError: true);
      }
    }
  }

  // Show a SnackBar message with updated styling
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor:
            isError
                ? Colors.redAccent.shade700
                : Theme.of(
                  context,
                ).colorScheme.secondary, // Use secondary color for success
        behavior: SnackBarBehavior.floating, // Looks better on desktop/web
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(10.0),
        elevation: 4,
      ),
    );
  }

  // --- UI Building ---

  // Builds the appropriate view based on the selected index
  Widget _buildCurrentView() {
    switch (_selectedIndex) {
      case 0: // Browser
        return BrowserView(
          initialUrl: _initialUrl,
          urlController: _urlController,
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
          onUrlChanged: (url) {
            if (url != null && mounted) {
              setState(() {
                _urlController.text = url.toString();
                _currentBrowserUrl = url.toString(); // Update URL for FAB
              });
            }
          },
          // Note: onDownloadRequested is now handled by the FAB in the main Scaffold
        );
      case 1: // Downloads
        return DownloadsView(
          activeDownloads: _activeDownloads,
          completedDownloads: _completedDownloads,
          onCancelDownload: _cancelDownload,
          onRemoveDownload: _removeCompletedDownload,
          onRetryDownload: _retryDownload, // Pass retry function
        );
      case 2: // Settings
        return SettingsView(
          currentSettings: _settings,
          onSettingsChanged: _updateSettings,
        );
      default:
        return const Center(child: Text('Unknown Page'));
    }
  }

  // --- Retry Logic ---
  void _retryDownload(DownloadItem item) {
    if (item.status != DownloadStatus.failed &&
        item.status != DownloadStatus.cancelled) {
      return; // Only retry failed or cancelled items
    }

    if (mounted) {
      setState(() {
        // Remove from completed list
        _completedDownloads.removeWhere((d) => d.id == item.id);

        // Reset state and add back to active queue
        item.status = DownloadStatus.queued;
        item.progress = 0.0;
        item.error = null;
        item.cancelToken = null; // Ensure cancel token is fresh if needed later

        _activeDownloads.add(item);
        _showSnackBar("Retrying download: ${item.filename}");
      });
      _processDownloadQueue(); // Trigger queue processing
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the screen is "wide" (likely desktop/tablet)
    bool isWideScreen =
        MediaQuery.of(context).size.width > 700; // Adjusted breakpoint

    return Scaffold(
      appBar: AppBar(
        title: Text(kAppName),
        centerTitle: true, // Center title for a cleaner look
      ),
      // Use NavigationRail for wider screens, BottomNavigationBar for narrower ones
      body: Row(
        children: [
          if (isWideScreen) // Show Rail on the left for wide screens
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType:
                  NavigationRailLabelType
                      .selected, // Show label only for selected
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.public_outlined),
                  selectedIcon: Icon(Icons.public),
                  label: Text('Browser'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.download_outlined),
                  selectedIcon: Icon(Icons.download),
                  label: Text('Downloads'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),
          // Main content area takes remaining space
          Expanded(child: _buildCurrentView()),
        ],
      ),
      // Use BottomNavigationBar only on narrow screens
      bottomNavigationBar:
          !isWideScreen
              ? BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.public_outlined),
                    activeIcon: Icon(Icons.public),
                    label: 'Browser',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.download_outlined),
                    activeIcon: Icon(Icons.download),
                    label: 'Downloads',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings_outlined),
                    activeIcon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              )
              : null, // No bottom bar on wide screens
      // --- Floating Action Button for Browser Download ---
      floatingActionButton:
          _selectedIndex ==
                  0 // Show FAB only on Browser tab
              ? FloatingActionButton(
                onPressed: () {
                  // Trigger download dialog using the current browser URL
                  if (_currentBrowserUrl.isNotEmpty) {
                    _showDownloadQualityDialog(_currentBrowserUrl);
                  } else {
                    _showSnackBar(
                      "No URL loaded in the browser yet.",
                      isError: true,
                    );
                  }
                },
                tooltip: 'Download Media from Page',
                child: const Icon(Icons.download_for_offline),
              )
              : null, // No FAB on other screens
    );
  }

  // Show dialog to select download quality (Updated Styling)
  void _showDownloadQualityDialog(String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DownloadQuality selectedQuality =
            DownloadQuality.medium; // Default selection
        return StatefulBuilder(
          // Use StatefulBuilder to update dialog state
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ), // Modern shape
              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 10,
              ),
              actionsPadding: const EdgeInsets.all(16),
              title: const Text('Select Download Quality'),
              content: SingleChildScrollView(
                // Ensure content scrolls if needed
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Size column to its content
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'URL:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      url,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    // Use RadioListTile for better selection UI
                    ...DownloadQuality.values
                        .map(
                          (quality) => RadioListTile<DownloadQuality>(
                            title: Text(quality.displayName),
                            value: quality,
                            groupValue: selectedQuality,
                            onChanged: (DownloadQuality? value) {
                              if (value != null) {
                                setDialogState(() {
                                  // Update only the dialog's state
                                  selectedQuality = value;
                                });
                              }
                            },
                            contentPadding:
                                EdgeInsets.zero, // Remove default padding
                            activeColor: kPrimaryColor, // Use theme color
                          ),
                        )
                        .toList(),
                    const SizedBox(height: 15),
                    Text(
                      "Note: Quality selection is simulated. Audio extraction requires external tools not included. Downloads use sample files.",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.orange.shade800,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                  ),
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Start Download'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    _startDownload(
                      url,
                      selectedQuality,
                    ); // Initiate the download
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// --- Browser View Widget ---
class BrowserView extends StatefulWidget {
  final String initialUrl;
  final TextEditingController urlController;
  final Function(InAppWebViewController) onWebViewCreated;
  final Function(Uri?) onUrlChanged; // Callback for URL changes
  // Removed onDownloadRequested, as it's handled by the FAB now

  const BrowserView({
    super.key,
    required this.initialUrl,
    required this.urlController,
    required this.onWebViewCreated,
    required this.onUrlChanged,
  });

  @override
  State<BrowserView> createState() => _BrowserViewState();
}

class _BrowserViewState extends State<BrowserView> {
  InAppWebViewController? _webViewController;
  final GlobalKey _webViewKey = GlobalKey();
  double _progress = 0; // Web page loading progress

  // Modern WebView Settings
  InAppWebViewSettings settings = InAppWebViewSettings(
    useShouldOverrideUrlLoading: true, // Intercept navigation requests
    mediaPlaybackRequiresUserGesture: false, // Allow autoplay (use cautiously)
    allowsInlineMediaPlayback: true, // Allow inline video playback
    iframeAllowFullscreen: true, // Allow fullscreen iframes
    javaScriptEnabled: true, // Essential for modern websites
    supportZoom: true, // Allow pinch-to-zoom
    useHybridComposition:
        true, // Recommended for better performance/compatibility
    userAgent:
        "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Mobile Safari/537.36", // Example mobile UA
    // Improve initial load experience
    minimumFontSize: 10,
    loadsImagesAutomatically: true,
    // Security settings (adjust based on needs)
    // blockNetworkImage: false,
    // blockNetworkLoads: false,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Address Bar and Controls (Modernized)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          color:
              Theme.of(
                context,
              ).appBarTheme.backgroundColor, // Match AppBar color
          child: Row(
            children: [
              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => _webViewController?.goBack(),
                tooltip: "Back",
                splashRadius: 20,
              ),
              // Forward Button
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 20),
                onPressed: () => _webViewController?.goForward(),
                tooltip: "Forward",
                splashRadius: 20,
              ),
              // Reload Button
              IconButton(
                icon: const Icon(Icons.refresh, size: 22),
                onPressed: () => _webViewController?.reload(),
                tooltip: "Reload",
                splashRadius: 20,
              ),
              const SizedBox(width: 5),
              // URL Input Field
              Expanded(
                child: TextField(
                  controller: widget.urlController,
                  decoration: InputDecoration(
                    hintText: 'Enter URL or search...',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ), // Adjusted padding
                    isDense: true, // Make it more compact
                    fillColor:
                        Theme.of(context)
                            .colorScheme
                            .background, // Use background color for fill
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0), // Pill shape
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 1.5,
                      ), // Highlight on focus
                    ),
                  ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.go, // Use 'Go' action
                  onSubmitted: (url) => _loadUrl(url),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              // Go Button (optional, as Enter/Go on keyboard works)
              // IconButton(
              //    icon: const Icon(Icons.arrow_circle_right_outlined, size: 24),
              //    onPressed: () => _loadUrl(widget.urlController.text),
              //    tooltip: "Go",
              //    splashRadius: 20,
              //    color: kPrimaryColor,
              //  ),
            ],
          ),
        ),
        // Loading Progress Bar (Thinner and styled)
        SizedBox(
          height: 2, // Make progress thinner
          child:
              (_progress > 0 && _progress < 1.0)
                  ? LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      kPrimaryColor,
                    ),
                  )
                  : const SizedBox.shrink(), // Hide when not loading
        ),
        // Web View Area
        Expanded(
          child: InAppWebView(
            key: _webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(widget.initialUrl)),
            initialSettings: settings,
            onWebViewCreated: (controller) {
              _webViewController = controller;
              widget.onWebViewCreated(controller); // Notify parent
            },
            onLoadStart: (controller, url) {
              if (url != null) {
                widget.onUrlChanged(
                  url,
                ); // Update parent's state (which updates controller)
                if (mounted)
                  setState(() {
                    _progress = 0.05;
                  }); // Show progress immediately
              }
            },
            onLoadStop: (controller, url) async {
              if (url != null) {
                widget.onUrlChanged(url); // Ensure URL is correct
                if (mounted)
                  setState(() {
                    _progress = 1.0;
                  }); // Set progress to complete
              }
              // Add a small delay before resetting progress fully to ensure bar hides smoothly
              await Future.delayed(const Duration(milliseconds: 300));
              if (mounted)
                setState(() {
                  _progress = 0;
                });
            },
            onProgressChanged: (controller, progress) {
              if (mounted) {
                setState(() {
                  _progress = progress / 100.0;
                });
              }
            },
            onLoadError: (controller, url, code, message) {
              print("WebView Error: Code $code - $message URL: $url");
              // Optionally show an error message to the user within the WebView or via SnackBar
              if (mounted) {
                setState(() {
                  _progress = 0;
                }); // Stop progress bar on error
                // Example: Show error in SnackBar
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text("Failed to load page: $message"), backgroundColor: Colors.red)
                // );
              }
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              // Allows navigation within the webview
              var uri = navigationAction.request.url;
              if (uri != null) {
                // Optionally handle specific schemes like 'tel:', 'mailto:' differently
                print("Navigating to: $uri");
              }
              return NavigationActionPolicy.ALLOW;
            },
            // --- Download Handling within WebView ---
            // Limitation Reminder: Intercepting actual file downloads (<a> tags with download attr)
            // is complex. onDownloadStartRequest might capture some cases but isn't foolproof.
            onDownloadStartRequest: (controller, downloadStartRequest) async {
              print(
                "WebView download request detected: ${downloadStartRequest.url} (Suggested Filename: ${downloadStartRequest.suggestedFilename})",
              );
              // Show a message guiding the user to use the FAB instead.
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Download detected. Please use the main download (↓) button if you want to save this media.",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: kSecondaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: const EdgeInsets.all(10.0),
                  ),
                );
              }
              // To prevent the default browser download action (if possible, might not always work):
              // You might need platform-specific code or deeper plugin features.
              // For now, we just inform the user.
            },
          ),
        ),
      ],
    );
  }

  // Helper to load URL, adding https:// if missing and handling search
  void _loadUrl(String urlOrQuery) {
    Uri? uri = Uri.tryParse(urlOrQuery);
    String targetUrl;

    // Check if it's a valid URL (has scheme and host)
    if (uri != null && uri.hasScheme && uri.hasAuthority) {
      targetUrl = urlOrQuery;
    } else {
      // Assume it's a search query or needs https prepended
      if (!urlOrQuery.contains(' ') && urlOrQuery.contains('.')) {
        // Looks like a domain name without scheme
        targetUrl = 'https://$urlOrQuery';
      } else {
        // Treat as a search query for the default engine
        targetUrl =
            'https://duckduckgo.com/?q=${Uri.encodeComponent(urlOrQuery)}';
      }
    }

    _webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(targetUrl)));
    // Let the onUrlChanged callback update the text controller naturally
  }
}

// --- Downloads View Widget ---
class DownloadsView extends StatelessWidget {
  final List<DownloadItem> activeDownloads;
  final List<DownloadItem> completedDownloads;
  final Function(DownloadItem) onCancelDownload;
  final Function(DownloadItem) onRemoveDownload;
  final Function(DownloadItem) onRetryDownload; // Added retry callback

  const DownloadsView({
    super.key,
    required this.activeDownloads,
    required this.completedDownloads,
    required this.onCancelDownload,
    required this.onRemoveDownload,
    required this.onRetryDownload, // Receive retry callback
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Active and Completed tabs
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TabBar(
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'History'), // Renamed "Completed" to "History"
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Active Downloads List
                _buildDownloadList(
                  context,
                  activeDownloads,
                  isActiveList: true,
                  emptyMessage: 'No active downloads.',
                ),
                // Completed/History Downloads List
                _buildDownloadList(
                  context,
                  completedDownloads,
                  isActiveList: false,
                  emptyMessage: 'Download history is empty.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build a list view for downloads
  Widget _buildDownloadList(
    BuildContext context,
    List<DownloadItem> items, {
    required bool isActiveList,
    required String emptyMessage,
  }) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActiveList ? Icons.hourglass_empty : Icons.history_toggle_off,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 80,
      ), // Add padding for FAB overlap if necessary
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return DownloadListItem(
          item: item,
          onCancel:
              isActiveList &&
                      (item.status == DownloadStatus.downloading ||
                          item.status == DownloadStatus.queued)
                  ? () => onCancelDownload(item)
                  : null,
          onRemove: !isActiveList ? () => onRemoveDownload(item) : null,
          onRetry:
              !isActiveList &&
                      (item.status == DownloadStatus.failed ||
                          item.status == DownloadStatus.cancelled)
                  ? () => onRetryDownload(item) // Use the passed retry function
                  : null,
          // onOpenFile: !isActiveList && item.status == DownloadStatus.completed
          //    ? () => _openFile(context, item) // Add file opening logic later if needed
          //    : null,
        );
      },
    );
  }

  // --- TODO: File Opening Logic (Platform Specific - Requires Package) ---
  // Future<void> _openFile(BuildContext context, DownloadItem item) async {
  //   // ... (Implementation requires 'open_file_plus' or similar)
  //   // ... Show appropriate messages if opening fails or isn't supported
  // }
}

// --- Individual Download List Item Widget (Modernized) ---
class DownloadListItem extends StatelessWidget {
  final DownloadItem item;
  final VoidCallback? onCancel; // For active downloads
  final VoidCallback? onRemove; // For completed/failed downloads
  final VoidCallback? onRetry; // For failed/cancelled downloads
  // final VoidCallback? onOpenFile; // For completed downloads

  const DownloadListItem({
    super.key,
    required this.item,
    this.onCancel,
    this.onRemove,
    this.onRetry,
    // this.onOpenFile,
  });

  @override
  Widget build(BuildContext context) {
    IconData statusIconData;
    Color statusColor;
    String statusText = item.status.displayName;
    bool showProgress = item.status == DownloadStatus.downloading;

    switch (item.status) {
      case DownloadStatus.queued:
        statusIconData = Icons.pending_outlined;
        statusColor = Colors.grey.shade600;
        break;
      case DownloadStatus.downloading:
        // Use a dynamic icon based on progress? (Could be complex)
        statusIconData = Icons.downloading_rounded; // Or Icons.arrow_downward
        statusColor = kPrimaryColor; // Use theme primary color
        statusText = '${(item.progress * 100).toStringAsFixed(0)}%';
        break;
      case DownloadStatus.completed:
        statusIconData = Icons.check_circle_outline_rounded;
        statusColor = Colors.green.shade600;
        break;
      case DownloadStatus.failed:
        statusIconData = Icons.error_outline_rounded;
        statusColor = Colors.red.shade600;
        break;
      case DownloadStatus.cancelled:
        statusIconData = Icons.cancel_outlined;
        statusColor = Colors.orange.shade700;
        break;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            // Status Icon Column
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(statusIconData, color: statusColor, size: 28),
                if (showProgress) const SizedBox(height: 4),
                if (showProgress)
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Details Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.filename,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                    ), // Slightly smaller title
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (!showProgress) // Show status text if not showing progress %
                    Text(
                      'Status: ${item.status.displayName}${item.error != null ? " (${item.error})" : ""}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (showProgress) // Show linear progress bar
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
                      child: LinearProgressIndicator(
                        value: item.progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                        minHeight: 5, // Slightly thicker bar
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        item.quality == DownloadQuality.audioOnly
                            ? Icons.music_note_outlined
                            : Icons.videocam_outlined,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.quality.displayName,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                  if (item.filePath != null && !kIsWeb) // Show path on non-web
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Saved to: ...${item.filePath!.length > 30 ? item.filePath!.substring(item.filePath!.length - 30) : item.filePath}', // Show tail of path
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Action Buttons Column
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onCancel != null)
                  _buildActionButton(
                    icon: Icons.cancel_presentation_rounded,
                    tooltip: 'Cancel Download',
                    onPressed: onCancel,
                    color: Colors.redAccent.shade400,
                  ),
                if (onRetry != null)
                  _buildActionButton(
                    icon: Icons.refresh_rounded,
                    tooltip: 'Retry Download',
                    onPressed: onRetry,
                    color: kPrimaryColor,
                  ),
                // if (onOpenFile != null)
                //    _buildActionButton(
                //       icon: Icons.folder_open_outlined,
                //       tooltip: 'Open Location', // Changed tooltip
                //       onPressed: onOpenFile,
                //       color: Colors.green.shade700,
                //     ),
                if (onRemove != null)
                  _buildActionButton(
                    icon: Icons.delete_sweep_outlined, // More indicative icon
                    tooltip: 'Remove from History',
                    onPressed: onRemove,
                    color: Colors.grey.shade600,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build consistent action buttons
  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 22,
      tooltip: tooltip,
      onPressed: onPressed,
      color: color,
      splashRadius: 20,
      visualDensity: VisualDensity.compact, // Make buttons take less space
      padding: const EdgeInsets.all(6), // Reduce padding
      constraints: const BoxConstraints(), // Remove default min constraints
    );
  }
}

// --- Settings View Widget (Modernized) ---
class SettingsView extends StatefulWidget {
  final AppSettings currentSettings;
  final Function(AppSettings) onSettingsChanged;

  const SettingsView({
    super.key,
    required this.currentSettings,
    required this.onSettingsChanged,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late AppSettings _editableSettings;
  final List<int> _concurrentOptions = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
  ]; // Expanded Options

  @override
  void initState() {
    super.initState();
    // Create a mutable copy of the settings to allow editing
    _editableSettings = widget.currentSettings.copyWith();
  }

  // Function to pick a directory for downloads
  Future<void> _pickDownloadDirectory() async {
    // **Limitation Note:** Directory pickers might have limitations or different
    // behaviors across platforms (especially web). `file_picker` handles many cases.
    if (kIsWeb) {
      // Directory picking is not reliably supported on web
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Directory selection is not available on the web platform.",
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.all(10.0),
        ),
      );
      return;
    }

    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select Download Folder',
        lockParentWindow: true, // Improve dialog behavior on desktop
      );

      if (selectedDirectory != null && mounted) {
        // Update local state first for immediate UI feedback
        setState(() {
          _editableSettings = _editableSettings.copyWith(
            downloadPath: selectedDirectory,
          );
        });
        // Then notify the parent widget to apply the change
        widget.onSettingsChanged(_editableSettings);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Download path set to: $selectedDirectory"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.all(10.0),
          ),
        );
      }
    } catch (e) {
      print("Error picking directory: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Could not select directory: Check permissions or try again.",
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.all(10.0),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // --- Concurrent Downloads Setting ---
        Text(
          'Download Options',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: kPrimaryColor),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 2, // Slightly more emphasis for settings cards
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Concurrent Downloads:'),
                // Dropdown with modern styling
                DropdownButtonHideUnderline(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.background, // Use background color
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButton<int>(
                      value: _editableSettings.maxConcurrentDownloads,
                      items:
                          _concurrentOptions.map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _editableSettings = _editableSettings.copyWith(
                              maxConcurrentDownloads: newValue,
                            );
                          });
                          // Notify parent widget of the change
                          widget.onSettingsChanged(_editableSettings);
                        }
                      },
                      dropdownColor:
                          Theme.of(
                            context,
                          ).colorScheme.surface, // Match card background
                      style: Theme.of(context).textTheme.bodyMedium,
                      iconEnabledColor: kPrimaryColor,
                      focusColor:
                          Colors
                              .transparent, // Remove focus highlight if desired
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // --- Download Path Setting ---
        Text(
          'Storage',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: kPrimaryColor),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Download Location',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  _editableSettings.downloadPath,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.folder_open_outlined, size: 20),
                    label: const Text('Change Path'),
                    onPressed:
                        kIsWeb
                            ? null
                            : _pickDownloadDirectory, // Disable button on web
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          kIsWeb
                              ? Colors.grey[300]
                              : Theme.of(context).colorScheme.secondary,
                      foregroundColor:
                          kIsWeb
                              ? Colors.grey[600]
                              : Theme.of(context).colorScheme.onSecondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ), // Smaller padding
                    ),
                  ),
                ),
                if (kIsWeb)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Note: Custom download paths are not supported on the web platform. Downloads typically go to the browser's default download location.",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 30),
        // --- About Section (Example) ---
        Center(
          child: Text(
            '$kAppName v1.0.0', // Example version
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

// --- Data Models ---

// Represents user-configurable settings
@immutable // Mark as immutable as good practice
class AppSettings {
  final int maxConcurrentDownloads;
  final String downloadPath;

  const AppSettings({
    this.maxConcurrentDownloads = 3, // Default value
    this.downloadPath = '/downloads', // Default path
  });

  // Helper method to create a copy with potential changes
  AppSettings copyWith({int? maxConcurrentDownloads, String? downloadPath}) {
    return AppSettings(
      maxConcurrentDownloads:
          maxConcurrentDownloads ?? this.maxConcurrentDownloads,
      downloadPath: downloadPath ?? this.downloadPath,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          maxConcurrentDownloads == other.maxConcurrentDownloads &&
          downloadPath == other.downloadPath;

  @override
  int get hashCode => maxConcurrentDownloads.hashCode ^ downloadPath.hashCode;
}

// Represents a single download item
class DownloadItem {
  final String id;
  final String
  url; // Original user-requested URL (might differ from actual download URL)
  final String filename;
  final DownloadQuality quality;
  DownloadStatus status;
  double progress;
  String? error; // Store error message on failure
  String? filePath; // Store the final path where the file is saved
  CancelToken? cancelToken; // To allow cancellation via Dio

  DownloadItem({
    required this.id,
    required this.url,
    required this.filename,
    required this.quality,
    this.status = DownloadStatus.queued,
    this.progress = 0.0,
    this.error,
    this.filePath,
    this.cancelToken,
  });
}

// Enum for download status
enum DownloadStatus {
  queued('Queued'),
  downloading('Downloading'),
  completed('Completed'),
  failed('Failed'),
  cancelled('Cancelled');

  const DownloadStatus(this.displayName);
  final String displayName;
}

// Enum for download quality options
enum DownloadQuality {
  low('Low Quality'), // e.g., 360p video / low bitrate audio
  medium('Medium Quality'), // e.g., 720p video / standard bitrate audio
  high('High Quality'), // e.g., 1080p video / high bitrate audio
  audioOnly('Audio Only'); // e.g., MP3/M4A (Simulated)

  const DownloadQuality(this.displayName);
  final String displayName;
}

/*
--- Dependencies Required for this Code ---

Add these to your `pubspec.yaml` file:

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6 # Standard icons
  flutter_inappwebview: ^6.0.0 # Cross-platform WebView (check for latest version)
  path_provider: ^2.1.1 # To get system directories (check for latest version)
  file_picker: ^6.1.1 # For picking files/directories (check for latest version)
  dio: ^5.4.0 # For network requests/downloads (check for latest version)

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0 # Recommended lint rules

--- Platform Specific Setup ---

**(Ensure these are correctly configured as mentioned in the previous response)**

1.  **Android (`android/app/src/main/AndroidManifest.xml`):**
    *   Internet permission: `<uses-permission android:name="android.permission.INTERNET"/>`
    *   (Optional) Cleartext Traffic for HTTP WebView: `android:usesCleartextTraffic="true"` in `<application>`.
    *   (Optional) Legacy Storage Permissions (if targeting older Android versions):
        `<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>`
        `<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>`
        (Modern Android uses Scoped Storage, `path_provider` helps manage accessible paths).

2.  **iOS (`ios/Runner/Info.plist`):**
    *   Allow Arbitrary Loads for WebView:
      ```xml
      <key>NSAppTransportSecurity</key>
      <dict>
          <key>NSAllowsArbitraryLoads</key><true/>
          <key>NSAllowsArbitraryLoadsInWebContent</key><true/>
      </dict>
      ```
    *   Enable Embedded Views Preview: `<key>io.flutter.embedded_views_preview</key><true/>`
    *   (Optional) Permissions for broader file access (if needed beyond app's sandbox): `NSDocumentsFolderUsageDescription`, `LSSupportsOpeningDocumentsInPlace`, `UIFileSharingEnabled`.

3.  **Desktop (Windows/macOS/Linux):**
    *   `flutter_inappwebview` requires platform-specific setup. **Consult its documentation.**
    *   File system access is generally less restricted, but path handling needs care.

**Remember to run `flutter pub get` after editing `pubspec.yaml`.**

--- Limitations & Notes ---

*   **Media Parsing/Quality:** This app **simulates** quality selection using sample files. Real extraction from sites like YouTube is complex, requires dedicated libraries (e.g., `youtube_explode_dart`), and is prone to breaking.
*   **Audio Extraction:** Converting video to audio (MP4 -> MP3) needs external tools (like `ffmpeg`) integrated natively.
*   **WebView Downloads:** Intercepting all web-initiated downloads (`<a download>`) isn't fully handled. The FAB is the primary download trigger.
*   **Error Handling:** Improved, but real-world apps need more robust handling of network states, disk space, permissions, etc.
*   **Persistence:** Download history and settings are lost on app close. Use `shared_preferences` or a database for persistence.
*   **Background Downloads:** Not implemented. Use packages like `flutter_downloader` for reliable background operation (requires native setup).
*   **Web Platform:** Directory selection is disabled, file system access is limited. Downloads go to browser defaults.
*   **File Opening:** Requires a platform-specific package like `open_file_plus`.
*   **Sample URLs:** Uses archive.org URLs. If they become unavailable, downloads will fail (e.g., 404 error). The code now handles 404s more gracefully than before.
*/
