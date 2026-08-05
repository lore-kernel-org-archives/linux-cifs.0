Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4601F3CDBBD
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 05:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785906757; cv=none; b=A3600B3PCCeiY7GNVvk499YOYvhxDLF+Z88OE3afUA/EU3zt2TsTQW4VmexcNexKqlCVMy/pT+VKuqUBz9K/1HICIhX178uEgecyRq1wjfIlx7lNb88T9UCsW38r5Gjpxym/SN3FgOElkWu7JajnNO5ndVIpaAXJm50jepCwHAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785906757; c=relaxed/simple;
	bh=MREyjqQaU4IkohFlOxaAXmeLs+tcKDQe+jBKSRY7FqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPFPPc25oiyxxwLXBXFUG7V/8FKk7kxvGzyHNwbmdlI8GKPspN5BVyEgjskxi4bU27yn7QOdB2bf+WbUq9j4CNqwtSvG3nLZ9oIYbQj/qeSfkl84TXNvZNRbU4Odoq+HQgsr3Uagi5g9azrQhEeJszysMtuiUAUHuGwg5RfGsIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=YsZF+Xqn; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="YsZF+Xqn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785906752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7J6JPrtYnZJVMxelnglRKAmNmK9iKnnkldW/2uK9FwE=;
	b=YsZF+XqncTWafrAgzSCPhX0dCTtQQTaRgKKsiqSdKPNPXpEegjaX9QAnB+WPQqnVIY56CV
	+9eFnfWJIF7Nsz5VQgD29vRuSTb86rDav1LwGtT4IxdGICyu99zK4MyVZJ3QUOSg3IpQZj
	dYw5q3VNLpEGcjYy6Pt2BaQv2WqJmHp47l2jBifmVgsOND7fGfI9qbtm+ilN+ljbI7bIWY
	XDPHdDGNhQnHA+euxAbFuUEeObeijZbrv7kG/Olt+DJqKzyConS/YEaknfYhWITQQ5jrNr
	BwOzyBPraoL685vdWUIOUDBttvFXGFg1egkDJYi+jQI3Q+DPfsXtaLLnA8sYWw==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 resend 3/3] smb/client: fix nlink of an overwritten open file
Date: Wed,  5 Aug 2026 05:11:12 +0000
Message-ID: <20260805051112.305078-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260805051112.305078-1-chenxiaosong@chenxiaosong.com>
References: <20260805051112.305078-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Reproducer:

  1. server: systemctl start ksmbd
  2. client: mount with `posix` option
     mount -t cifs -o posix //${server_ip}/export /mnt
  3. client: touch /mnt/file1 /mnt/file2
  4. client: C program: int fd = open("/mnt/file2", O_RDONLY);
  5. client: C program: rename("/mnt/file1", "/mnt/file2");
  6. client: C program: struct stat stbuf; fstat(fd, &stbuf);
                        stbuf.st_nlink is 1, should be 0

This patch fixes xfstests generic/035 when mounted with `posix` option.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/inode.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 0afff761aab9..0b6273ce01a8 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2648,11 +2648,8 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	if (d_really_is_positive(target_dentry)) {
 		if (!rc) {
 			struct inode *inode = d_inode(target_dentry);
-			/*
-			 * Samba and ksmbd servers allow renaming a target
-			 * directory that is open, so make sure to update
-			 * ->i_nlink and then mark it as delete pending.
-			 */
+
+			/* Update the target link count after rename. */
 			if (S_ISDIR(inode->i_mode)) {
 				drop_cached_dir_by_name(xid, tcon, to_name, cifs_sb);
 				spin_lock(&inode->i_lock);
@@ -2663,6 +2660,10 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 				CIFS_I(inode)->time = 0; /* force reval */
 				inode_set_ctime_current(inode);
 				inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+			} else {
+				cifs_mark_open_handles_for_deleted_file(inode, to_name);
+				cifs_drop_nlink(inode);
+				inode_set_ctime_current(inode);
 			}
 		} else if (rc == -EACCES || rc == -EEXIST) {
 			/*
-- 
2.54.0

