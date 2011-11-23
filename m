From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/4] cifs.upcall: always lowercase the hostname
Date: Wed, 23 Nov 2011 07:44:04 -0500
Message-ID: <1322052246-18707-3-git-send-email-jlayton@samba.org>
References: <1322052246-18707-1-git-send-email-jlayton@samba.org>
Cc: abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1322052246-18707-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Most KDCs are case-sensitive (the notable exception being AD), but DNS
is case-insensitive. To prevent admins from having to put in all
possible case combinations of a principal, lowercase the hostname prior
to trying to get a principal.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 615c827..2fe2dba 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -45,6 +45,7 @@
 #include <time.h>
 #include <netdb.h>
 #include <arpa/inet.h>
+#include <ctype.h>
 
 #include "util.h"
 #include "replace.h"
@@ -747,6 +748,16 @@ static int ip_to_fqdn(const char *addrstr, char *host, size_t hostlen)
 	return 0;
 }
 
+/* walk a string and lowercase it in-place */
+static void
+lowercase_string(char *c)
+{
+	while(*c) {
+		*c = tolower(*c);
+		++c;
+	}
+}
+
 static void usage(void)
 {
 	fprintf(stderr, "Usage: %s [-t] [-v] [-l] key_serial\n", prog);
@@ -894,6 +905,7 @@ retry_new_hostname:
 		 * try getting a cifs/ principal first and then fall back to
 		 * getting a host/ principal if that doesn't work.
 		 */
+		lowercase_string(host);
 		strlcpy(princ, "cifs/", sizeof(princ));
 		strlcpy(princ + 5, host, sizeof(princ) - 5);
 		rc = handle_krb5_mech(oid, princ, &secblob, &sess_key, ccname);
-- 
1.7.6.4
