From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 05/16] cifscreds: remove domain parm from key_add
Date: Sun, 11 Dec 2011 11:34:12 -0500
Message-ID: <1323621263-14452-6-git-send-email-jlayton@samba.org>
References: <1323621263-14452-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323621263-14452-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index c1edf71..0292bec 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -206,11 +206,9 @@ key_search_all_out:
 
 /* add or update a specific key to keyring */
 static key_serial_t
-key_add(const char *addr, const char *user,
-	const char *domain, const char *pass)
+key_add(const char *addr, const char *user, const char *pass)
 {
-	char desc[INET6_ADDRSTRLEN + MAX_USERNAME_SIZE + MAX_DOMAIN_SIZE + \
-		+ sizeof(THIS_PROGRAM_NAME) + 3];
+	char desc[INET6_ADDRSTRLEN + MAX_USERNAME_SIZE + sizeof(THIS_PROGRAM_NAME) + 3];
 
 	create_description(addr, user, desc);
 
@@ -292,8 +290,7 @@ static int cifscreds_add(int argc, char *argv[])
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		key_serial_t key = key_add(currentaddress, argv[3],
-					   argc == 5 ? argv[4] : NULL, pass);
+		key_serial_t key = key_add(currentaddress, argv[3], pass);
 		if (key <= 0) {
 			fprintf(stderr, "error: Add credential key for %s\n",
 				currentaddress);
@@ -510,8 +507,7 @@ static int cifscreds_update(int argc, char *argv[])
 	pass = getpass("Password: ");
 
 	for (id = 0; id < count; id++) {
-		key_serial_t key = key_add(addrs[id], argv[3],
-					argc == 5 ? argv[4] : NULL, pass);
+		key_serial_t key = key_add(addrs[id], argv[3], pass);
 		if (key <= 0)
 			fprintf(stderr, "error: Update credential key "
 				"for %s\n", addrs[id]);
-- 
1.7.7.3
