import 'package:flutter/material.dart';

class TaskModel {
  String visitId,
      homeBobEmployeeId,
      houseOwnerId,
      startTimeUtc,
      endTimeUtc,
      title,
      rememberToday,
      houseOwnerFirstName,
      houseOwnerLastName,
      houseOwnerMobilePhone,
      houseOwnerAddress,
      houseOwnerZip,
      houseOwnerCity,
      rememberAlways,
      professional,
      visitState,
      expectedTime,
      houseOwnerAssets,
      visitAssets,
      visitMessages;
  List<SubTaskModel> tasks;
  int stateOrder, visitTimeUsed;
  double houseOwnerLatitude, houseOwnerLongitude;
  bool isBlocked, isReviewed, isFirstVisit, isManual, isSubscriber;
  TaskModel({
    this.visitId,
    this.homeBobEmployeeId,
    this.houseOwnerId,
    this.isBlocked,
    this.startTimeUtc,
    this.endTimeUtc,
    this.title,
    this.rememberToday,
    this.isReviewed,
    this.isFirstVisit,
    this.isManual,
    this.visitTimeUsed,
    this.houseOwnerFirstName,
    this.houseOwnerLastName,
    this.houseOwnerMobilePhone,
    this.houseOwnerAddress,
    this.houseOwnerZip,
    this.houseOwnerCity,
    this.houseOwnerLatitude,
    this.houseOwnerLongitude,
    this.isSubscriber,
    this.rememberAlways,
    this.professional,
    this.visitState,
    this.stateOrder,
    this.expectedTime,
    this.tasks,
    // this.houseOwnerAssets,
    // this.visitAssets,
    // this.visitMessages,
  });
}

class SubTaskModel {
  String taskId,
      title,
      paymentTypeId,
      createDateUtc,
      lastUpdateDateUtc,
      paymentTypes;
  bool isTemplate;
  int timesInMinutes;
  double price;

  SubTaskModel({
    this.taskId,
    this.title,
    this.isTemplate,
    this.timesInMinutes,
    this.price,
    this.paymentTypeId,
    this.createDateUtc,
    this.lastUpdateDateUtc,
    this.paymentTypes,
  });
}
