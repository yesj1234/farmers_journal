class DefaultImage {
  String? downloadURL;
  DefaultImage({required this.downloadURL});

  factory DefaultImage.fromJson(Map<String, dynamic> data) {
    final downloadURL = data['downloadURL'];
    return DefaultImage(downloadURL: downloadURL);
  }
}
