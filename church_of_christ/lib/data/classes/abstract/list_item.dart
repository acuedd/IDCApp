

import 'package:flutter/material.dart';

abstract class ListItem {
  Object getWidget(context, Orientation orientation, {Function onTapCallback});
}