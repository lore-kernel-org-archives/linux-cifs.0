From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 13/15] cifscreds: make key_search use keyctl_search
Date: Fri,  6 Jan 2012 13:14:45 -0500
Message-ID: <1325873687-11229-14-git-send-email-jlayton@samba.org>
References: <1325873687-11229-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325873687-11229-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...which is much more efficient than walking the keyring by hand.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   46 +---------------------------------------------
 1 files changed, 1 insertions(+), 45 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index 5c5b578..64da070 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -109,54 +109,10 @@ static key_serial_t
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
+	return keyctl_search(DEST_KEYRING, CIFS_KEY_TYPE, desc, 0);
 }
 
 /* search all program's keys in keyring */
-- 
1.7.7.4
