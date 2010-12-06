From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Use mask of ACEs for SID Everyone to calculate all three permissions user, group, and other
Date: Mon,  6 Dec 2010 14:56:46 -0600
Message-ID: <1291669006-12102-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


If a DACL has entries for ACEs for SID Everyone and Authenticated Users,
factor in mask in respective entries during calculation of permissions
for all three, user, group, and other.

http://technet.microsoft.com/en-us/library/bb463216.aspx


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsacl.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index c6ebea0..a520091 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -43,9 +43,12 @@ static struct cifs_wksid wksidarr[NUM_WK_SIDS] = {
 ;
 
 
-/* security id for everyone */
+/* security id for everyone/world system group */
 static const struct cifs_sid sid_everyone = {
 	1, 1, {0, 0, 0, 0, 0, 1}, {0} };
+/* security id for Authenticated Users system group */
+static const struct cifs_sid sid_authusers = {
+	1, 1, {0, 0, 0, 0, 0, 5}, {11} };
 /* group users */
 static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
 
@@ -367,7 +370,7 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
 	if (num_aces  > 0) {
 		umode_t user_mask = S_IRWXU;
 		umode_t group_mask = S_IRWXG;
-		umode_t other_mask = S_IRWXO;
+		umode_t other_mask = S_IRWXU | S_IRWXG | S_IRWXO;
 
 		ppace = kmalloc(num_aces * sizeof(struct cifs_ace *),
 				GFP_KERNEL);
@@ -392,6 +395,12 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
 						     ppace[i]->type,
 						     &fattr->cf_mode,
 						     &other_mask);
+			if (compare_sids(&(ppace[i]->sid), &sid_authusers))
+				access_flags_to_mode(ppace[i]->access_req,
+						     ppace[i]->type,
+						     &fattr->cf_mode,
+						     &other_mask);
+
 
 /*			memcpy((void *)(&(cifscred->aces[i])),
 				(void *)ppace[i],
-- 
1.6.0.2
