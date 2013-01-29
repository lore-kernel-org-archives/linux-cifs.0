From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] setcifsacl: fix offset calculation in "set" code
Date: Tue, 29 Jan 2013 07:17:53 -0500
Message-ID: <1359461873-9222-1-git-send-email-jlayton@samba.org>
Cc: jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Previously the code assumed that the ACE that was copied was of a
fixed size. Save off the return value from copy_ace and ensure that
we apply it correctly to the size and offset.

Reported-by: Jian Li <jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 7f92b91..67dd29c 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -183,7 +183,7 @@ static int
 ace_set(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd, ssize_t *bufsize,
 			struct cifs_ace **cacesptr, int numcaces)
 {
-	int i, rc, acessize = 0;
+	int i, rc, size = 0, acessize = 0;
 	size_t acesoffset;
 	char *acesptr;
 
@@ -193,8 +193,9 @@ ace_set(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd, ssize_t *bufsize,
 
 	acesptr = (char *)*npntsd + acesoffset;
 	for (i = 0; i < numcaces; ++i) {
-		acessize += copy_ace((struct cifs_ace *)acesptr, cacesptr[i]);
-		acesptr += sizeof(struct cifs_ace);
+		size = copy_ace((struct cifs_ace *)acesptr, cacesptr[i]);
+		acessize += size;
+		acesptr += size;
 	}
 	copy_sec_desc(pntsd, *npntsd, numcaces, acessize);
 	acesptr = (char *)*npntsd + acesoffset;
-- 
1.7.11.7
