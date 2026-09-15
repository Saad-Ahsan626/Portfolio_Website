class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.kind,
    required this.year,
    required this.description,
    required this.techStack,
    this.githubUrl,
    this.liveUrl,
    this.imageUrl,
    required this.headline,
    required this.overview,
    required this.facts,
    required this.architecture,
    required this.features,
    required this.screens,
    required this.challenge,
    required this.approach,
  });

  /// URL slug, e.g. `/projects/campus-pulse`.
  final String id;
  final String title;

  /// Label for the case-study switcher tabs.
  final String shortTitle;
  final String kind;
  final String year;
  final String description;
  final List<String> techStack;

  /// Null when the repository is private — the source button is hidden.
  final String? githubUrl;
  final String? liveUrl;
  final String? imageUrl;

  // ── Case study ──
  final String headline;
  final String overview;
  final List<ProjectFact> facts;
  final List<String> architecture;
  final List<ProjectFeature> features;
  final List<ProjectScreen> screens;
  final String challenge;
  final String approach;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json['id'] as String,
        title: json['title'] as String,
        shortTitle: json['shortTitle'] as String,
        kind: json['kind'] as String,
        year: json['year'] as String,
        description: json['description'] as String,
        techStack: List<String>.from(json['techStack'] as List),
        githubUrl: json['githubUrl'] as String?,
        liveUrl: json['liveUrl'] as String?,
        imageUrl: json['imageUrl'] as String?,
        headline: json['headline'] as String,
        overview: json['overview'] as String,
        facts: (json['facts'] as List)
            .map((e) => ProjectFact.fromJson(e as Map<String, dynamic>))
            .toList(),
        architecture: List<String>.from(json['architecture'] as List),
        features: (json['features'] as List)
            .map((e) => ProjectFeature.fromJson(e as Map<String, dynamic>))
            .toList(),
        screens: (json['screens'] as List)
            .map((e) => ProjectScreen.fromJson(e as Map<String, dynamic>))
            .toList(),
        challenge: json['challenge'] as String,
        approach: json['approach'] as String,
      );
}

/// One cell of the meta strip under a case-study title (Role, Platform, …).
class ProjectFact {
  const ProjectFact({required this.label, required this.value});

  final String label;
  final String value;

  factory ProjectFact.fromJson(Map<String, dynamic> json) => ProjectFact(
        label: json['label'] as String,
        value: json['value'] as String,
      );
}

class ProjectFeature {
  const ProjectFeature({required this.title, required this.body});

  final String title;
  final String body;

  factory ProjectFeature.fromJson(Map<String, dynamic> json) => ProjectFeature(
        title: json['title'] as String,
        body: json['body'] as String,
      );
}

enum ScreenDevice { phone, browser }

class ProjectScreen {
  const ProjectScreen({
    required this.label,
    required this.image,
    this.device = ScreenDevice.phone,
    this.aspectRatio,
    this.url,
  });

  final String label;
  final String image;

  /// Which frame the screenshot is shown in on the case-study page.
  final ScreenDevice device;

  /// Width ÷ height of a browser screenshot, so its frame is sized before the
  /// image loads.
  final double? aspectRatio;

  /// Text in the browser frame's address bar, e.g. "/portal".
  final String? url;

  bool get isBrowser => device == ScreenDevice.browser;

  factory ProjectScreen.fromJson(Map<String, dynamic> json) => ProjectScreen(
        label: json['label'] as String,
        image: json['image'] as String,
        device: json['device'] == 'browser'
            ? ScreenDevice.browser
            : ScreenDevice.phone,
        aspectRatio: (json['aspectRatio'] as num?)?.toDouble(),
        url: json['url'] as String?,
      );
}
