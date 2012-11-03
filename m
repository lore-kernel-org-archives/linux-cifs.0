From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 02/17] setcifsacl: fix overrun of subauths array when copying SIDs
Date: Sat,  3 Nov 2012 08:50:19 -0400
Message-ID: <1351947034-18876-3-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

copy_sec_desc() copies the owner and group SIDs from one security
descriptor to another. Unfortunately, it doesn't take into account the
fact that these are variable length and routinely overruns the SID
structure when doing this copy and scribbles over the destination ACL.

This wasn't noticed before the change in the maximum number of subauths
because the code either overwrote the damage afterward, or the overrun
part was the same between source and destination anyway. Now that the
max number of subauths is 15, it's more noticable.

Fix it to only copy the number of subauths that claimed in the buffer
instead.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 23ab5b1..e97a35f 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -78,7 +78,7 @@ copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 	nowner_sid_ptr->num_subauth = owner_sid_ptr->num_subauth;
 	for (i = 0; i < NUM_AUTHS; i++)
 		nowner_sid_ptr->authority[i] = owner_sid_ptr->authority[i];
-	for (i = 0; i < SID_MAX_SUB_AUTHORITIES; i++)
+	for (i = 0; i < owner_sid_ptr->num_subauth; i++)
 		nowner_sid_ptr->sub_auth[i] = owner_sid_ptr->sub_auth[i];
 
 	/* copy group sid */
@@ -89,7 +89,7 @@ copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 	ngroup_sid_ptr->num_subauth = group_sid_ptr->num_subauth;
 	for (i = 0; i < NUM_AUTHS; i++)
 		ngroup_sid_ptr->authority[i] = group_sid_ptr->authority[i];
-	for (i = 0; i < SID_MAX_SUB_AUTHORITIES; i++)
+	for (i = 0; i < group_sid_ptr->num_subauth; i++)
 		ngroup_sid_ptr->sub_auth[i] = group_sid_ptr->sub_auth[i];
 
 	return;
-- 
1.7.11.7
