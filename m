Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4685E36F413;
	Tue, 23 Jun 2026 02:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782180811; cv=none; b=G5DtYSLQCo+Kro211cqa5YMvA5ARBdVoyPPsk+G2HhxaeBIJBsTajkXXa4H7OgYvwVywucnkGm27/xCXdieERnAY/d6UX4JEQSswzGUhuMbf2UNNZeMouPgFYIrdFUk1ADS8wFa50jzWFnjDRl94asvi6xFiO+c8Pb2X/FA43XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782180811; c=relaxed/simple;
	bh=rQwzdUC4ljCkyFyP5snioMZyVKXuylqgwg+K3vk3WSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQWcLhqimkEGMFhsgFk9Swe3gL3ENtx8taqDmfOu+J8wr1jNn0hZK4ePTBBqbSU/pkjRXhWzQqRUU3fDPcPEM/T0Bh3eQ8SLcJdeVhcXXLF1nE6KRv5QBvgbyi9LA9VE7cTwTPPlWdRUIk66/BzSw1f/izuid+9qlIhNnbvSXgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=nWn/CQhK; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="nWn/CQhK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=cK
	qsCv2sIAiZnNH9CaKbl7vdrhv3ITaRRFy3/89D34Y=; b=nWn/CQhKz177zm4Fkz
	4H5EVhv0QxjIPsn9QlEqW0qW12OOZcjyoboRZ1jErTgrSYFWk/PpBHHZ5zvrt+Io
	zmWUcOLsWCy1PFRY4hHXRXFDKhdSnpKfBsZUkaDB3T8qsRGaen/m8+V/xgTqgBd1
	0Rp3E4Z+qudRkqQNK6cBNS6s0=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wBHoRic6zlqtQaHEg--.49611S4;
	Tue, 23 Jun 2026 10:13:04 +0800 (CST)
From: liuqiangneo@163.com
To: linkinjeon@kernel.org,
	smfrench@gmail.com,
	chenxiaosong@kylinos.cn,
	senozhatsky@chromium.org,
	tom@talpey.com
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuqiangneo@163.com,
	Qiang Liu <liuqiang@kylinos.cn>
Subject: [PATCH 2/3] ksmbd: fix acl.sd_buf memory leak in ksmbd_vfs_get_sd_xattr
Date: Tue, 23 Jun 2026 10:12:37 +0800
Message-ID: <20260623021240.34722-3-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623021240.34722-1-liuqiangneo@163.com>
References: <20260623021240.34722-1-liuqiangneo@163.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHoRic6zlqtQaHEg--.49611S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxJrWrGw1rtr4xJFWDJrWrKrg_yoW8JF43pF
	WUX34jkrW3Zr1IqrykKrZ5u3Wag34vga15WrWfJw4akws7t3WrZFyFyr909r1q9a18W3ZF
	qr4qvw1093WrKaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRTCJQUUUUU=
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC3xAQcWo567C1UgAA3B

From: Qiang Liu <liuqiang@kylinos.cn>

Zero-initialize xattr_ntacl struct and reorder error cleanup labels
to ensure acl.sd_buf is released on all error paths.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
---
 fs/smb/server/vfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index febe9f7b54c3..60b4210d5ab8 100644
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
 
@@ -1533,6 +1533,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	*pntsd = acl.sd_buf;
 	if (acl.sd_size < sizeof(struct smb_ntsd)) {
 		pr_err("sd size is invalid\n");
+		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -1548,12 +1549,12 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	kfree(acl_ndr.data);
 	kfree(smb_acl);
 	kfree(def_smb_acl);
+
+free_n_data:
 	if (rc < 0) {
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

