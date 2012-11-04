From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 18/17] setcifsacl: consolidate SID copying routines
Date: Sun,  4 Nov 2012 09:18:19 -0500
Message-ID: <1352038699-8935-1-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...instead of open-coding it thrice.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 04fa321..5016264 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -50,11 +50,22 @@ enum setcifsacl_actions {
 };
 
 static void
-copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
-		int numaces, int acessize)
+copy_cifs_sid(struct cifs_sid *dst, const struct cifs_sid *src)
 {
 	int i;
 
+	dst->revision = src->revision;
+	dst->num_subauth = src->num_subauth;
+	for (i = 0; i < NUM_AUTHS; i++)
+		dst->authority[i] = src->authority[i];
+	for (i = 0; i < src->num_subauth; i++)
+		dst->sub_auth[i] = src->sub_auth[i];
+}
+
+static void
+copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
+		int numaces, int acessize)
+{
 	int osidsoffset, gsidsoffset, dacloffset;
 	struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
 	struct cifs_sid *nowner_sid_ptr, *ngroup_sid_ptr;
@@ -81,24 +92,12 @@ copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 	/* copy owner sid */
 	owner_sid_ptr = (struct cifs_sid *)((char *)pntsd + osidsoffset);
 	nowner_sid_ptr = (struct cifs_sid *)((char *)pnntsd + osidsoffset);
-
-	nowner_sid_ptr->revision = owner_sid_ptr->revision;
-	nowner_sid_ptr->num_subauth = owner_sid_ptr->num_subauth;
-	for (i = 0; i < NUM_AUTHS; i++)
-		nowner_sid_ptr->authority[i] = owner_sid_ptr->authority[i];
-	for (i = 0; i < owner_sid_ptr->num_subauth; i++)
-		nowner_sid_ptr->sub_auth[i] = owner_sid_ptr->sub_auth[i];
+	copy_cifs_sid(nowner_sid_ptr, owner_sid_ptr);
 
 	/* copy group sid */
 	group_sid_ptr = (struct cifs_sid *)((char *)pntsd + gsidsoffset);
 	ngroup_sid_ptr = (struct cifs_sid *)((char *)pnntsd + gsidsoffset);
-
-	ngroup_sid_ptr->revision = group_sid_ptr->revision;
-	ngroup_sid_ptr->num_subauth = group_sid_ptr->num_subauth;
-	for (i = 0; i < NUM_AUTHS; i++)
-		ngroup_sid_ptr->authority[i] = group_sid_ptr->authority[i];
-	for (i = 0; i < group_sid_ptr->num_subauth; i++)
-		ngroup_sid_ptr->sub_auth[i] = group_sid_ptr->sub_auth[i];
+	copy_cifs_sid(ngroup_sid_ptr, group_sid_ptr);
 
 	return;
 }
@@ -106,18 +105,11 @@ copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 static int
 copy_ace(struct cifs_ace *dace, struct cifs_ace *sace)
 {
-	int i;
-
 	dace->type = sace->type;
 	dace->flags = sace->flags;
 	dace->access_req = sace->access_req;
 
-	dace->sid.revision = sace->sid.revision;
-	dace->sid.num_subauth = sace->sid.num_subauth;
-	for (i = 0; i < NUM_AUTHS; i++)
-		dace->sid.authority[i] = sace->sid.authority[i];
-	for (i = 0; i < sace->sid.num_subauth; i++)
-		dace->sid.sub_auth[i] = sace->sid.sub_auth[i];
+	copy_cifs_sid(&dace->sid, &sace->sid);
 
 	dace->size = sace->size;
 
-- 
1.7.11.7
