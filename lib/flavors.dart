enum Flavor {
  dev,
  prod,
  staging,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Calculator Dev';
      case Flavor.prod:
        return 'Calculator';
      case Flavor.staging:
        return 'Calculator Staging';
      default:
        return 'title';
    }
  }

}
