Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35576379C2F;
	Tue, 23 Jun 2026 02:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782180812; cv=none; b=EKyiDc3vfOsMgL5u79LD7HlyA1k2u3bOp/PgG4vj8toTFUgkJPmrvglTBsGykiJQk3t8B9B+6lQLARnNQyue9p61O4LvBuKK7ckJxoua/BGQzqUMsYLNH3UjkT1Kr/NP78NLDSka0Sg2o1wYGHzPCvcQDX9FgZOhmuYKtsxgs14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782180812; c=relaxed/simple;
	bh=x1XwVFwRH6ADcEKsCCdi/BqRnq4o51zLZq/oMG4SAj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNvQU0QC5Be/Rify2vr23Pcu6OTk33tEQoMTswLMjeBQkNgamx7tRYQPiq8tg3vOQOGQi2RWKU3uO6oZVFxhKaJcxg8DBUYx61hIudkvpZx/iEAPIzSY7wNVwDCwcutP8NOzXajGapHSP93+xfcBCFvtkZjcXuVgY7JgOGJEqsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=oFcRxT9Q; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="oFcRxT9Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=4u
	Xv8HYQyebb+bRipF7M6Y0h6yFh7ffFcjhh9reQ9sg=; b=oFcRxT9QEIQjk+4f5V
	eUhgkIuQhgUORginpkdV4cQGkCtrLFY9FPqLKVJHrsbY9t5P+IbPf7LLT/F0QWa4
	DkHjdI3h2+C+w3ibe7qUJaJqq8tyAtx9su2eHNXqbYWoVNCN4HJ4KqYi/dDLJ12U
	Y3c9VCcmx+AzRFIVkUuuLLYLA=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wBHoRic6zlqtQaHEg--.49611S5;
	Tue, 23 Jun 2026 10:13:06 +0800 (CST)
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
Subject: [PATCH 3/3] ksmbd: fix n.data memory leak in ksmbd_vfs_set_dos_attrib_xattr
Date: Tue, 23 Jun 2026 10:12:38 +0800
Message-ID: <20260623021240.34722-4-liuqiangneo@163.com>
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
X-CM-TRANSID:_____wBHoRic6zlqtQaHEg--.49611S5
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF18WF13tw1DXF45Kw47CFg_yoW3GrX_G3
	48Xa4kCryrJFy3Ww4UWryFqr4Svw13Wr48G3s8tFy7Gw4UK3s8XanFgw1kJrsYgrWjq3sx
	C3srKFnayFyUCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUiL0UUUUUU==
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC3xIQcWo567K1eQAA3q

From: Qiang Liu <liuqiang@kylinos.cn>

Free ndr buffer data when ndr_encode_dos_attr() returns error
to avoid memory leak.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
---
 fs/smb/server/vfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 60b4210d5ab8..18d5412081de 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1568,8 +1568,10 @@ int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
 	int err;
 
 	err = ndr_encode_dos_attr(&n, da);
-	if (err)
+	if (err) {
+		kfree(n.data);
 		return err;
+	}
 
 	err = ksmbd_vfs_setxattr(idmap, path, XATTR_NAME_DOS_ATTRIBUTE,
 				 (void *)n.data, n.offset, 0, get_write);
-- 
2.43.0

