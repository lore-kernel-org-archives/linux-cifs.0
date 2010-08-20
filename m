From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 02/15] cifs: add tcon field to cifsFileInfo struct
Date: Fri, 20 Aug 2010 15:31:58 -0400
Message-ID: <1282332731-17444-3-git-send-email-jlayton@redhat.com>
References: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Eventually, we'll have more than one tcon per superblock. At that point,
we'll need to know which one is associated with a particular fid. For
now, this is just set from the cifs_sb->tcon pointer, but eventually
the caller of cifs_new_fileinfo will pass a tcon pointer in.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifsglob.h |    1 +
 fs/cifs/dir.c      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ce6538a..6bd88b9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -348,6 +348,7 @@ struct cifsFileInfo {
 	struct file *pfile; /* needed for writepage */
 	struct inode *pInode; /* needed for oplock break */
 	struct vfsmount *mnt;
+	struct cifsTconInfo *tcon;
 	struct mutex lock_mutex;
 	struct list_head llist; /* list of byte range locks we have. */
 	bool closePend:1;	/* file is marked to close */
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index f9ed075..e5dc1e8 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -153,6 +153,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
 	pCifsFile->pfile = file;
 	pCifsFile->invalidHandle = false;
 	pCifsFile->closePend = false;
+	pCifsFile->tcon = cifs_sb->tcon;
 	mutex_init(&pCifsFile->fh_mutex);
 	mutex_init(&pCifsFile->lock_mutex);
 	INIT_LIST_HEAD(&pCifsFile->llist);
-- 
1.7.2.1

