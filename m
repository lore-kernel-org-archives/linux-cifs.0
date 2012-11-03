From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 05/17] setcifsacl: declare an enum for the action values
Date: Sat,  3 Nov 2012 08:50:22 -0400
Message-ID: <1351947034-18876-6-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...instead of relying on magic values of an int.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 50822e6..71b065c 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -41,6 +41,14 @@
 
 static const char *prog;
 
+enum setcifsacl_actions {
+	ActUnknown = -1,
+	ActDelete,
+	ActModify,
+	ActAdd,
+	ActSet
+};
+
 static void
 copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 		int numaces, int acessize)
@@ -708,24 +716,24 @@ static int
 setacl_action(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd,
 		ssize_t *bufsize, struct cifs_ace **facesptr, int numfaces,
 		struct cifs_ace **cacesptr, int numcaces,
-		int maction)
+		enum setcifsacl_actions maction)
 {
 	int rc = 1;
 
 	switch (maction) {
-	case 0:
+	case ActDelete:
 		rc = ace_delete(pntsd, npntsd, bufsize, facesptr,
 				numfaces, cacesptr, numcaces);
 		break;
-	case 1:
+	case ActModify:
 		rc = ace_modify(pntsd, npntsd, bufsize, facesptr,
 				numfaces, cacesptr, numcaces);
 		break;
-	case 2:
+	case ActAdd:
 		rc = ace_add(pntsd, npntsd, bufsize, facesptr,
 				numfaces, cacesptr, numcaces);
 		break;
-	case 3:
+	case ActSet:
 		rc = ace_set(pntsd, npntsd, bufsize, cacesptr, numcaces);
 		break;
 	default:
@@ -768,7 +776,8 @@ setcifsacl_usage(void)
 int
 main(const int argc, char *const argv[])
 {
-	int i, rc, c, numcaces, numfaces, maction = -1;
+	int i, rc, c, numcaces, numfaces;
+	enum setcifsacl_actions maction = ActUnknown;
 	ssize_t attrlen, bufsize = BUFSIZE;
 	char *filename, *attrval, **arrptr = NULL;
 	struct cifs_ctrl_acl *daclptr = NULL;
@@ -785,16 +794,16 @@ main(const int argc, char *const argv[])
 		printf("Version: %s\n", VERSION);
 		goto out;
 	case 'D':
-		maction = 0;
+		maction = ActDelete;
 		break;
 	case 'M':
-		maction = 1;
+		maction = ActModify;
 		break;
 	case 'a':
-		maction = 2;
+		maction = ActAdd;
 		break;
 	case 'S':
-		maction = 3;
+		maction = ActSet;
 		break;
 	case '?':
 		setcifsacl_usage();
@@ -849,7 +858,7 @@ cifsacl:
 	}
 
 	numfaces = get_numfaces((struct cifs_ntsd *)attrval, attrlen, &daclptr);
-	if (!numfaces && maction != 2) { /* if we are not adding aces */
+	if (!numfaces && maction != ActAdd) { /* if we are not adding aces */
 		printf("%s: Empty DACL\n", __func__);
 		goto setcifsacl_facenum_ret;
 	}
-- 
1.7.11.7
