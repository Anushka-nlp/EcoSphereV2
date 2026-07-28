class UISettings {
  double glowMultiplier;
  double radiusMultiplier;
  bool saikouLayout;
  double tabBarHeight;
  double tabBarWidth;
  double tabBarRoundness;
  bool compactCards;
  double cardRoundness;
  double blurMultipler;
  int animationDuration;
  bool translucentTabBar;
  double glowDensity;
  Map<String, bool> homePageCards;
  bool enableAnimation;
  bool disableGradient;
  Map<String, bool> homePageCardsMal;
  int cardStyle;
  int historyCardStyle;
  bool liquidMode;
  String liquidBackgroundPath;
  bool retainOriginalColor;
  bool usePosterColor;
  bool enablePosterKenBurns;
  int carouselStyle;
  bool showContinueWatchingCard;
  bool useLegacyHeader;
  bool useGrainTexture;
  double grainIntensity;
  bool enableImmersiveMode;

  UISettings({
    this.glowMultiplier = 1.0,
    this.radiusMultiplier = 1.0,
    this.saikouLayout = false,
    this.tabBarHeight = 50.0,
    this.tabBarWidth = 180.0,
    this.tabBarRoundness = 10.0,
    this.compactCards = false,
    this.cardRoundness = 1.0,
    this.blurMultipler = 1.0,
    this.animationDuration = 200,
    this.glowDensity = 0.3,
    this.translucentTabBar = true,
    Map<String, bool>? homePageCards,
    Map<String, bool>? homePageCardsMal,
    this.enableAnimation = true,
    this.disableGradient = false,
    this.cardStyle = 2,
    this.historyCardStyle = 0,
    this.liquidMode = true,
    this.retainOriginalColor = false,
    this.liquidBackgroundPath = '',
    this.usePosterColor = false,
    this.enablePosterKenBurns = true,
    this.carouselStyle = 0,
    this.showContinueWatchingCard = true,
    this.useLegacyHeader = false,
    this.useGrainTexture = false,
    this.grainIntensity = 0.05,
    this.enableImmersiveMode = false,
  })  : homePageCards = homePageCards ?? {},
        homePageCardsMal = homePageCardsMal ?? {};

  void normalizeMaps() {}

  factory UISettings.fromDB() {
    return UISettings();
  }
}
