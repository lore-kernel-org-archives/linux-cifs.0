From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH 1/2] cifscreds: better error handling when key_search fails
Date: Wed, 16 Apr 2014 08:55:17 -0400
Message-ID: <1397652918-14002-1-git-send-email-jlayton@samba.org>
Cc: Sebastian Krahmer <krahmer-l3A5Bk7waGM@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If we ended up getting a bogus string that would have overflowed, then
make key_search set errno to EINVAL before returning. The callers can
then test to see if the returned error is what was expected or something
else and handle it appropriately.

Cc: Sebastian Krahmer <krahmer-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c     | 9 +++++++++
 cifskey.c       | 5 ++++-
 pam_cifscreds.c | 9 +++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/cifscreds.c b/cifscreds.c
index fa05dc88b0e0..64d55b0cac0e 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -188,6 +188,15 @@ static int cifscreds_add(struct cmdarg *arg)
 			return EXIT_FAILURE;
 		}
 
+		switch(errno) {
+		case ENOKEY:
+			/* success */
+			break;
+		default:
+			printf("Key search failed: %s\n", strerror(errno));
+			return EXIT_FAILURE;
+		}
+
 		currentaddress = nextaddress;
 		if (currentaddress) {
 			*(currentaddress - 1) = ',';
diff --git a/cifskey.c b/cifskey.c
index e89cacf171f2..4f01ed0e10bd 100644
--- a/cifskey.c
+++ b/cifskey.c
@@ -20,6 +20,7 @@
 #include <sys/types.h>
 #include <keyutils.h>
 #include <stdio.h>
+#include <errno.h>
 #include "cifskey.h"
 #include "resolve_host.h"
 
@@ -29,8 +30,10 @@ key_search(const char *addr, char keytype)
 {
 	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
 
-	if (snprintf(desc, sizeof(desc), "%s:%c:%s", KEY_PREFIX, keytype, addr) >= (int)sizeof(desc))
+	if (snprintf(desc, sizeof(desc), "%s:%c:%s", KEY_PREFIX, keytype, addr) >= (int)sizeof(desc)) {
+		errno = EINVAL;
 		return -1;
+	}
 
 	return keyctl_search(DEST_KEYRING, CIFS_KEY_TYPE, desc, 0);
 }
diff --git a/pam_cifscreds.c b/pam_cifscreds.c
index e0d8a554510e..fb23117953f0 100644
--- a/pam_cifscreds.c
+++ b/pam_cifscreds.c
@@ -206,6 +206,15 @@ static int cifscreds_pam_add(pam_handle_t *ph, const char *user, const char *pas
 			return PAM_SERVICE_ERR;
 		}
 
+		switch(errno) {
+		case ENOKEY:
+			break;
+		default:
+			pam_syslog(ph, LOG_ERR, "Unable to search keyring for %s (%s)",
+					currentaddress, strerror(errno));
+			return PAM_SERVICE_ERR;
+		}
+
 		currentaddress = nextaddress;
 		if (currentaddress) {
 			*(currentaddress - 1) = ',';
-- 
1.9.0
