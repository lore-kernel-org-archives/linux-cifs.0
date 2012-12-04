From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 4/6] getcifsacl: use "size" instead of reconverting original field to host endian
Date: Tue,  4 Dec 2012 10:16:42 -0500
Message-ID: <1354634204-21602-5-git-send-email-jlayton@samba.org>
References: <1354634204-21602-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354634204-21602-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 getcifsacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index 626f83c..ac3674c 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -249,11 +249,11 @@ print_ace(struct cifs_ace *pace, char *end_of_acl, int raw)
 	size = le16toh(pace->size);
 
 	/* 16 == size of cifs_ace when cifs_sid has no subauths */
-	if (le16toh(pace->size) < 16)
+	if (size < 16)
 		return;
 
 	/* validate that we do not go past end of acl */
-	if (end_of_acl < (char *)pace + le16toh(pace->size))
+	if (end_of_acl < (char *)pace + size)
 		return;
 
 	printf("ACL:");
-- 
1.7.11.7
