From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: handle FindFirst failure gracefully
Date: Fri, 01 Oct 2010 21:23:33 +0530
Message-ID: <4CA603FD.6040308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

FindFirst failure due to permission errors or any other errors are silently
ignored by cifs_readdir(). This could cause problem to applications that depend
on the error to do further processing.

Reproducer:
  - mount a cifs share
  - mkdir tdir;touch tdir/1 tdir/2 tdir/3
  - chmod -x tdir
  - ls tdir

Currently, we start calling filldir() for '.' and '..' before we know we
whether FindFirst could succeed or not. If FindFirst fails later, there is no
way to notify VFS by setting buf.error and so VFS won't be able to catch this.
Fix this by moving the call to initiate_cifs_search() before we start doing
filldir().

This fixes https://bugzilla.samba.org/show_bug.cgi?id=7535

Reported-by: Tom Dexter <digitalaudiorock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/readdir.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 887a7e2..edb69a9 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -786,6 +786,17 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 
+	/*
+	 * Ensure FindFirst doesn't fail before doing filldir() for '.' and
+	 * '..'. Otherwise we won't be able to notify VFS in case of failure.
+	 */
+	if (file->private_data == NULL) {
+		rc = initiate_cifs_search(xid, file);
+		cFYI(1, "initiate cifs search rc %d", rc);
+		if (rc)
+			goto rddir2_exit;
+	}
+
 	switch ((int) file->f_pos) {
 	case 0:
 		if (filldir(direntry, ".", 1, file->f_pos,
@@ -810,14 +821,6 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 			if after then keep searching till find it */
 
 		if (file->private_data == NULL) {
-			rc = initiate_cifs_search(xid, file);
-			cFYI(1, "initiate cifs search rc %d", rc);
-			if (rc) {
-				FreeXid(xid);
-				return rc;
-			}
-		}
-		if (file->private_data == NULL) {
 			rc = -EINVAL;
 			FreeXid(xid);
 			return rc;
