From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cifs: add missing unicode handling routines needed for smb2
Date: Sun, 6 Mar 2011 22:17:32 -0600
Message-ID: <AANLkTinVkEHg-DOp6+0Jq+_vteYaix+nqt=QNFJ7nSML@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

 go past this many bytes of input string
+ * @codepage - source codepage
+ *
+ * Walk a string and return the number of bytes that the string will
+ * be after being converted to the given charset, not including any null
+ * termination required. Don't walk past maxbytes in the source buffer.
+ */
+
+int
+smb2_local_to_ucs2_bytes(const char *from, int len,
+			  const struct nls_table *codepage)
+{
+	int charlen;
+	int i;
+	wchar_t wchar_to;
+
+	if (from == NULL)
+		return 0;
+	for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
+		charlen = codepage->char2uni(from, len, &wchar_to);
+		/* Failed conversion defaults to a question mark */
+		if (charlen < 1)
+			charlen = 1;
+	}
+	return 2 * i; /* UCS characters are two bytes */
+}
+
+/*
+ * smb2_strndup_to_ucs - copy a string to wire format from the local codepage
+ * @src - source string
+ * @maxlen - don't walk past this many bytes in the source string
+ * @ucslen - the length of the allocated string in bytes (including null)
+ * @codepage - source codepage
+ *
+ * Take a string convert it from the local codepage to UCS2 and
+ * put it in a new buffer. Returns a pointer to the new string or NULL on
+ * error.
+ */
+__le16 *
+smb2_strndup_to_ucs(const char *src, const int maxlen, int *ucs_len,
+	     const struct nls_table *codepage)
+{
+	int len;
+	__le16 *dst;
+
+	len = smb2_local_to_ucs2_bytes(src, maxlen, codepage);
+	len += 2; /* NULL */
+	dst = kmalloc(len, GFP_KERNEL);
+	if (!dst) {
+		*ucs_len = 0;
+		return NULL;
+	}
+	cifs_strtoUCS(dst, src, maxlen, codepage);
+	*ucs_len = len;
+	return dst;
+}
+#endif /* CONFIG_CIFS_SMB2 */
diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index 7fe6b52..a56dfbc 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -377,4 +377,11 @@ UniStrlwr(register wchar_t *upin)

 #endif

+#ifdef CONFIG_CIFS_SMB2
+extern int smb2_local_to_ucs2_bytes(const char *from, int len,
+				    const struct nls_table *codepage);
+extern __le16 *smb2_strndup_to_ucs(const char *src, const int maxlen,
+				   int *ucs_len, const struct nls_table *cp);
+#endif /* CONFIG_CIFS_SMB2 */
+
 #endif /* _CIFS_UNICODE_H */

--
Thanks,

Steve
