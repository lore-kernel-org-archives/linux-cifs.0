From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/2] setcifsacl: fix some bugs in build_fetched_aces
Date: Tue,  6 Nov 2012 10:31:18 -0500
Message-ID: <1352215879-11451-1-git-send-email-jlayton@samba.org>
Cc: praiskup-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel Raiskup reported the following defects that he found with Coverity:

"If the variable 'facesptr' on line cifs-utils-4.8.1/setcifsacl.c|365|
has not enough memory to be allocated, program 'setcifsacl' will fail
with segfault on line 365 (dereferencing facesptr)."

"you may return freed pointer here. There is some kind of return code
('rc') which should be transferred to >NULL< when is rc nonzero (and
returned)"

There are also a couple of ther bugs here:

malloc doesn't necessarily set errno to anything when an allocation
fails, so having the error handling rely on that is wrong.

Fix all of these bugs by reorganzing this function to fix up the error
handling.

Reported-by: Pavel Raiskup <praiskup-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 5016264..9dfdad7 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -347,26 +347,23 @@ get_numfaces(struct cifs_ntsd *pntsd, ssize_t acl_len,
 static struct cifs_ace **
 build_fetched_aces(char *daclptr, int numfaces)
 {
-	int i, j, rc = 0, acl_size;
+	int i, j, acl_size;
 	char *acl_base;
 	struct cifs_ace *pace, **facesptr;
 
-	facesptr = (struct cifs_ace **)malloc(numfaces *
-					sizeof(struct cifs_aces *));
+	facesptr = calloc(numfaces, sizeof(struct cifs_aces *));
 	if (!facesptr) {
 		printf("%s: Error %d allocating ACE array",
 				__func__, errno);
-		rc = errno;
+		return facesptr;
 	}
 
 	acl_base = daclptr;
 	acl_size = sizeof(struct cifs_ctrl_acl);
 	for (i = 0; i < numfaces; ++i) {
 		facesptr[i] = malloc(sizeof(struct cifs_ace));
-		if (!facesptr[i]) {
-			rc = errno;
-			goto build_fetched_aces_ret;
-		}
+		if (!facesptr[i])
+			goto build_fetched_aces_err;
 		pace = (struct cifs_ace *) (acl_base + acl_size);
 		memcpy(facesptr[i], pace, sizeof(struct cifs_ace));
 		acl_base = (char *)pace;
@@ -374,15 +371,17 @@ build_fetched_aces(char *daclptr, int numfaces)
 	}
 
 build_fetched_aces_ret:
-	if (rc) {
-		printf("%s: Invalid fetched ace\n", __func__);
-		if (i) {
-			for (j = i; j >= 0; --j)
-				free(facesptr[j]);
-		}
-		free(facesptr);
-	}
 	return facesptr;
+
+build_fetched_aces_err:
+	printf("%s: Invalid fetched ace\n", __func__);
+	if (i) {
+		for (j = i; j >= 0; --j)
+			free(facesptr[j]);
+	}
+	free(facesptr);
+	facesptr = NULL;
+	goto build_fetched_aces_ret;
 }
 
 static int
-- 
1.7.11.7
