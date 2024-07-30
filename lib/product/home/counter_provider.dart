// counter_provider.dart

// StateProvider를 사용하여 상태 관리
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider<int>((ref) => 0);
