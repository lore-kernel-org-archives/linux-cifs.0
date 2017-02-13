From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH] cifs.upcall: switch group IDs when handling an upcall
Date: Mon, 13 Feb 2017 09:00:38 -0500
Message-ID: <20170213140038.7300-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, we leave the group ID alone, but now that we're looking at
KRB5CCNAME, we need to be a little more careful with credentials. After
we get the uid, do a getpwuid and grab the default gid for the user.
Then use setgid to set it before calling setuid.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index ee3449d4555d..3328bbdd34ca 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -47,6 +47,8 @@
 #include <netdb.h>
 #include <arpa/inet.h>
 #include <ctype.h>
+#include <pwd.h>
+#include <grp.h>
 
 #include "replace.h"
 #include "data_blob.h"
@@ -818,6 +820,7 @@ int main(const int argc, char *const argv[])
 	char *keytab_name = NULL;
 	char *env_cachename = NULL;
 	krb5_ccache ccache = NULL;
+	struct passwd *pw;
 
 	hostbuf[0] = '\0';
 	memset(&arg, 0, sizeof(arg));
@@ -924,20 +927,54 @@ int main(const int argc, char *const argv[])
 	}
 
 	/*
+	 * The kernel doesn't pass down the gid, so we resort here to scraping
+	 * one out of /etc/passwd (or the equivalent). Note that this might
+	 * not reflect the actual gid of the process that initiated the
+	 * upcall, but it's safer than relying on the current creds.
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
 	 * Must do this before setuid, as we need ptrace perms to look at
 	 * environ file.
 	 */
 	env_cachename = get_cachename_from_process_env(env_probe ? arg.pid : 0);
 
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
