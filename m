From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 14/17] getcifsacl: clarify magic number if print_ace
Date: Sat,  3 Nov 2012 08:50:31 -0400
Message-ID: <1351947034-18876-15-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 getcifsacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index da4bb67..083705c 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -208,11 +208,11 @@ print_sid_raw:
 static void
 print_ace(struct cifs_ace *pace, char *end_of_acl, int raw)
 {
-	/* validate that we do not go past end of acl */
-
+	/* 16 == size of cifs_ace sans the cifs_sid */
 	if (le16toh(pace->size) < 16)
 		return;
 
+	/* validate that we do not go past end of acl */
 	if (end_of_acl < (char *)pace + le16toh(pace->size))
 		return;
 
-- 
1.7.11.7
