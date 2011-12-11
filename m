From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 15/16] cifscreds: further restrict permissions on keys
Date: Sun, 11 Dec 2011 11:34:22 -0500
Message-ID: <1323621263-14452-16-git-send-email-jlayton@samba.org>
References: <1323621263-14452-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323621263-14452-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The idea with this tool is to put the credentials in the kernel so that
the kernel can use them. Restrict permissions to the posessor only.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index 3d40540..1e9bb6e 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -256,10 +256,7 @@ static int cifscreds_add(struct cmdarg *arg)
 			fprintf(stderr, "error: Add credential key for %s\n",
 				currentaddress);
 		} else {
-			if (keyctl(KEYCTL_SETPERM, key, KEY_POS_VIEW | \
-				KEY_POS_WRITE | KEY_POS_SEARCH | KEY_USR_VIEW | \
-				KEY_USR_WRITE | KEY_USR_SEARCH) < 0
-			) {
+			if (keyctl(KEYCTL_SETPERM, key, KEY_POS_VIEW | KEY_POS_WRITE | KEY_POS_SEARCH) < 0) {
 				fprintf(stderr, "error: Setting permissons "
 					"on key, attempt to delete...\n");
 
-- 
1.7.7.3
