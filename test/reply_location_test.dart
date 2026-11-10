import 'package:PiliPlus/utils/reply_location.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('comment location drops the IP prefix', () {
    expect(replyLocationLabel('IP属地：上海'), '上海');
    expect(replyLocationLabel('IP属地:北京'), '北京');
    expect(replyLocationLabel('属地：广东'), '广东');
    expect(replyLocationLabel('浙江'), '浙江');
    expect(replyLocationLabel('  IP属地：  '), '');
  });
}
