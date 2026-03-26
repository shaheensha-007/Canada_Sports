class GamelobbyModel {
  GamelobbyModel({
      this.gameId, 
      this.name, 
      this.urlThumb, 
      this.groupname, 
      this.sort, 
      this.blockedCountries, 
      this.category, 
      this.enabled, 
      this.freebetSupport, 
      this.gameCode, 
      this.platforms, 
      this.product, 
      this.gamecategory, 
      this.statusId, 
      this.minAmount, 
      this.maxAmount,});

  GamelobbyModel.fromJson(dynamic json) {
    gameId = json['game_id'];
    name = json['name'];
    urlThumb = json['url_thumb'];
    groupname = json['groupname'];
    sort = json['sort'];
    blockedCountries = json['blocked_countries'];
    category = json['category'];
    enabled = json['enabled'];
    freebetSupport = json['freebet_support'];
    gameCode = json['game_code'];
    platforms = json['platforms'];
    product = json['product'];
    gamecategory = json['gamecategory'];
    statusId = json['statusId'];
    minAmount = json['MinAmount'];
    maxAmount = json['MaxAmount'];
  }
  int? gameId;
  String? name;
  String? urlThumb;
  String? groupname;
  int? sort;
  dynamic blockedCountries;
  String? category;
  bool? enabled;
  bool? freebetSupport;
  String? gameCode;
  int? platforms;
  String? product;
  String? gamecategory;
  int? statusId;
  double? minAmount;
  double? maxAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['game_id'] = gameId;
    map['name'] = name;
    map['url_thumb'] = urlThumb;
    map['groupname'] = groupname;
    map['sort'] = sort;
    map['blocked_countries'] = blockedCountries;
    map['category'] = category;
    map['enabled'] = enabled;
    map['freebet_support'] = freebetSupport;
    map['game_code'] = gameCode;
    map['platforms'] = platforms;
    map['product'] = product;
    map['gamecategory'] = gamecategory;
    map['statusId'] = statusId;
    map['MinAmount'] = minAmount;
    map['MaxAmount'] = maxAmount;
    return map;
  }

}