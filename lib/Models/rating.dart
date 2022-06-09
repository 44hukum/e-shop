

class RatingModel {
  String userid;
  String rating;
  String productId;
  RatingModel(
      {this.userid,this.productId,this.rating});

  RatingModel.fromJson(Map<String, dynamic> json)
  {
    userid = json['userid'];
    productId = json['productId'];
    rating = json['rating'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['rating'] = this.rating;
    data['productid'] = this.productId;

    return data;
  }
}


