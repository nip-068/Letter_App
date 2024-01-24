import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMassage {
  final String _fromUserId;
  final String _toUserId;
  final String _message;
  final bool _isMyMessage;
  final Timestamp? _date;

  ChatMassage(this._fromUserId, this._toUserId, this._message, this._isMyMessage, this._date);
  Map<String, dynamic> toMap() {
    return {
      'fromUserId' : _fromUserId,
      'toUserId' : _toUserId,
      'massage' : _message,
      'isMyMessage' : _isMyMessage,
      'date' : _date ?? FieldValue.serverTimestamp()
    };

  }

  ChatMassage.fromMap(Map<String, dynamic> map):
        _fromUserId = map['fromUserId'],
        _toUserId = map['toUserId'],
        _message = map['massage'],
        _isMyMessage = map['isMyMessage'],
        _date = map['date'];


  @override
  String toString() {
    return 'ChatMassage{_fromUserId: $_fromUserId, _toUserId: $_toUserId, _isMyMessage: $_isMyMessage, _date: $_date}';
  }

  Timestamp? get date => _date;

  bool get isMyMessage => _isMyMessage;

  String get toUserId => _toUserId;

  String get fromUserId => _fromUserId;

  String get message => _message;
}