From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] cifs: handle allocation failures early
Date: Wed, 19 Dec 2018 12:58:17 +0100
Message-ID: <1545220697-29183-1-git-send-email-hofrat@osadl.org>
Cc: Joe Perches <joe@perches.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <hofrat@osadl.org>
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

kzalloc can return NULL so a check is needed. Further move the
allocation checks before the remaining initialization and bail
out without initialization if allocation failed returning NULL.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Fixes: 3d4ef9a15343 ("smb3: fix redundant opens on root")
---

Missing kzalloc check located with an experimental coccinelle script

While at it make checkpatch happy by using *ret_buf->crfid.fid
rather than struct cifs_fid and use a more common style by returning
early on the first possible failure too so the block can be unindented.

Patch was compile tested with: x86_64_defconfig + CIFS=m
(with an unrelated smatch warnings and some pending cocci fixes)

Patch is against v4.20-rc7 (localversion-next is next-20181219)

 fs/cifs/misc.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 113980d..2d4b5fb 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -111,21 +111,26 @@ struct cifs_tcon *
 tconInfoAlloc(void)
 {
 	struct cifs_tcon *ret_buf;
-	ret_buf = kzalloc(sizeof(struct cifs_tcon), GFP_KERNEL);
-	if (ret_buf) {
-		atomic_inc(&tconInfoAllocCount);
-		ret_buf->tidStatus = CifsNew;
-		++ret_buf->tc_count;
-		INIT_LIST_HEAD(&ret_buf->openFileList);
-		INIT_LIST_HEAD(&ret_buf->tcon_list);
-		spin_lock_init(&ret_buf->open_file_lock);
-		mutex_init(&ret_buf->crfid.fid_mutex);
-		ret_buf->crfid.fid = kzalloc(sizeof(struct cifs_fid),
-					     GFP_KERNEL);
-		spin_lock_init(&ret_buf->stat_lock);
-		atomic_set(&ret_buf->num_local_opens, 0);
-		atomic_set(&ret_buf->num_remote_opens, 0);
+	ret_buf = kzalloc(sizeof(*ret_buf), GFP_KERNEL);
+	if (!ret_buf)
+		return NULL;
+	ret_buf->crfid.fid = kzalloc(sizeof(*ret_buf->crfid.fid), GFP_KERNEL);
+	if (!ret_buf->crfid.fid) {
+		kfree(ret_buf);
+		return NULL;
 	}
+
+	atomic_inc(&tconInfoAllocCount);
+	ret_buf->tidStatus = CifsNew;
+	++ret_buf->tc_count;
+	INIT_LIST_HEAD(&ret_buf->openFileList);
+	INIT_LIST_HEAD(&ret_buf->tcon_list);
+	spin_lock_init(&ret_buf->open_file_lock);
+	mutex_init(&ret_buf->crfid.fid_mutex);
+	spin_lock_init(&ret_buf->stat_lock);
+	atomic_set(&ret_buf->num_local_opens, 0);
+	atomic_set(&ret_buf->num_remote_opens, 0);
+
 	return ret_buf;
 }
 
-- 
2.1.4
