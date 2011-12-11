From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 04/16] cifscreds: eliminate domain parm from key_search
Date: Sun, 11 Dec 2011 11:34:11 -0500
Message-ID: <1323621263-14452-5-git-send-email-jlayton@samba.org>
References: <1323621263-14452-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323621263-14452-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index c86c1f9..c1edf71 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -97,9 +97,9 @@ create_description(const char *addr, const char *user, char *desc)
 
 /* search a specific key in keyring */
 static key_serial_t
-key_search(const char *addr, const char *user, const char *domain)
+key_search(const char *addr, const char *user)
 {
-	char desc[INET6_ADDRSTRLEN + MAX_USERNAME_SIZE + MAX_DOMAIN_SIZE + \
+	char desc[INET6_ADDRSTRLEN + MAX_USERNAME_SIZE + \
 		+ sizeof(THIS_PROGRAM_NAME) + 3];
 	key_serial_t key, *pk;
 	void *keylist;
@@ -262,9 +262,7 @@ static int cifscreds_add(int argc, char *argv[])
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		if (key_search(currentaddress, argv[3],
-			argc == 5 ? argv[4] : NULL) > 0
-		) {
+		if (key_search(currentaddress, argv[3]) > 0) {
 			printf("You already have stashed credentials "
 				"for %s (%s)\n", currentaddress, argv[2]);
 			printf("If you want to update them use:\n");
@@ -372,8 +370,7 @@ static int cifscreds_clear(int argc, char *argv[])
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		key_serial_t key = key_search(currentaddress, argv[3],
-						argc == 5 ? argv[4] : NULL);
+		key_serial_t key = key_search(currentaddress, argv[3]);
 		if (key > 0) {
 			if (keyctl(KEYCTL_UNLINK, key, DEST_KEYRING) < 0) {
 				fprintf(stderr, "error: Removing key from "
@@ -487,9 +484,7 @@ static int cifscreds_update(int argc, char *argv[])
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		if (key_search(currentaddress, argv[3],
-			argc == 5 ? argv[4] : NULL) > 0
-		) {
+		if (key_search(currentaddress, argv[3]) > 0) {
 			addrs[count] = currentaddress;
 			count++;
 		}
-- 
1.7.7.3
