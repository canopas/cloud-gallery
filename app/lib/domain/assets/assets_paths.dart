class Assets {
  static PathImages images = PathImages();
}

class PathImages {
  String get appIcon => 'assets/images/app_logo.png';

  PathIcons get icons => PathIcons();
}

class PathIcons {
  String get googleDrive => 'assets/images/icons/google-drive.svg';
  String get dropbox => 'assets/images/icons/dropbox.svg';
}
