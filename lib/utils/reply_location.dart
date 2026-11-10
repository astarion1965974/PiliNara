/// Bilibili sends locations as `IP属地：上海`. Comments should show only the place.
String replyLocationLabel(String raw) {
  var text = raw.trim();
  const prefixes = ['IP属地：', 'IP属地:', '属地：', '属地:'];
  for (final prefix in prefixes) {
    if (text.startsWith(prefix)) {
      text = text.substring(prefix.length).trim();
      break;
    }
  }
  return text;
}
