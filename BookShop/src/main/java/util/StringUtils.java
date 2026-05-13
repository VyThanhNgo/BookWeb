package util;

import java.text.Normalizer;
import java.util.regex.Pattern;
// class này để tạo slug
public class StringUtils {
	public static String toSlug(String input) {
	    if (input == null) return "";
	    String nfdNormalizedString = Normalizer.normalize(input, Normalizer.Form.NFD);
	    Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
	    String nosign = pattern.matcher(nfdNormalizedString).replaceAll("").replace('đ', 'd').replace('Đ', 'D');
	    return nosign.toLowerCase()
	            .replaceAll("[^a-z0-9\\s]", "")
	            .replaceAll("\\s+", "-")
	            .replaceAll("-+", "-")
	            .trim();
	}
}
