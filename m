From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 14/15] cifscreds: change prefix on keys to "cifs:" instead of "cifscreds:"
Date: Fri,  6 Jan 2012 13:14:46 -0500
Message-ID: <1325873687-11229-15-git-send-email-jlayton@samba.org>
References: <1325873687-11229-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325873687-11229-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The "creds" portion seems redundant.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index 64da070..8f3b829 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -33,6 +33,7 @@
 #include "util.h"
 
 #define THIS_PROGRAM_NAME "cifscreds"
+#define KEY_PREFIX	  "cifs"
 
 /* max length of appropriate command */
 #define MAX_COMMAND_SIZE 32
@@ -108,9 +109,9 @@ usage(void)
 static key_serial_t
 key_search(const char *addr, char keytype)
 {
-	char desc[INET6_ADDRSTRLEN + sizeof(THIS_PROGRAM_NAME) + 4];
+	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
 
-	sprintf(desc, "%s:%c:%s", THIS_PROGRAM_NAME, keytype, addr);
+	sprintf(desc, "%s:%c:%s", KEY_PREFIX, keytype, addr);
 
 	return keyctl_search(DEST_KEYRING, CIFS_KEY_TYPE, desc, 0);
 }
@@ -150,7 +151,7 @@ static key_serial_t key_search_all(void)
 			continue;
 		}
 
-		if (strstr(buffer + dpos, THIS_PROGRAM_NAME ":") ==
+		if (strstr(buffer + dpos, KEY_PREFIX ":") ==
 			buffer + dpos
 		) {
 			ret = key;
@@ -173,11 +174,11 @@ static key_serial_t
 key_add(const char *addr, const char *user, const char *pass, char keytype)
 {
 	int len;
-	char desc[INET6_ADDRSTRLEN + sizeof(THIS_PROGRAM_NAME) + 4];
+	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
 	char val[MOUNT_PASSWD_SIZE +  MAX_USERNAME_SIZE + 2];
 
 	/* set key description */
-	sprintf(desc, "%s:%c:%s", THIS_PROGRAM_NAME, keytype, addr);
+	sprintf(desc, "%s:%c:%s", KEY_PREFIX, keytype, addr);
 
 	/* set payload contents */
 	len = sprintf(val, "%s:%s", user, pass);
@@ -379,7 +380,7 @@ static int cifscreds_clearall(struct cmdarg *arg __attribute__ ((unused)))
 	} while (key > 0);
 
 	if (!count && !errors) {
-		printf("You have no stashed " THIS_PROGRAM_NAME
+		printf("You have no stashed " KEY_PREFIX
 			" credentials\n");
 		printf("If you want to add them use:\n");
 		printf("\t%s add\n", thisprogram);
-- 
1.7.7.4
