From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 05/15] cifscreds: make username part of value instead of description
Date: Fri,  6 Jan 2012 13:14:37 -0500
Message-ID: <1325873687-11229-6-git-send-email-jlayton@samba.org>
References: <1325873687-11229-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325873687-11229-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Change the payload to be "username:password". Since usernames can't
contain ':', this is suitable delimiter. Also, create_description
is just a sprintf now, so eliminate it.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index a6cec98..b6c1fb6 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -83,30 +83,17 @@ static void usage(void)
 	exit(EXIT_FAILURE);
 }
 
-/* create key's description string from given credentials */
-static char *
-create_description(const char *addr, char *desc)
-{
-	char *str_end;
-	int str_len;
-
-	sprintf(desc, "%s:a:%s", THIS_PROGRAM_NAME, addr);
-
-	return desc;
-}
-
 /* search a specific key in keyring */
 static key_serial_t
 key_search(const char *addr)
 {
-	char desc[INET6_ADDRSTRLEN + MAX_USERNAME_SIZE + \
-		+ sizeof(THIS_PROGRAM_NAME) + 3];
+	char desc[INET6_ADDRSTRLEN + sizeof(THIS_PROGRAM_NAME) + 4];
 	key_serial_t key, *pk;
 	void *keylist;
 	char *buffer;
 	int count, dpos, n, ret;
 
-	create_description(addr, desc);
+	sprintf(desc, "%s:a:%s", THIS_PROGRAM_NAME, addr);
 
 	/* read the key payload data */
 	count = keyctl_read_alloc(DEST_KEYRING, &keylist);
@@ -208,12 +195,17 @@ key_search_all_out:
 static key_serial_t
 key_add(const char *addr, const char *user, const char *pass)
 {
-	char desc[INET6_ADDRSTRLEN + MAX_USERNAME_SIZE + sizeof(THIS_PROGRAM_NAME) + 3];
+	int len;
+	char desc[INET6_ADDRSTRLEN + sizeof(THIS_PROGRAM_NAME) + 4];
+	char val[MOUNT_PASSWD_SIZE +  MAX_USERNAME_SIZE + 2];
+
+	/* set key description */
+	sprintf(desc, "%s:a:%s", THIS_PROGRAM_NAME, addr);
 
-	create_description(addr, desc);
+	/* set payload contents */
+	len = sprintf(val, "%s:%s", user, pass);
 
-	return add_key("user", desc, pass, strnlen(pass, MOUNT_PASSWD_SIZE) + 1,
-		DEST_KEYRING);
+	return add_key("user", desc, val, len + 1, DEST_KEYRING);
 }
 
 /* add command handler */
-- 
1.7.7.4
