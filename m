From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 06/53] CIFS: Add missing unicode handling routines needed by smb2
Date: Fri, 28 Oct 2011 23:54:17 +0400
Message-ID: <1319831704-3572-7-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifs_unicode.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifs_unicode.h |    7 +++++
 2 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 1b2e180..7f09423 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -330,3 +330,64 @@ ctoUCS_out:
 	return i;
 }
 
+#ifdef CONFIG_CIFS_SMB2
+/*
+ * smb2_local_to_ucs2_bytes - how long will a string be after conversion?
+ * @from - pointer to input string
+ * @maxbytes - don't go past this many bytes of input string
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
index 6d02fd5..e00f677 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -380,4 +380,11 @@ UniStrlwr(register wchar_t *upin)
 
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
1.7.1
