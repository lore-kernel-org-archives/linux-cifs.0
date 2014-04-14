From: Sebastian Krahmer <krahmer-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifskey: better use snprintf()
Date: Mon, 14 Apr 2014 11:39:41 +0200
Message-ID: <20140414093941.GA7017@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Prefer snprintf() over sprintf() in cifskey.c
Projects that fork the code (pam_cifscreds) can't rely on
the max-size parameters.

Signed-off-by: Sebastian Krahmer <krahmer-l3A5Bk7waGM@public.gmane.org>
---


--- cifskey.c.orig	2014-04-08 13:10:41.653435040 +0200
+++ cifskey.c	2014-04-14 11:19:07.000118206 +0200
@@ -29,7 +29,8 @@
 {
 	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
 
-	sprintf(desc, "%s:%c:%s", KEY_PREFIX, keytype, addr);
+	if (snprintf(desc, sizeof(desc), "%s:%c:%s", KEY_PREFIX, keytype, addr) >= (int)sizeof(desc))
+		return -1;
 
 	return keyctl_search(DEST_KEYRING, CIFS_KEY_TYPE, desc, 0);
 }
@@ -38,15 +39,18 @@
 key_serial_t
 key_add(const char *addr, const char *user, const char *pass, char keytype)
 {
-	int len;
+	int len = 0;
 	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
 	char val[MOUNT_PASSWD_SIZE +  MAX_USERNAME_SIZE + 2];
 
 	/* set key description */
-	sprintf(desc, "%s:%c:%s", KEY_PREFIX, keytype, addr);
+	if (snprintf(desc, sizeof(desc), "%s:%c:%s", KEY_PREFIX, keytype, addr) >= (int)sizeof(desc))
+		return -1;
 
 	/* set payload contents */
-	len = sprintf(val, "%s:%s", user, pass);
+	len = snprintf(val, sizeof(val), "%s:%s", user, pass);
+	if (len >= (int)sizeof(val))
+		return -1;
 
 	return add_key(CIFS_KEY_TYPE, desc, val, len + 1, DEST_KEYRING);
 }


-- 

~ perl self.pl
~ $_='print"\$_=\47$_\47;eval"';eval
~ krahmer-l3A5Bk7waGM@public.gmane.org - SuSE Security Team
