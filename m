From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: convert prefixpath delimiters in cifs_build_path_to_root
Date: Fri,  5 Aug 2011 10:28:01 -0400
Message-ID: <1312554481-1886-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Regression from 2.6.39...

The delimiters in the prefixpath are not being converted based on
whether posix paths are in effect. Fixes:

    https://bugzilla.redhat.com/show_bug.cgi?id=727834

Reported-and-Tested-by: Iain Arnell <iarnell-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Patrick Oltmann <patrick.oltmann-hi6Y0CQ0nG0@public.gmane.org>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/inode.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 9b018c8..a7b2dcd 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -764,20 +764,10 @@ char *cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 	if (full_path == NULL)
 		return full_path;
 
-	if (dfsplen) {
+	if (dfsplen)
 		strncpy(full_path, tcon->treeName, dfsplen);
-		/* switch slash direction in prepath depending on whether
-		 * windows or posix style path names
-		 */
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) {
-			int i;
-			for (i = 0; i < dfsplen; i++) {
-				if (full_path[i] == '\\')
-					full_path[i] = '/';
-			}
-		}
-	}
 	strncpy(full_path + dfsplen, vol->prepath, pplen);
+	convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
 	full_path[dfsplen + pplen] = 0; /* add trailing null */
 	return full_path;
 }
-- 
1.7.6
