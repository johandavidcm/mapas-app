// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromJson(jsonString);

import 'dart:convert';

SearchResponse searchResponseFromJson(String str) =>
    SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
  SearchResponse({
    this.type,
    this.query,
    this.features,
    this.attribution,
  });

  String type;
  List<String> query;
  List<Feature> features;
  String attribution;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        type: json["type"],
        query: List<String>.from(json["query"].map((x) => x)),
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "query": List<dynamic>.from(query.map((x) => x)),
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "attribution": attribution,
      };
}

class Feature {
  Feature({
    this.id,
    this.type,
    this.placeType,
    this.relevance,
    this.properties,
    this.textEs,
    this.languageEs,
    this.placeNameEs,
    this.text,
    this.language,
    this.placeName,
    this.center,
    this.geometry,
    this.context,
  });

  String id;
  String type;
  List<String> placeType;
  int relevance;
  Properties properties;
  String textEs;
  Language languageEs;
  String placeNameEs;
  String text;
  Language language;
  String placeName;
  List<double> center;
  Geometry geometry;
  List<Context> context;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"],
        properties: Properties.fromJson(json["properties"]),
        textEs: json["text_es"],
        languageEs: json["language_es"] == null
            ? null
            : languageValues.map[json["language_es"]],
        placeNameEs: json["place_name_es"],
        text: json["text"],
        language: json["language"] == null
            ? null
            : languageValues.map[json["language"]],
        placeName: json["place_name"],
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        context:
            List<Context>.from(json["context"].map((x) => Context.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "relevance": relevance,
        "properties": properties.toJson(),
        "text_es": textEs,
        "language_es":
            languageEs == null ? null : languageValues.reverse[languageEs],
        "place_name_es": placeNameEs,
        "text": text,
        "language": language == null ? null : languageValues.reverse[language],
        "place_name": placeName,
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toJson(),
        "context": List<dynamic>.from(context.map((x) => x.toJson())),
      };
}

class Context {
  Context({
    this.id,
    this.wikidata,
    this.textEs,
    this.languageEs,
    this.text,
    this.language,
    this.shortCode,
  });

  String id;
  String wikidata;
  String textEs;
  Language languageEs;
  String text;
  Language language;
  ShortCode shortCode;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        wikidata: json["wikidata"],
        textEs: json["text_es"],
        languageEs: languageValues.map[json["language_es"]],
        text: json["text"],
        language: languageValues.map[json["language"]],
        shortCode: json["short_code"] == null
            ? null
            : shortCodeValues.map[json["short_code"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "wikidata": wikidata,
        "text_es": textEs,
        "language_es": languageValues.reverse[languageEs],
        "text": text,
        "language": languageValues.reverse[language],
        "short_code":
            shortCode == null ? null : shortCodeValues.reverse[shortCode],
      };
}

enum Language { ES }

final languageValues = EnumValues({"es": Language.ES});

enum ShortCode { CO_ANT, CO }

final shortCodeValues =
    EnumValues({"co": ShortCode.CO, "CO-ANT": ShortCode.CO_ANT});

class Geometry {
  Geometry({
    this.coordinates,
    this.type,
  });

  List<double> coordinates;
  String type;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "type": type,
      };
}

class Properties {
  Properties({
    this.wikidata,
    this.category,
    this.landmark,
    this.foursquare,
    this.address,
  });

  String wikidata;
  String category;
  bool landmark;
  String foursquare;
  String address;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        wikidata: json["wikidata"] == null ? null : json["wikidata"],
        category: json["category"],
        landmark: json["landmark"],
        foursquare: json["foursquare"],
        address: json["address"] == null ? null : json["address"],
      );

  Map<String, dynamic> toJson() => {
        "wikidata": wikidata == null ? null : wikidata,
        "category": category,
        "landmark": landmark,
        "foursquare": foursquare,
        "address": address == null ? null : address,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
