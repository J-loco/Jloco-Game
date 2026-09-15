package org.jloco.locos.common;

/**
 * Java-style unescaping with exactly the behaviour of commons-lang 2.6 {@code StringEscapeUtils.unescapeJava},
 * which {@link CryptManager} relied on. Its successors (commons-lang3, commons-text) decode octal escapes and
 * drop unknown or trailing backslashes differently, which would change decrypted client data.
 */
public final class JavaEscapes {

    private JavaEscapes() {}

    /**
     * {@code \\ \' \" \r \f \t \n \b} and {@code \\uXXXX} are decoded; for any other character the backslash is
     * dropped; a trailing backslash is kept.
     *
     * @throws IllegalArgumentException for a {@code \\u} not followed by four hexadecimal digits
     */
    public static String unescapeJava(String text) {
        if (text == null) {
            return null;
        }
        StringBuilder out = new StringBuilder(text.length());
        StringBuilder unicode = new StringBuilder(4);
        boolean hadSlash = false;
        boolean inUnicode = false;
        for (int i = 0; i < text.length(); i++) {
            char ch = text.charAt(i);
            if (inUnicode) {
                unicode.append(ch);
                if (unicode.length() == 4) {
                    try {
                        out.append((char) Integer.parseInt(unicode.toString(), 16));
                    } catch (NumberFormatException e) {
                        throw new IllegalArgumentException("Unable to parse unicode value: " + unicode, e);
                    }
                    unicode.setLength(0);
                    inUnicode = false;
                    hadSlash = false;
                }
                continue;
            }
            if (hadSlash) {
                hadSlash = false;
                switch (ch) {
                    case '\\' -> out.append('\\');
                    case '\'' -> out.append('\'');
                    case '"' -> out.append('"');
                    case 'r' -> out.append('\r');
                    case 'f' -> out.append('\f');
                    case 't' -> out.append('\t');
                    case 'n' -> out.append('\n');
                    case 'b' -> out.append('\b');
                    case 'u' -> inUnicode = true;
                    default -> out.append(ch);
                }
                continue;
            }
            if (ch == '\\') {
                hadSlash = true;
                continue;
            }
            out.append(ch);
        }
        if (hadSlash) {
            out.append('\\');
        }
        return out.toString();
    }
}
