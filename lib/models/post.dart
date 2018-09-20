// *********************************************************
// * Copyright (C) 2018 Paul Hammant <paul@hammant.org>    *
// *                                                       *
// * All rights reserved. This file is proprietary and     *
// * confidential and can not be copied and/or distributed *
// * without the express permission of Paul Hammant        *
// *********************************************************

class Post {
  final String name;
  final int times;
  final int lastActive;
  final String pic;

  Post({this.name, this.times, this.lastActive, this.pic});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        name: json['name'],
        times: json['times'],
        lastActive: json['last_active'],
        pic: json['pic']);
  }
}