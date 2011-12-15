From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 12/12] cifscreds: further restrict permissions on keys
Date: Thu, 15 Dec 2011 13:12:16 -0500
Message-ID: <1323972736-15804-13-git-send-email-jlayton@samba.org>
References: <1323972736-15804-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323972736-15804-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The idea with this tool is to put the credentials in the kernel so that
the kernel can use them. Restrict write permissions to the possessor only,
but allow the user to view them. That seems to be the minimum permissions
that allow the use cases we expect.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index 6079b38..8f548e9 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -300,10 +300,7 @@ static int cifscreds_add(struct cmdarg *arg)
 			fprintf(stderr, "error: Add credential key for %s\n",
 				currentaddress);
 		} else {
-			if (keyctl(KEYCTL_SETPERM, key, KEY_POS_VIEW | \
-				KEY_POS_WRITE | KEY_USR_VIEW | \
-				KEY_USR_WRITE) < 0
-			) {
+			if (keyctl(KEYCTL_SETPERM, key, KEY_POS_WRITE | KEY_USR_VIEW) < 0) {
 				fprintf(stderr, "error: Setting permissons "
 					"on key, attempt to delete...\n");
 
-- 
1.7.1
