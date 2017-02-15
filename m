From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH v3 2/4] cifs.upcall: switch group IDs when handling an upcall
Date: Wed, 15 Feb 2017 11:13:22 -0500
Message-ID: <20170215161325.16914-3-jlayton@samba.org>
References: <20170215161325.16914-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170215161325.16914-1-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, we leave the group ID alone, but in a later patch we'll be
changing cifs.upcall to scrape $KRB5CCNAME out of the originating
process. At that point, we want to be a little more careful with the
process credentials we'll be using.

After we get the uid, do a getpwuid and grab the default gid for the
user. Then use setgid to set it before calling setuid.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 418b179d7f29..2b535a133a30 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -46,6 +46,8 @@
 #include <netdb.h>
 #include <arpa/inet.h>
 #include <ctype.h>
+#include <pwd.h>
+#include <grp.h>
 
 #include "replace.h"
 #include "data_blob.h"
@@ -694,6 +696,7 @@ int main(const int argc, char *const argv[])
 	uid_t uid;
 	char *keytab_name = NULL;
 	krb5_ccache ccache = NULL;
+	struct passwd *pw;
 
 	hostbuf[0] = '\0';
 	memset(&arg, 0, sizeof(arg));
@@ -795,15 +798,49 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
+	/*
+	 * The kernel doesn't pass down the gid, so we resort here to scraping
+	 * one out of the passwd nss db. Note that this might not reflect the
+	 * actual gid of the process that initiated the upcall. While we could
+	 * scrape that out of /proc, relying on that is a bit more risky.
+	 */
+	pw = getpwuid(uid);
+	if (!pw) {
+		syslog(LOG_ERR, "Unable to find pw entry for uid %d: %s\n",
+			uid, strerror(errno));
+		rc = 1;
+		goto out;
+	}
+
+	/*
+	 * The kernel should send down a zero-length grouplist already, but
+	 * just to be on the safe side...
+	 */
+	rc = setgroups(0, NULL);
+	if (rc == -1) {
+		syslog(LOG_ERR, "setgroups: %s", strerror(errno));
+		rc = 1;
+		goto out;
+	}
+
+	rc = setgid(pw->pw_gid);
+	if (rc == -1) {
+		syslog(LOG_ERR, "setgid: %s", strerror(errno));
+		rc = 1;
+		goto out;
+	}
+
 	rc = setuid(uid);
 	if (rc == -1) {
 		syslog(LOG_ERR, "setuid: %s", strerror(errno));
+		rc = 1;
 		goto out;
 	}
 
 	rc = krb5_init_context(&context);
 	if (rc) {
 		syslog(LOG_ERR, "unable to init krb5 context: %ld", rc);
+		rc = 1;
 		goto out;
 	}
 
-- 
2.9.3
