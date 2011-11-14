From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/3] cifs.upcall: move to Simo's suggested algorithm for picking a principal
Date: Sun, 13 Nov 2011 20:17:27 -0500
Message-ID: <1321233448-13548-3-git-send-email-jlayton@samba.org>
References: <1321233448-13548-1-git-send-email-jlayton@samba.org>
Cc: idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321233448-13548-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Simo suggests the algorithm supplied in the comments.

For now, we don't try to guess the domainname when the hostname is not
qualified, but add a comment with what needs to be done in order to
support that.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |   93 +++++++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 78 insertions(+), 15 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index d33e639..57ed0ba 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -45,6 +45,7 @@
 #include <time.h>
 #include <netdb.h>
 #include <arpa/inet.h>
+#include <ctype.h>
 
 #include "util.h"
 #include "replace.h"
@@ -747,6 +748,23 @@ static int ip_to_fqdn(const char *addrstr, char *host, size_t hostlen)
 	return 0;
 }
 
+/*
+ * Copy a hostname from src to dst and uppercase it. Stop at the first '.' in
+ * the name or the end of src string. Append a '$'.
+ */
+static void
+set_ad_principal(char *dst, char *src)
+{
+	while(*src && *src != '.') {
+		*dst = toupper(*src);
+		++dst;
+		++src;
+	}
+	*dst = '$';
+	++dst;
+	*dst = '\0';
+}
+
 static void usage(void)
 {
 	fprintf(stderr, "Usage: %s [-t] [-v] [-l] key_serial\n", prog);
@@ -877,26 +895,71 @@ int main(const int argc, char *const argv[])
 	switch (arg.sec) {
 	case MS_KRB5:
 	case KRB5:
-retry_new_hostname:
+		/*
+		 * Simo Sorce's suggested scheme for picking a principal
+		 * name, based on a supplied hostname.
+		 *
+		 * INPUT: fooo
+		 * TRY in order:
+		 * FOOO$@REALM
+		 * cifs/fooo.<guessed domain ?>@REALM
+		 * host/fooo.<guessed domain ?>@REALM
+		 *
+		 * INPUT: bar.example.com
+		 * TRY in order:
+		 * cifs/bar.example.com@REALM
+		 * BAR$@REALM
+		 * host/bar.example.com@REALM
+		 */
 		if (arg.sec == MS_KRB5)
 			oid = OID_KERBEROS5_OLD;
 		else
 			oid = OID_KERBEROS5;
 
-		/*
-		 * try getting a cifs/ principal first and then fall back to
-		 * getting a host/ principal if that doesn't work.
-		 */
-		strlcpy(princ, "cifs/", sizeof(princ));
-		strlcpy(princ + 5, host, sizeof(princ) - 5);
-		rc = handle_krb5_mech(oid, princ, &secblob, &sess_key, ccname);
-		if (!rc)
-			break;
-
-		memcpy(princ, "host/", 5);
-		rc = handle_krb5_mech(oid, princ, &secblob, &sess_key, ccname);
-		if (!rc)
-			break;
+retry_new_hostname:
+		/* If hostname has a '.', assume it's a FQDN */
+		if (strchr(host, '.')) {
+			/* try "cifs/hostname" first */
+			rc = snprintf(princ, sizeof(princ), "cifs/%s", host);
+			if (rc < 0 || (size_t)rc >= sizeof(princ)) {
+				syslog(LOG_ERR,"Unable to set hostname %s in buffer.", host);
+				goto out;
+			}
+			rc = handle_krb5_mech(oid, princ, &secblob, &sess_key, ccname);
+			if (!rc)
+				break;
+
+			/* now try AD-style name */
+			set_ad_principal(princ, host);
+			rc = handle_krb5_mech(oid, princ, &secblob, &sess_key, ccname);
+			if (!rc)
+				break;
+
+			/* and now "host/" */
+			rc = snprintf(princ, sizeof(princ), "host/%s", host);
+			if (rc < 0 || (size_t)rc >= sizeof(princ)) {
+				syslog(LOG_ERR,"Unable to set hostname %s in buffer.", host);
+				goto out;
+			}
+			rc = handle_krb5_mech(oid, princ, &secblob, &sess_key, ccname);
+			if (!rc)
+				break;
+		} else {
+			/* shortname: try AD-style first */
+			set_ad_principal(princ, host);
+			rc = handle_krb5_mech(oid, princ, &secblob, &sess_key, ccname);
+			if (!rc)
+				break;
+
+			/*
+			 * FIXME: try to guess the DNS domain name for the host. We
+			 * must require that the kernel sends the IP addr in the upcall.
+			 *
+			 * Use getaddrinfo() to resolve the hostname of the server and
+			 * set ai_canonname. Then use the domainname in ai canonname
+			 * to turn the unqualified hostname into a FQDN.
+			 */
+		}
 
 		if (!try_dns || !(have & DKD_HAVE_IP))
 			break;
-- 
1.7.6.4
