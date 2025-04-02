import 'package:flutter/material.dart';
import 'package:project_emp/data/enum/priority.dart';
import 'package:project_emp/extensions/string_extensions.dart'; 

class PriorityBadge extends StatelessWidget {
  final Priorities status;
  PriorityBadge({super.key, required this.status});

  final statusStyles = {
    'urgent': {
      'textColor': Color(0xffd32f2f), // Brighter red for urgency
      'backgroundColor': Color(0xffffebee), // Light red background
    },
    'high': {
      'textColor': Color(0xfff57c00), // Deep orange for high priority
      'backgroundColor': Color(0xfffff3e0), // Light orange background
    },
    'medium': {
      'textColor': Color(0xff388e3c), // Dark green for medium priority
      'backgroundColor': Color(0xffe8f5e9), // Light green background
    },
    'low': {
      'textColor': Color(0xff1976d2), // Blue for low priority
      'backgroundColor': Color(0xffe3f2fd), // Light blue background
    },
  };

  @override
  Widget build(BuildContext context) {
    return Badge(
      textColor:
          (() {
            // final statusStyles = {
            //   'urgent': {
            //     'textColor': Color(0xffb31412),
            //     'backgroundColor': Color(0xfffce8e6),
            //   },
            //   'high': {
            //     'textColor': Color(0xff3c4043),
            //     'backgroundColor': Color(0xfffef7e0),
            //   },
            //   'medium': {
            //     'textColor': Color(0xff188038),
            //     'backgroundColor': Color(0xffe6f4ea),
            //   },
            //   'low': {
            //     'textColor': Color(0xff3c4043),
            //     'backgroundColor': Color(0xfffef7e0),
            //   },
            // };
            final defaultStyle = {
              'textColor': Color(0xff3c4043),
              'backgroundColor': Color(0xfffef7e0),
            };
            final style = statusStyles[status.name.toString()] ?? defaultStyle;
            return style['textColor'];
          })(),
      backgroundColor:
          (() {
            // final statusStyles = {
            //   'urgent': {
            //     'textColor': Color(0xffb31412),
            //     'backgroundColor': Color(0xfffce8e6),
            //   },
            //   'high': {
            //     'textColor': Color(0xff3c4043),
            //     'backgroundColor': Color(0xfffef7e0),
            //   },
            //   'medium': {
            //     'textColor': Color(0xff188038),
            //     'backgroundColor': Color(0xffe6f4ea),
            //   },
            //   'low': {
            //     'textColor': Color(0xff3c4043),
            //     'backgroundColor': Color(0xfffef7e0),
            //   },
            // };
            final defaultStyle = {
              'textColor': Color(0xff3c4043),
              'backgroundColor': Color(0xfff8f9fa),
            };
            final style = statusStyles[status.name.toString()] ?? defaultStyle;
            return style['backgroundColor'];
          })(),
      label: Text((status.name.toString().toTitleCase())),
    );
  }
}
