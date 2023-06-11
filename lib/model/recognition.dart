// ignore_for_file: file_names

import 'dart:ui';

class Recognition {
  String name;
  Rect location;
  List<double> embeddings;
  double distance;
  
  Recognition(this.name, this.location, this.embeddings, this.distance);

  @override
  String toString() {
    return 'Recognition: { name: $name, location: $location, embeddings: $embeddings, distance: $distance }';
  }
}
