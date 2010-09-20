From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/15] cifs: add tcon field to cifsFileInfo struct
Date: Mon, 20 Sep 2010 16:01:30 -0700
Message-ID: <1285023704-2159-2-git-send-email-jlayton@redhat.com>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285023704-2159-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Eventually, we'll have more than one tcon per superblock. At that point,
we'll need to know which one is associated with a particular fid. For
now, this is just set from the cifs_sb->tcon pointer, but eventually
the caller of cifs_new_fileinfo will pass a tcon pointer in.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |    1 +
 fs/cifs/dir.c      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f78e4a3..1e5a0da 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -379,6 +379,7 @@ struct cifsFileInfo {
 	struct file *pfile; /* needed for writepage */
 	struct inode *pInode; /* needed for oplock break */
 	struct vfsmount *mnt;
+	struct cifsTconInfo *tcon;
 	struct mutex lock_mutex;
 	struct list_head llist; /* list of byte range locks we have. */
 	bool closePend:1;	/* file is marked to close */
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 0f947bf..613589c 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -150,6 +150,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
 	pCifsFile->pfile = file;
 	pCifsFile->invalidHandle = false;
 	pCifsFile->closePend = false;
+	pCifsFile->tcon = cifs_sb->tcon;
 	mutex_init(&pCifsFile->fh_mutex);
 	mutex_init(&pCifsFile->lock_mutex);
 	INIT_LIST_HEAD(&pCifsFile->llist);
-- 
1.7.2.3
