From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 3/4] cifs.upcall: move to Andrew's suggested algorithm for picking a principal
Date: Wed, 23 Nov 2011 07:44:05 -0500
Message-ID: <1322052246-18707-4-git-send-email-jlayton@samba.org>
References: <1322052246-18707-1-git-send-email-jlayton@samba.org>
Cc: abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1322052246-18707-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Andrew Bartlett suggests the heuristic supplied in the comments.

For now, we don't try to guess the domainname when the hostname is not
qualified, but add a comment with what needs to be done in order to
support that.

Also, with this change we no longer need util.o to be linked in.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am   |    2 +-
 cifs.upcall.c |   40 ++++++++++++++++++++++++++++------------
 2 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 026be9f..934ea6f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -14,7 +14,7 @@ clean-local: clean-local-upcall clean-local-idmap clean-local-aclprogs
 
 if CONFIG_CIFSUPCALL
 sbin_PROGRAMS += cifs.upcall
-cifs_upcall_SOURCES = cifs.upcall.c data_blob.c asn1.c spnego.c util.c
+cifs_upcall_SOURCES = cifs.upcall.c data_blob.c asn1.c spnego.c
 cifs_upcall_LDADD = -ltalloc -lkeyutils $(KRB5_LDADD)
 man_MANS += cifs.upcall.8
 
diff --git a/cifs.upcall.c b/cifs.upcall.c
index 2fe2dba..16dec81 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -47,7 +47,6 @@
 #include <arpa/inet.h>
 #include <ctype.h>
 
-#include "util.h"
 #include "replace.h"
 #include "data_blob.h"
 #include "spnego.h"
@@ -895,28 +894,45 @@ int main(const int argc, char *const argv[])
 	switch (arg.sec) {
 	case MS_KRB5:
 	case KRB5:
-retry_new_hostname:
+		/*
+		 * Andrew Bartlett's suggested scheme for picking a principal
+		 * name, based on a supplied hostname.
+		 *
+		 * INPUT: fooo
+		 * TRY in order:
+		 * cifs/fooo@REALM
+		 * cifs/fooo.<guessed domain ?>@REALM
+		 *
+		 * INPUT: bar.example.com
+		 * TRY only:
+		 * cifs/bar.example.com@REALM
+		 */
 		if (arg.sec == MS_KRB5)
 			oid = OID_KERBEROS5_OLD;
 		else
 			oid = OID_KERBEROS5;
 
-		/*
-		 * try getting a cifs/ principal first and then fall back to
-		 * getting a host/ principal if that doesn't work.
-		 */
+retry_new_hostname:
 		lowercase_string(host);
-		strlcpy(princ, "cifs/", sizeof(princ));
-		strlcpy(princ + 5, host, sizeof(princ) - 5);
-		rc = handle_krb5_mech(oid, princ, &secblob, &sess_key, ccname);
-		if (!rc)
-			break;
+		/* try "cifs/hostname" first */
+		rc = snprintf(princ, sizeof(princ), "cifs/%s", host);
+		if (rc < 0 || (size_t)rc >= sizeof(princ)) {
+			syslog(LOG_ERR,"Unable to set hostname %s in buffer.", host);
+			goto out;
+		}
 
-		memcpy(princ, "host/", 5);
 		rc = handle_krb5_mech(oid, princ, &secblob, &sess_key, ccname);
 		if (!rc)
 			break;
 
+		/*
+		 * FIXME: try to guess the DNS domain name for non-FQDN's.
+		 *
+		 * Use getaddrinfo() to resolve the hostname of the server and
+		 * set ai_canonname. Then use the domainname in ai_canonname
+		 * to turn the unqualified hostname into a FQDN.
+		 */
+
 		if (!try_dns || !(have & DKD_HAVE_IP))
 			break;
 
-- 
1.7.6.4
