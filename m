From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 01/17] setcifsacl: clean up sizing of cifs_sid
Date: Sat,  3 Nov 2012 08:50:18 -0400
Message-ID: <1351947034-18876-2-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The max number of subauthorities on windows and in winbind is generally
15, not 5. If winbind sends more than 5, then this code may end up
overrunning the buffer. Also, define some preprocessor constants and
use those instead of hardcoding '5' and '6' all over the place.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifsacl.h    |  7 +++++--
 setcifsacl.c | 12 ++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/cifsacl.h b/cifsacl.h
index 101881b..f9fdc8f 100644
--- a/cifsacl.h
+++ b/cifsacl.h
@@ -96,6 +96,9 @@
 #define COMPMASK 0x8
 #define COMPALL 0xf /* COMPSID | COMPTYPE | COMPFLAG | COMPMASK */
 
+#define NUM_AUTHS (6)   /* number of authority fields */
+#define SID_MAX_SUB_AUTHORITIES (15) /* max number of sub authority fields */
+
 enum ace_action {
 	acedelete = 0,
 	acemodify,
@@ -115,8 +118,8 @@ struct cifs_ntsd {
 struct cifs_sid {
 	uint8_t revision; /* revision level */
 	uint8_t num_subauth;
-	uint8_t authority[6];
-	uint32_t sub_auth[5]; /* sub_auth[num_subauth] */
+	uint8_t authority[NUM_AUTHS];
+	uint32_t sub_auth[SID_MAX_SUB_AUTHORITIES];
 } __attribute__((packed));
 
 struct cifs_ctrl_acl {
diff --git a/setcifsacl.c b/setcifsacl.c
index 29b7b93..23ab5b1 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -76,9 +76,9 @@ copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 
 	nowner_sid_ptr->revision = owner_sid_ptr->revision;
 	nowner_sid_ptr->num_subauth = owner_sid_ptr->num_subauth;
-	for (i = 0; i < 6; i++)
+	for (i = 0; i < NUM_AUTHS; i++)
 		nowner_sid_ptr->authority[i] = owner_sid_ptr->authority[i];
-	for (i = 0; i < 5; i++)
+	for (i = 0; i < SID_MAX_SUB_AUTHORITIES; i++)
 		nowner_sid_ptr->sub_auth[i] = owner_sid_ptr->sub_auth[i];
 
 	/* copy group sid */
@@ -87,9 +87,9 @@ copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 
 	ngroup_sid_ptr->revision = group_sid_ptr->revision;
 	ngroup_sid_ptr->num_subauth = group_sid_ptr->num_subauth;
-	for (i = 0; i < 6; i++)
+	for (i = 0; i < NUM_AUTHS; i++)
 		ngroup_sid_ptr->authority[i] = group_sid_ptr->authority[i];
-	for (i = 0; i < 5; i++)
+	for (i = 0; i < SID_MAX_SUB_AUTHORITIES; i++)
 		ngroup_sid_ptr->sub_auth[i] = group_sid_ptr->sub_auth[i];
 
 	return;
@@ -106,7 +106,7 @@ copy_ace(struct cifs_ace *dace, struct cifs_ace *sace)
 
 	dace->sid.revision = sace->sid.revision;
 	dace->sid.num_subauth = sace->sid.num_subauth;
-	for (i = 0; i < 6; i++)
+	for (i = 0; i < NUM_AUTHS; i++)
 		dace->sid.authority[i] = sace->sid.authority[i];
 	for (i = 0; i < sace->sid.num_subauth; i++)
 		dace->sid.sub_auth[i] = sace->sid.sub_auth[i];
@@ -126,7 +126,7 @@ compare_aces(struct cifs_ace *sace, struct cifs_ace *dace, int compflags)
 			return 0;
 		if (dace->sid.num_subauth != sace->sid.num_subauth)
 			return 0;
-		for (i = 0; i < 6; i++) {
+		for (i = 0; i < NUM_AUTHS; i++) {
 			if (dace->sid.authority[i] != sace->sid.authority[i])
 				return 0;
 		}
-- 
1.7.11.7
