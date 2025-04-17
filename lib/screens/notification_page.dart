import 'package:ducanherp/blocs/notification/notification_bloc.dart';
import 'package:ducanherp/blocs/notification/notification_event.dart';
import 'package:ducanherp/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import '../../models/notification_model.dart';

class NotificationPage extends StatefulWidget {
  final List<NotificationModel> notifi;

  const NotificationPage({super.key, required this.notifi});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Thông báo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: widget.notifi.isEmpty
            ? Center(child: Text('Không có thông báo nào'))
            : ListView.builder(
                itemCount: widget.notifi.length,
                itemBuilder: (context, index) {
                  NotificationModel item = widget.notifi[index];
                  return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: item.isRead == 1 ? Colors.grey[200] : Colors.white,
                      child: ExpansionTile(
                        onExpansionChanged:(expanded) {
                          if (item.isRead == 0) {
                            item.isRead = 1;
                            context.read<NotificationBloc>().add(UpdateNotificationEvent(notifi: item));
                            setState(() {
                              widget.notifi[index] = item;
                            });
                          }
                        },
                        leading: CircleAvatar(
                          backgroundColor: item.isRead == 1 ? Colors.grey : Colors.blue,
                          child: Icon(Icons.notifications, color: Colors.white),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.subject,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: item.isRead == 1 ? Colors.grey : Colors.black,
                              ),
                            ),
                            Text(
                              '${item.receiver}',
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Text(
                              'Ngày tạo: ${DateUtilsHelper.formatDateCustom(item.createAt, "mm:HH dd/MM/yy")}',
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                        children: [
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Html(
                                    data: """
                                      <style>
                                        table, th, td {
                                          border: 1px solid #ccc;
                                          border-collapse: collapse;
                                        }
                                        th, td {
                                          padding: 8px;
                                          text-align: left;
                                        }
                                      </style>
                                      ${item.content.replaceAll("</h3>", "</h3><br>")}
                                    """,
                                    extensions: const [
                                      TableHtmlExtension(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    );
                },
              ),
      ),
    );
  }
}
