
class StringUtils {
   static String getInitials(String name, {int max = 4}) {
    final trimmed = name.trim();

    // Nếu tên < max ký tự thì giữ nguyên
    if (trimmed.length <= max) return trimmed;

    // Ngược lại: lấy chữ cái đầu mỗi từ
    final words = trimmed.split(RegExp(r'\s+'));
    final initials = words.map((w) => w[0].toUpperCase()).join();

    return initials.length <= max ? initials : initials.substring(0, max);
  }
}
