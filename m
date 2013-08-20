From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] cifs: convert case-insensitive dentry ops to use new case conversion routines
Date: Tue, 20 Aug 2013 15:50:10 -0400
Message-ID: <1377028211-17624-3-git-send-email-jlayton@redhat.com>
References: <1377028211-17624-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org, bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377028211-17624-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Have the case-insensitive d_compare and d_hash routines convert each
character in the filenames to wchar_t's and then use the new
cifs_toupper routine to convert those into uppercase.

With this scheme we should more closely emulate the case conversion that
the servers will do.

Reported-and-Tested-by: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/dir.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index d62ce0d..d3e2eaa 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -32,6 +32,7 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
+#include "cifs_unicode.h"
 
 static void
 renew_parental_timestamps(struct dentry *direntry)
@@ -834,12 +835,17 @@ static int cifs_ci_hash(const struct dentry *dentry, struct qstr *q)
 {
 	struct nls_table *codepage = CIFS_SB(dentry->d_sb)->local_nls;
 	unsigned long hash;
-	int i;
+	wchar_t c;
+	int i, charlen;
 
 	hash = init_name_hash();
-	for (i = 0; i < q->len; i++)
-		hash = partial_name_hash(nls_tolower(codepage, q->name[i]),
-					 hash);
+	for (i = 0; i < q->len; i += charlen) {
+		charlen = codepage->char2uni(&q->name[i], q->len - i, &c);
+		/* error out if we can't convert the character */
+		if (unlikely(charlen < 0))
+			return charlen;
+		hash = partial_name_hash(cifs_toupper(c), hash);
+	}
 	q->hash = end_name_hash(hash);
 
 	return 0;
@@ -849,11 +855,47 @@ static int cifs_ci_compare(const struct dentry *parent, const struct dentry *den
 		unsigned int len, const char *str, const struct qstr *name)
 {
 	struct nls_table *codepage = CIFS_SB(parent->d_sb)->local_nls;
+	wchar_t c1, c2;
+	int i, l1, l2;
 
-	if ((name->len == len) &&
-	    (nls_strnicmp(codepage, name->name, str, len) == 0))
-		return 0;
-	return 1;
+	/*
+	 * We make the assumption here that uppercase characters in the local
+	 * codepage are always the same length as their lowercase counterparts.
+	 *
+	 * If that's ever not the case, then this will fail to match it.
+	 */
+	if (name->len != len)
+		return 1;
+
+	for (i = 0; i < len; i += l1) {
+		/* Convert characters in both strings to UTF-16. */
+		l1 = codepage->char2uni(&str[i], len - i, &c1);
+		l2 = codepage->char2uni(&name->name[i], name->len - i, &c2);
+
+		/*
+		 * If we can't convert either character, just declare it to
+		 * be 1 byte long and compare the original byte.
+		 */
+		if (unlikely(l1 < 0 && l2 < 0)) {
+			if (str[i] != name->name[i])
+				return 1;
+			l1 = 1;
+			continue;
+		}
+
+		/*
+		 * Here, we again ass|u|me that upper/lowercase versions of
+		 * a character are the same length in the local NLS.
+		 */
+		if (l1 != l2)
+			return 1;
+
+		/* Now compare uppercase versions of these characters */
+		if (cifs_toupper(c1) != cifs_toupper(c2))
+			return 1;
+	}
+
+	return 0;
 }
 
 const struct dentry_operations cifs_ci_dentry_ops = {
-- 
1.8.3.1
