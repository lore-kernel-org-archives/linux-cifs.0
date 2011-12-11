From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 13/16] cifscreds: make key_search use keyctl_search
Date: Sun, 11 Dec 2011 11:34:20 -0500
Message-ID: <1323621263-14452-14-git-send-email-jlayton@samba.org>
References: <1323621263-14452-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323621263-14452-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...which is much more efficient than walking the keyring by hand.

Also, eliminate the "user" parameter since we don't want to search
by username. Also must add "search" permission to the key as well.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   50 +++-----------------------------------------------
 1 files changed, 3 insertions(+), 47 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index 279517a..55279f7 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -103,54 +103,10 @@ static key_serial_t
 key_search(const char *addr, char keytype)
 {
 	char desc[INET6_ADDRSTRLEN + sizeof(THIS_PROGRAM_NAME) + 4];
-	key_serial_t key, *pk;
-	void *keylist;
-	char *buffer;
-	int count, dpos, n, ret;
 
 	sprintf(desc, "%s:%c:%s", THIS_PROGRAM_NAME, keytype, addr);
 
-	/* read the key payload data */
-	count = keyctl_read_alloc(DEST_KEYRING, &keylist);
-	if (count < 0)
-		return 0;
-
-	count /= sizeof(key_serial_t);
-
-	if (count == 0) {
-		ret = 0;
-		goto key_search_out;
-	}
-
-	/* list the keys in the keyring */
-	pk = keylist;
-	do {
-		key = *pk++;
-
-		ret = keyctl_describe_alloc(key, &buffer);
-		if (ret < 0)
-			continue;
-
-		n = sscanf(buffer, "%*[^;];%*d;%*d;%*x;%n", &dpos);
-		if (n) {
-			free(buffer);
-			continue;
-		}
-
-		if (!strcmp(buffer + dpos, desc)) {
-			ret = key;
-			free(buffer);
-			goto key_search_out;
-		}
-		free(buffer);
-
-	} while (--count);
-
-	ret = 0;
-
-key_search_out:
-	free(keylist);
-	return ret;
+	return keyctl_search(DEST_KEYRING, "user", desc, 0);
 }
 
 /* search all program's keys in keyring */
@@ -298,8 +254,8 @@ static int cifscreds_add(struct cmdarg *arg)
 				currentaddress);
 		} else {
 			if (keyctl(KEYCTL_SETPERM, key, KEY_POS_VIEW | \
-				KEY_POS_WRITE | KEY_USR_VIEW | \
-				KEY_USR_WRITE) < 0
+				KEY_POS_WRITE | KEY_POS_SEARCH | KEY_USR_VIEW | \
+				KEY_USR_WRITE | KEY_USR_SEARCH) < 0
 			) {
 				fprintf(stderr, "error: Setting permissons "
 					"on key, attempt to delete...\n");
-- 
1.7.7.3
