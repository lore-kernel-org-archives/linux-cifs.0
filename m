From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 03/16] cifscreds: eliminate domain parm from create_description
Date: Sun, 11 Dec 2011 11:34:10 -0500
Message-ID: <1323621263-14452-4-git-send-email-jlayton@samba.org>
References: <1323621263-14452-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323621263-14452-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The domain needs to be part of the payload.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index d771056..c86c1f9 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -85,26 +85,13 @@ static void usage(void)
 
 /* create key's description string from given credentials */
 static char *
-create_description(const char *addr, const char *user,
-		   const char *domain, char *desc)
+create_description(const char *addr, const char *user, char *desc)
 {
 	char *str_end;
 	int str_len;
 
 	sprintf(desc, "%s:%s:%s:", THIS_PROGRAM_NAME, addr, user);
 
-	if (domain != NULL) {
-		str_end = desc + strnlen(desc, INET6_ADDRSTRLEN + \
-					+ MAX_USERNAME_SIZE + \
-					+ sizeof(THIS_PROGRAM_NAME) + 3);
-		str_len = strnlen(domain, MAX_DOMAIN_SIZE);
-		while (str_len--) {
-			*str_end = tolower(*domain++);
-			str_end++;
-		}
-		*str_end = '\0';
-	}
-
 	return desc;
 }
 
@@ -119,7 +106,7 @@ key_search(const char *addr, const char *user, const char *domain)
 	char *buffer;
 	int count, dpos, n, ret;
 
-	create_description(addr, user, domain, desc);
+	create_description(addr, user, desc);
 
 	/* read the key payload data */
 	count = keyctl_read_alloc(DEST_KEYRING, &keylist);
@@ -225,7 +212,7 @@ key_add(const char *addr, const char *user,
 	char desc[INET6_ADDRSTRLEN + MAX_USERNAME_SIZE + MAX_DOMAIN_SIZE + \
 		+ sizeof(THIS_PROGRAM_NAME) + 3];
 
-	create_description(addr, user, domain, desc);
+	create_description(addr, user, desc);
 
 	return add_key("user", desc, pass, strnlen(pass, MOUNT_PASSWD_SIZE) + 1,
 		DEST_KEYRING);
-- 
1.7.7.3
