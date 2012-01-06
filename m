From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 12/15] cifscreds: make cifscreds use the "unreadable" keyring
Date: Fri,  6 Jan 2012 13:14:44 -0500
Message-ID: <1325873687-11229-13-git-send-email-jlayton@samba.org>
References: <1325873687-11229-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325873687-11229-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and have it loosen the permissions to allow searching. There seems
to be no clear way to make user keys unreadable, but still allow for
them to be searched, so we'll need a new key_type that doesn't allow
you to read the payload from userspace. That will be proposed in a
separate kernel patch.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index 6079b38..5c5b578 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -52,6 +52,9 @@
 
 /* destination keyring */
 #define DEST_KEYRING KEY_SPEC_SESSION_KEYRING
+#define CIFS_KEY_TYPE  "secret"
+#define CIFS_KEY_PERMS (KEY_POS_VIEW|KEY_POS_WRITE|KEY_POS_SEARCH| \
+			KEY_USR_VIEW|KEY_USR_WRITE|KEY_USR_SEARCH)
 
 struct cmdarg {
 	char		*host;
@@ -223,7 +226,7 @@ key_add(const char *addr, const char *user, const char *pass, char keytype)
 	/* set payload contents */
 	len = sprintf(val, "%s:%s", user, pass);
 
-	return add_key("user", desc, val, len + 1, DEST_KEYRING);
+	return add_key(CIFS_KEY_TYPE, desc, val, len + 1, DEST_KEYRING);
 }
 
 /* add command handler */
@@ -300,10 +303,7 @@ static int cifscreds_add(struct cmdarg *arg)
 			fprintf(stderr, "error: Add credential key for %s\n",
 				currentaddress);
 		} else {
-			if (keyctl(KEYCTL_SETPERM, key, KEY_POS_VIEW | \
-				KEY_POS_WRITE | KEY_USR_VIEW | \
-				KEY_USR_WRITE) < 0
-			) {
+			if (keyctl(KEYCTL_SETPERM, key, CIFS_KEY_PERMS) < 0) {
 				fprintf(stderr, "error: Setting permissons "
 					"on key, attempt to delete...\n");
 
-- 
1.7.7.4
