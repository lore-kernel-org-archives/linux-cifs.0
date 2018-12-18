From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] cifs: check kzalloc return
Date: Tue, 18 Dec 2018 17:27:19 +0100
Message-ID: <1545150439-26055-1-git-send-email-hofrat@osadl.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

kzalloc can return NULL so a check is needed. While there is a
check for ret_buf there is no check for the allocation of
ret_buf->crfid.fid - this check is thus added. Both call-sites
of tconInfoAlloc() check for NULL return of tconInfoAlloc()
so returning NULL on failure of kzalloc() here seems appropriate.
As the kzalloc() is the only thing here that can fail it is
moved to the beginning so as not to initialize other resources
on failure of kzalloc.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Fixes: 3d4ef9a15343 ("smb3: fix redundant opens on root")
---

Problem located with an experimental coccinelle script

While at it make checkpatch happy by using *ret_buf->crfid.fid
rather than struct cifs_fid.

Patch was compile tested with: x86_64_defconfig + CIFS=m
(with some unrelated smatch warnings and some pending cocci fixes)

Patch is against v4.20-rc7 (localversion-next is next-20181218)

 fs/cifs/misc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 8a41f4e..59efffe 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -113,6 +113,13 @@ tconInfoAlloc(void)
 	struct cifs_tcon *ret_buf;
 	ret_buf = kzalloc(sizeof(struct cifs_tcon), GFP_KERNEL);
 	if (ret_buf) {
+		ret_buf->crfid.fid = kzalloc(sizeof(*ret_buf->crfid.fid),
+					     GFP_KERNEL);
+		if (!ret_buf->crfid.fid) {
+			kfree(ret_buf);
+			return NULL;
+		}
+
 		atomic_inc(&tconInfoAllocCount);
 		ret_buf->tidStatus = CifsNew;
 		++ret_buf->tc_count;
@@ -120,8 +127,6 @@ tconInfoAlloc(void)
 		INIT_LIST_HEAD(&ret_buf->tcon_list);
 		spin_lock_init(&ret_buf->open_file_lock);
 		mutex_init(&ret_buf->crfid.fid_mutex);
-		ret_buf->crfid.fid = kzalloc(sizeof(struct cifs_fid),
-					     GFP_KERNEL);
 		spin_lock_init(&ret_buf->stat_lock);
 		atomic_set(&ret_buf->num_local_opens, 0);
 		atomic_set(&ret_buf->num_remote_opens, 0);
-- 
2.1.4
