From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 03/17] setcifsacl: clean up get_numfaces
Date: Sat,  3 Nov 2012 08:50:20 -0400
Message-ID: <1351947034-18876-4-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

pntsd is never NULL here, and get rid of extra "else" that adds some
unneeded indentation.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index e97a35f..380adac 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -329,19 +329,16 @@ get_numfaces(struct cifs_ntsd *pntsd, ssize_t acl_len,
 	struct cifs_ctrl_acl *ldaclptr;
 	char *end_of_acl = ((char *)pntsd) + acl_len;
 
-	if (pntsd == NULL)
-		return 0;
-
 	dacloffset = le32toh(pntsd->dacloffset);
 	if (!dacloffset)
 		return 0;
-	else {
-		ldaclptr = (struct cifs_ctrl_acl *)((char *)pntsd + dacloffset);
-		/* validate that we do not go past end of acl */
-		if (end_of_acl >= (char *)ldaclptr + le16toh(ldaclptr->size)) {
-			numfaces = le32toh(ldaclptr->num_aces);
-			*daclptr = ldaclptr;
-		}
+
+	ldaclptr = (struct cifs_ctrl_acl *)((char *)pntsd + dacloffset);
+
+	/* validate that we do not go past end of acl */
+	if (end_of_acl >= (char *)ldaclptr + le16toh(ldaclptr->size)) {
+		numfaces = le32toh(ldaclptr->num_aces);
+		*daclptr = ldaclptr;
 	}
 
 	return numfaces;
-- 
1.7.11.7
