From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: switch cifs_open and cifs_create to use CIFSSMBUnixSetFileInfo
Date: Tue,  4 Jan 2011 08:16:36 -0500
Message-ID: <1294146996-25591-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We call CIFSSMBUnixSetPathInfo in these functions, but we have a
filehandle since an open was just done. Switch these functions to
use CIFSSMBUnixSetFileInfo instead.

In practice, these codepaths are only used if posix opens are broken.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/dir.c  |    6 ++----
 fs/cifs/file.c |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 521d841..d9b46bf 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -293,10 +293,8 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 			args.uid = NO_CHANGE_64;
 			args.gid = NO_CHANGE_64;
 		}
-		CIFSSMBUnixSetPathInfo(xid, tcon, full_path, &args,
-					cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+		CIFSSMBUnixSetFileInfo(xid, tcon, &args, fileHandle,
+					current->tgid);
 	} else {
 		/* BB implement mode setting via Windows security
 		   descriptors e.g. */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a7b8a37..4007e60 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -424,10 +424,8 @@ int cifs_open(struct inode *inode, struct file *file)
 			.mtime	= NO_CHANGE_64,
 			.device	= 0,
 		};
-		CIFSSMBUnixSetPathInfo(xid, tcon, full_path, &args,
-				       cifs_sb->local_nls,
-				       cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+		CIFSSMBUnixSetFileInfo(xid, tcon, &args, netfid,
+					pCifsFile->pid);
 	}
 
 out:
-- 
1.7.3.4
