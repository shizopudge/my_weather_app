abstract class SqfliteEvent {}

class SqfliteGetLocationsEvent extends SqfliteEvent {}

class SqfliteGetFavoriteLocationEvent extends SqfliteEvent {}

class SqfliteOnSetLocationEvent extends SqfliteEvent {
  final String city;
  final String country;

  SqfliteOnSetLocationEvent(this.city, this.country);
}

class SqfliteAddLocationToFavoriteEvent extends SqfliteEvent {
  final String city;
  final String country;
  final int id;

  SqfliteAddLocationToFavoriteEvent(this.city, this.country, this.id);
}

class SqfliteDeleteLocationEvent extends SqfliteEvent {
  final int id;

  SqfliteDeleteLocationEvent(this.id);
}
