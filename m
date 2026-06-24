Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60044311C2C
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 01:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782263678; cv=none; b=Sdjnxxmw3Zd+LB/oEflXVLKr4rw4Lz+c9dD3OQYLy7LbLSjzzpNeOA+pFbTTRYOjh1BF/XtwFzPWBVVydnUFZdYk3i35AJG0K6icd4cfCIsIrzQRuVJvpRPxkpbXvHaKXXq7au7wLvWhiIbPN5zcDGZ6ohs7r4JT2MZsTH1RCwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782263678; c=relaxed/simple;
	bh=d+3QlX2a4q6fPafZRAXJ51utS/lI4Mp98t0SkLdDWIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AznvWXYhcDilBwsGrtxWawyeKFgJ7amhP0ZwslEmtWXuLu/r6OjrRacD07W8aT1492HBU5lmsBYnNi8/v0qbkkKPkys1MUjyB5G3LL32ZEhue40nU8RDJQAJHbNJs7GfDVLG5GSRzbWkNfNyMpJzrinAYseRqW02EOjWhmTiM1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=oSsmzOMq; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="oSsmzOMq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=JT
	ixbJQFQ1oSu/BW798ZDFDa43aUhwptAO36cNOVs2s=; b=oSsmzOMqO2Nx0nlwCW
	0eSYHPS0K0galk6hzaUvGuSyx9o8txa8pBivVrZq+3IKYIT7xJEaYPHAwPjJWVgq
	Rar/3lLpmp0sDTW4hos3NoBWQclgCjuYH1BCC6hTRpR/VZRBtMVm2HmWyxAHw8IE
	Oa0N/F7hbbalD6MotW8XEyCWY=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wCXb24yLztqsdWDFQ--.18691S4;
	Wed, 24 Jun 2026 09:13:28 +0800 (CST)
From: liuqiangneo@163.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 2/3] ksmbd: Fix acl.sd_buf memory leak and invalid sd_size error handling
Date: Wed, 24 Jun 2026 09:13:19 +0800
Message-ID: <20260624011320.9146-3-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260624011320.9146-1-liuqiangneo@163.com>
References: <20260624011320.9146-1-liuqiangneo@163.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXb24yLztqsdWDFQ--.18691S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7uFWfCw1fAF48tw4DKF17Jrb_yoW8CF18pF
	WYv34jkrWrury8XrykKrZ8Ca4a9a4vga15GFWFgw1ayrsrt3ZYvFZYyr90kr1kua1kX3ZF
	qr4qvr1Ik3WrKaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jxF4_UUUUU=
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC4BhDpGo7Lzhx3AAA30

From: Qiang Liu <liuqiang@kylinos.cn>

1. When ndr_decode_v4_ntacl() fails, the code jumped to free_n_data
   which only freed n.data, skipping kfree(acl.sd_buf) and leaking
   the buffer. Zero-initialize struct xattr_ntacl acl, reorder error
   labels to out_free to release acl.sd_buf on all error paths.

2. if (acl.sd_size < sizeof(struct smb_ntsd)) is true, original code
   returned success without freeing sd_buf and left stale *pntsd.
   Set rc = -EINVAL before jumping to out_free to return error code and
   free buffer.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/vfs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index febe9f7b54c3..7ccc9eb87692 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1496,7 +1496,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	struct ndr n;
 	struct inode *inode = d_inode(dentry);
 	struct ndr acl_ndr = {0};
-	struct xattr_ntacl acl;
+	struct xattr_ntacl acl = {0};
 	struct xattr_smb_acl *smb_acl = NULL, *def_smb_acl = NULL;
 	__u8 cmp_hash[XATTR_SD_HASH_SIZE] = {0};
 
@@ -1507,7 +1507,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	n.length = rc;
 	rc = ndr_decode_v4_ntacl(&n, &acl);
 	if (rc)
-		goto free_n_data;
+		goto out_free;
 
 	smb_acl = ksmbd_vfs_make_xattr_posix_acl(idmap, inode,
 						 ACL_TYPE_ACCESS);
@@ -1533,6 +1533,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	*pntsd = acl.sd_buf;
 	if (acl.sd_size < sizeof(struct smb_ntsd)) {
 		pr_err("sd size is invalid\n");
+		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -1552,8 +1553,6 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 		kfree(acl.sd_buf);
 		*pntsd = NULL;
 	}
-
-free_n_data:
 	kfree(n.data);
 	return rc;
 }
-- 
2.43.0

