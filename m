From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 04/12] cifscreds: remove user parameter from create_description
Date: Thu, 15 Dec 2011 13:12:08 -0500
Message-ID: <1323972736-15804-5-git-send-email-jlayton@samba.org>
References: <1323972736-15804-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323972736-15804-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The username should be part of the key payload and not part of
the description. Also, prefix the address with an "a:" in the
description. Eventually we'll also need a "domain" key variant.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index a9181ef..a6cec98 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -85,19 +85,19 @@ static void usage(void)
 
 /* create key's description string from given credentials */
 static char *
-create_description(const char *addr, const char *user, char *desc)
+create_description(const char *addr, char *desc)
 {
 	char *str_end;
 	int str_len;
 
-	sprintf(desc, "%s:%s:%s:", THIS_PROGRAM_NAME, addr, user);
+	sprintf(desc, "%s:a:%s", THIS_PROGRAM_NAME, addr);
 
 	return desc;
 }
 
 /* search a specific key in keyring */
 static key_serial_t
-key_search(const char *addr, const char *user)
+key_search(const char *addr)
 {
 	char desc[INET6_ADDRSTRLEN + MAX_USERNAME_SIZE + \
 		+ sizeof(THIS_PROGRAM_NAME) + 3];
@@ -106,7 +106,7 @@ key_search(const char *addr, const char *user)
 	char *buffer;
 	int count, dpos, n, ret;
 
-	create_description(addr, user, desc);
+	create_description(addr, desc);
 
 	/* read the key payload data */
 	count = keyctl_read_alloc(DEST_KEYRING, &keylist);
@@ -210,7 +210,7 @@ key_add(const char *addr, const char *user, const char *pass)
 {
 	char desc[INET6_ADDRSTRLEN + MAX_USERNAME_SIZE + sizeof(THIS_PROGRAM_NAME) + 3];
 
-	create_description(addr, user, desc);
+	create_description(addr, desc);
 
 	return add_key("user", desc, pass, strnlen(pass, MOUNT_PASSWD_SIZE) + 1,
 		DEST_KEYRING);
@@ -251,7 +251,7 @@ static int cifscreds_add(int argc, char *argv[])
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		if (key_search(currentaddress, argv[3]) > 0) {
+		if (key_search(currentaddress) > 0) {
 			printf("You already have stashed credentials "
 				"for %s (%s)\n", currentaddress, argv[2]);
 			printf("If you want to update them use:\n");
@@ -349,7 +349,7 @@ static int cifscreds_clear(int argc, char *argv[])
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		key_serial_t key = key_search(currentaddress, argv[3]);
+		key_serial_t key = key_search(currentaddress);
 		if (key > 0) {
 			if (keyctl(KEYCTL_UNLINK, key, DEST_KEYRING) < 0) {
 				fprintf(stderr, "error: Removing key from "
@@ -454,7 +454,7 @@ static int cifscreds_update(int argc, char *argv[])
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		if (key_search(currentaddress, argv[3]) > 0) {
+		if (key_search(currentaddress) > 0) {
 			addrs[count] = currentaddress;
 			count++;
 		}
-- 
1.7.1
