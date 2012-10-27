From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 4/7] cifs.idmap: clean up strget and avoid memory allocation
Date: Sat, 27 Oct 2012 07:20:19 -0400
Message-ID: <1351336822-16425-5-git-send-email-jlayton@samba.org>
References: <1351336822-16425-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351336822-16425-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Don't do a strlen() call if strstr() isn't going to match anyway. Just
use strdup instead of open-coding its equivalent and reduce the amount
of string-walking involved.

Finally, there's no need to duplicate the string here. None of the
callers modify it, so just return a pointer into the original string.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.idmap.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/cifs.idmap.c b/cifs.idmap.c
index ea22300..457d307 100644
--- a/cifs.idmap.c
+++ b/cifs.idmap.c
@@ -54,28 +54,25 @@ static void usage(void)
 	fprintf(stderr, "Usage: %s key_serial\n", prog);
 }
 
-char *strget(const char *str, char *substr)
+char *strget(const char *str, const char *substr)
 {
 	int len, sublen, retlen;
-	char *retstr, *substrptr;
+	char *substrptr;
 
-	sublen = strlen(substr);
+	/* find the prefix */
 	substrptr = strstr(str, substr);
-	if (substrptr) {
-		len = strlen(substrptr);
-		substrptr += sublen;
-
-		retlen = len - sublen;
-		if (retlen > 0) {
-			retstr = malloc(retlen + 1);
-			if (retstr) {
-				strncpy(retstr, substrptr, retlen);
-				return retstr;
-			}
-		}
-	}
+	if (!substrptr)
+		return substrptr;
 
-	return NULL;
+	/* skip over it */
+	sublen = strlen(substr);
+	substrptr += sublen;
+
+	/* if there's nothing after the prefix, return NULL */
+	if (*substrptr == '\0')
+		return NULL;
+
+	return substrptr;
 }
 
 static int
@@ -179,9 +176,6 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 	syslog(LOG_DEBUG, "Invalid key: %s", key_descr);
 
 cifs_idmap_ret:
-	if (sidstr)
-		free(sidstr);
-
 	return rc;
 }
 
-- 
1.7.11.7
