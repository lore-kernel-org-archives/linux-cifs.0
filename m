Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEAB0FA3743
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Oct 2022 07:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiJ2Hzs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 29 Oct 2022 03:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJ2Hzn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 29 Oct 2022 03:55:43 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA98D6BCE6
        for <linux-cifs@vger.kernel.org>; Sat, 29 Oct 2022 00:55:40 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mzs7s6vd1zpW37;
        Sat, 29 Oct 2022 15:52:09 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 29 Oct 2022 15:55:38 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>
Subject: [PATCH v2 7/7] cifs: Reset rc before free_xid()
Date:   Sat, 29 Oct 2022 17:00:11 +0800
Message-ID: <20221029090011.79367-8-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221029090011.79367-1-zhangxiaoxu5@huawei.com>
References: <20221029090011.79367-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The variable 'rc' was implicitly used by free_xid(),
should reset it to correct value before free xid.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/dir.c      |  2 ++
 fs/cifs/file.c     | 36 ++++++++++++++++++++----------------
 fs/cifs/smb2file.c |  9 +++++----
 3 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 8b1c37158556..1db20a3d981c 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -637,6 +637,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	cifs_sb = CIFS_SB(parent_dir_inode->i_sb);
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink)) {
+		rc = PTR_ERR(tlink);
 		free_xid(xid);
 		return ERR_CAST(tlink);
 	}
@@ -656,6 +657,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	full_path = build_path_from_dentry(direntry, page);
 	if (IS_ERR(full_path)) {
 		cifs_put_tlink(tlink);
+		rc = PTR_ERR(full_path);
 		free_xid(xid);
 		free_dentry_path(page);
 		return ERR_CAST(full_path);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 5b3b308e115c..238427b2aed2 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -560,7 +560,7 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file,
 int cifs_open(struct inode *inode, struct file *file)
 
 {
-	int rc = -EACCES;
+	int rc;
 	unsigned int xid;
 	__u32 oplock;
 	struct cifs_sb_info *cifs_sb;
@@ -579,14 +579,16 @@ int cifs_open(struct inode *inode, struct file *file)
 
 	cifs_sb = CIFS_SB(inode->i_sb);
 	if (unlikely(cifs_forced_shutdown(cifs_sb))) {
+		rc = -EIO;
 		free_xid(xid);
-		return -EIO;
+		return rc;
 	}
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink)) {
+		rc = PTR_ERR(tlink);
 		free_xid(xid);
-		return PTR_ERR(tlink);
+		return rc;
 	}
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
@@ -759,7 +761,7 @@ cifs_relock_file(struct cifsFileInfo *cfile)
 static int
 cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 {
-	int rc = -EACCES;
+	int rc = 0;
 	unsigned int xid;
 	__u32 oplock;
 	struct cifs_sb_info *cifs_sb;
@@ -779,7 +781,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	if (!cfile->invalidHandle) {
 		mutex_unlock(&cfile->fh_mutex);
 		free_xid(xid);
-		return 0;
+		return rc;
 	}
 
 	inode = d_inode(cfile->dentry);
@@ -798,8 +800,9 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	if (IS_ERR(full_path)) {
 		mutex_unlock(&cfile->fh_mutex);
 		free_dentry_path(page);
+		rc = PTR_ERR(full_path);
 		free_xid(xid);
-		return PTR_ERR(full_path);
+		return rc;
 	}
 
 	cifs_dbg(FYI, "inode = 0x%p file flags 0x%x for %s\n",
@@ -1337,8 +1340,8 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	 */
 	max_buf = tcon->ses->server->maxBuf;
 	if (max_buf < (sizeof(struct smb_hdr) + sizeof(LOCKING_ANDX_RANGE))) {
-		free_xid(xid);
-		return -EINVAL;
+		rc = -EINVAL;
+		goto out;
 	}
 
 	BUILD_BUG_ON(sizeof(struct smb_hdr) + sizeof(LOCKING_ANDX_RANGE) >
@@ -1349,8 +1352,8 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 						sizeof(LOCKING_ANDX_RANGE);
 	buf = kcalloc(max_num, sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
 	if (!buf) {
-		free_xid(xid);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out;
 	}
 
 	for (i = 0; i < 2; i++) {
@@ -1386,6 +1389,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	}
 
 	kfree(buf);
+out:
 	free_xid(xid);
 	return rc;
 }
@@ -1934,7 +1938,6 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	struct cifsFileInfo *cfile;
 	__u32 type;
 
-	rc = -EACCES;
 	xid = get_xid();
 
 	cifs_dbg(FYI, "%s: %pD2 cmd=0x%x type=0x%x flags=0x%x r=%lld:%lld\n", __func__, file, cmd,
@@ -1959,8 +1962,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	 */
 	if (IS_GETLK(cmd)) {
 		rc = cifs_getlk(file, flock, type, wait_flag, posix_lck, xid);
-		free_xid(xid);
-		return rc;
+		goto out;
 	}
 
 	if (!lock && !unlock) {
@@ -1968,12 +1970,13 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 		 * if no lock or unlock then nothing to do since we do not
 		 * know what it is
 		 */
-		free_xid(xid);
-		return -EOPNOTSUPP;
+		rc = -EOPNOTSUPP;
+		goto out;
 	}
 
 	rc = cifs_setlk(file, flock, type, wait_flag, posix_lck, lock, unlock,
 			xid);
+out:
 	free_xid(xid);
 	return rc;
 }
@@ -4411,8 +4414,9 @@ cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
 	server = cifs_pick_channel(tcon->ses);
 
 	if (!server->ops->sync_read) {
+		rc = -ENOSYS;
 		free_xid(xid);
-		return -ENOSYS;
+		return rc;
 	}
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index ffbd9a99fc12..420d176791c5 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -346,8 +346,8 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	 */
 	max_buf = tlink_tcon(cfile->tlink)->ses->server->maxBuf;
 	if (max_buf < sizeof(struct smb2_lock_element)) {
-		free_xid(xid);
-		return -EINVAL;
+		rc = -EINVAL;
+		goto out;
 	}
 
 	BUILD_BUG_ON(sizeof(struct smb2_lock_element) > PAGE_SIZE);
@@ -355,8 +355,8 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	max_num = max_buf / sizeof(struct smb2_lock_element);
 	buf = kcalloc(max_num, sizeof(struct smb2_lock_element), GFP_KERNEL);
 	if (!buf) {
-		free_xid(xid);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out;
 	}
 
 	list_for_each_entry(fdlocks, &cinode->llist, llist) {
@@ -366,6 +366,7 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	}
 
 	kfree(buf);
+out:
 	free_xid(xid);
 	return rc;
 }
-- 
2.31.1

