Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C9E1373;
	Mon,  7 Jul 2025 01:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751851595; cv=none; b=KxCoIDE+xmlGRVQqAt0f6zwCcPhuiEBedZFJC1x4yi8MZiVZ3tdv03SjrJ0UY/Qei/r/v4arwdHiSK4le/kh/MIL7VlE72dLYx5CBgo46mX6rii1tpktuHhwRvB64VY9ysogNS8g5Hm/SUHiaz+1y8gfhvP17IKOQxoitsdk1ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751851595; c=relaxed/simple;
	bh=F99Y9Nl0L+tPWONLGzd7cu1Iv6bSj6id5Kb4yAQhMxo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=c/rI9SuT9ZaFuBJPttcnD4BAFY2x6FyOe2vSQClHewg3TXtz+jPIkEAxEoQBRT7ew14JHUKRQYelTuvNwUe0a1T/0IRWeVtMy+gi4xeUuzbiWND9SEBTEBYss8NK+rnryF0SsbpBfbUHu56RAUNyxTdwwh44VoUPr0Rgj58H84Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bb5k26d8czYQtnf;
	Mon,  7 Jul 2025 09:09:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id BB9571A0DC4;
	Mon,  7 Jul 2025 09:09:29 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
	by APP3 (Coremail) with SMTP id _Ch0CgB32SZGHmto0L6PAw--.34564S4;
	Mon, 07 Jul 2025 09:09:28 +0800 (CST)
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
To: sfrench@samba.org,
	pshilov@microsoft.com,
	aaptel@suse.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V2] smb: client: fix use-after-free in cifs_oplock_break
Date: Mon,  7 Jul 2025 09:09:26 +0800
Message-Id: <20250707010926.31623-1-wangzhaolong@huaweicloud.com>
X-Mailer: git-send-email 2.34.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB32SZGHmto0L6PAw--.34564S4
X-Coremail-Antispam: 1UD129KBjvJXoWxAF4kGF4kuFy5uFW5JFyxXwb_yoW5Zr1kpF
	13tr15Gr45GryUuwsaqF4ru3W3t3WkWa1F9ry8uw1Sy3sxA3ySgF4Fyr129F4SqFWkAr1q
	gF4jg3yqvF1UArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/

A race condition can occur in cifs_oplock_break() leading to a
use-after-free of the cinode structure when unmounting:

  cifs_oplock_break()
    _cifsFileInfo_put(cfile)
      cifsFileInfo_put_final()
        cifs_sb_deactive()
          [last ref, start releasing sb]
            kill_sb()
              kill_anon_super()
                generic_shutdown_super()
                  evict_inodes()
                    dispose_list()
                      evict()
                        destroy_inode()
                          call_rcu(&inode->i_rcu, i_callback)
    spin_lock(&cinode->open_file_lock)  <- OK
                            [later] i_callback()
                              cifs_free_inode()
                                kmem_cache_free(cinode)
    spin_unlock(&cinode->open_file_lock)  <- UAF
    cifs_done_oplock_break(cinode)       <- UAF

The issue occurs when umount has already released its reference to the
superblock. When _cifsFileInfo_put() calls cifs_sb_deactive(), this
releases the last reference, triggering the immediate cleanup of all
inodes under RCU. However, cifs_oplock_break() continues to access the
cinode after this point, resulting in use-after-free.

Fix this by holding an extra reference to the superblock during the
entire oplock break operation. This ensures that the superblock and
its inodes remain valid until the oplock break completes.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220309
Fixes: b98749cac4a6 ("CIFS: keep FileInfo handle live during oplock break")
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
---
 fs/smb/client/file.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

V1 -> V2:
Correct the commit message call stack

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index e9212da32f01..1421bde045c2 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3086,20 +3086,27 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file,
 void cifs_oplock_break(struct work_struct *work)
 {
 	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
 						  oplock_break);
 	struct inode *inode = d_inode(cfile->dentry);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct super_block *sb = inode->i_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
 	struct tcon_link *tlink;
 	int rc = 0;
 	bool purge_cache = false, oplock_break_cancelled;
 	__u64 persistent_fid, volatile_fid;
 	__u16 net_fid;
 
+	/*
+	 * Hold a reference to the superblock to prevent it and its inodes from
+	 * being freed while we are accessing cinode. Otherwise, _cifsFileInfo_put()
+	 * may release the last reference to the sb and trigger inode eviction.
+	 */
+	cifs_sb_active(sb);
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
@@ -3168,10 +3175,11 @@ void cifs_oplock_break(struct work_struct *work)
 		spin_unlock(&cinode->open_file_lock);
 
 	cifs_put_tlink(tlink);
 out:
 	cifs_done_oplock_break(cinode);
+	cifs_sb_deactive(sb);
 }
 
 static int cifs_swap_activate(struct swap_info_struct *sis,
 			      struct file *swap_file, sector_t *span)
 {
-- 
2.34.3

