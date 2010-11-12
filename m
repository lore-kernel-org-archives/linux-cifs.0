From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: don't take extra tlink reference in initiate_cifs_search
Date: Fri, 12 Nov 2010 06:30:29 -0500
Message-ID: <1289561429-2597-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's possible for initiate_cifs_search to be called on a filp that
already has private_data attached. If this happens, we'll end up
calling cifs_sb_tlink, taking an extra reference to the tlink and
attaching that to the cifsFileInfo. This leads to refcount leaks
that manifest as a "stuck" cifsd at umount time.

Fix this by only looking up the tlink for the cifsFile on the filp's
first pass through this function. When called on a filp that already
has cifsFileInfo associated with it, just use the tlink reference
that it already owns.

This patch fixes samba.org bug 7792:

    https://bugzilla.samba.org/show_bug.cgi?id=7792

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-and-Tested-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/readdir.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index c8961c5..fd0db58 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -227,26 +227,29 @@ static int initiate_cifs_search(const int xid, struct file *file)
 	char *full_path = NULL;
 	struct cifsFileInfo *cifsFile;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	struct tcon_link *tlink;
+	struct tcon_link *tlink = NULL;
 	struct cifsTconInfo *pTcon;
 
-	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink))
-		return PTR_ERR(tlink);
-	pTcon = tlink_tcon(tlink);
-
-	if (file->private_data == NULL)
-		file->private_data =
-			kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
 	if (file->private_data == NULL) {
-		rc = -ENOMEM;
-		goto error_exit;
+		tlink = cifs_sb_tlink(cifs_sb);
+		if (IS_ERR(tlink))
+			return PTR_ERR(tlink);
+
+		cifsFile = kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
+		if (cifsFile == NULL) {
+			rc = -ENOMEM;
+			goto error_exit;
+		}
+		file->private_data = cifsFile;
+		cifsFile->tlink = cifs_get_tlink(tlink);
+		pTcon = tlink_tcon(tlink);
+	} else {
+		cifsFile = file->private_data;
+		pTcon = tlink_tcon(cifsFile->tlink);
 	}
 
-	cifsFile = file->private_data;
 	cifsFile->invalidHandle = true;
 	cifsFile->srch_inf.endOfSearch = false;
-	cifsFile->tlink = cifs_get_tlink(tlink);
 
 	full_path = build_path_from_dentry(file->f_path.dentry);
 	if (full_path == NULL) {
-- 
1.7.2.3
