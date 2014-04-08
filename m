From: Sebastian Krahmer <krahmer-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifskey: better use snprintf()
Date: Tue, 8 Apr 2014 14:44:44 +0200
Message-ID: <20140408124444.GB23274@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Prefer snprintf() over sprintf() in cifskey.c
Projects that fork the code (pam_cifscreds) can't rely on
the max-size parameters. Also use strlen() for determining
buffer size, as snprintf() may return values larger than buffer size.


Signed-off-by: Sebastian Krahmer <krahmer-l3A5Bk7waGM@public.gmane.org>
---


--- cifskey.c.orig	2014-04-08 13:10:41.653435040 +0200
+++ cifskey.c	2014-04-08 14:28:54.457766913 +0200
@@ -20,6 +20,7 @@
 #include <sys/types.h>
 #include <keyutils.h>
 #include <stdio.h>
+#include <string.h>
 #include "cifskey.h"
 #include "resolve_host.h"
 
@@ -29,7 +30,7 @@
 {
 	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
 
-	sprintf(desc, "%s:%c:%s", KEY_PREFIX, keytype, addr);
+	snprintf(desc, sizeof(desc), "%s:%c:%s", KEY_PREFIX, keytype, addr);
 
 	return keyctl_search(DEST_KEYRING, CIFS_KEY_TYPE, desc, 0);
 }
@@ -38,15 +39,14 @@
 key_serial_t
 key_add(const char *addr, const char *user, const char *pass, char keytype)
 {
-	int len;
 	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
 	char val[MOUNT_PASSWD_SIZE +  MAX_USERNAME_SIZE + 2];
 
 	/* set key description */
-	sprintf(desc, "%s:%c:%s", KEY_PREFIX, keytype, addr);
+	snprintf(desc, sizeof(desc), "%s:%c:%s", KEY_PREFIX, keytype, addr);
 
 	/* set payload contents */
-	len = sprintf(val, "%s:%s", user, pass);
+	snprintf(val, sizeof(val), "%s:%s", user, pass);
 
-	return add_key(CIFS_KEY_TYPE, desc, val, len + 1, DEST_KEYRING);
+	return add_key(CIFS_KEY_TYPE, desc, val, strlen(val) + 1, DEST_KEYRING);
 }


-- 

~ perl self.pl
~ $_='print"\$_=\47$_\47;eval"';eval
~ krahmer-l3A5Bk7waGM@public.gmane.org - SuSE Security Team


--GvXjxJ+pjyke8COw
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="cifskey-overflow.patch"

--- cifskey.c.orig	2014-04-08 13:10:41.653435040 +0200
+++ cifskey.c	2014-04-08 14:28:54.457766913 +0200
@@ -20,6 +20,7 @@
 #include <sys/types.h>
 #include <keyutils.h>
 #include <stdio.h>
+#include <string.h>
 #include "cifskey.h"
 #include "resolve_host.h"
 
@@ -29,7 +30,7 @@
 {
 	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
 
-	sprintf(desc, "%s:%c:%s", KEY_PREFIX, keytype, addr);
+	snprintf(desc, sizeof(desc), "%s:%c:%s", KEY_PREFIX, keytype, addr);
 
 	return keyctl_search(DEST_KEYRING, CIFS_KEY_TYPE, desc, 0);
 }
@@ -38,15 +39,14 @@
 key_serial_t
 key_add(const char *addr, const char *user, const char *pass, char keytype)
 {
-	int len;
 	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
 	char val[MOUNT_PASSWD_SIZE +  MAX_USERNAME_SIZE + 2];
 
 	/* set key description */
-	sprintf(desc, "%s:%c:%s", KEY_PREFIX, keytype, addr);
+	snprintf(desc, sizeof(desc), "%s:%c:%s", KEY_PREFIX, keytype, addr);
 
 	/* set payload contents */
-	len = sprintf(val, "%s:%s", user, pass);
+	snprintf(val, sizeof(val), "%s:%s", user, pass);
 
-	return add_key(CIFS_KEY_TYPE, desc, val, len + 1, DEST_KEYRING);
+	return add_key(CIFS_KEY_TYPE, desc, val, strlen(val) + 1, DEST_KEYRING);
 }

--GvXjxJ+pjyke8COw--
