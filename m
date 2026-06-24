Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B99C319860
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 01:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782263681; cv=none; b=JZIsQYHRhutho8HhbMEyDL/aun430Ke/P8PU0J1IP9mK0x/kK9Wbzz7je7kcoFs9O1StTPiMhAEMMdjz3jcAm707occmWJEq35ESLWRrKrreeNoOAsTtuWmxIssmQxR03y0SbU6/mq9zu8uHU5qmluEwbjH4FX9choJRmDNdi7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782263681; c=relaxed/simple;
	bh=jlEommX1RoJXhiyA+wjljcczLnCFuftdZA9mt7G08xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kr6bbpqXvujrRzf/VNYU9DcOvS9MEso31E8QZJQpjuqtC1lOtN1vuKSplBx93WZ2+pujAxsVaSLZNq4tmvR/0Rr7ZckQf0c1ZEiSXkTejO3USMQL0KfJjHAhlsfIbJKkbwVJXhOLUHrJTn81e6j2G3QnEV1X0Q+Ry4feOsvuhAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZoniA0rg; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZoniA0rg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=GD
	qQ6+te3w8Dailb4D/xHsoD4n9wiDeFy3n92R+ft5Y=; b=ZoniA0rgWObGCUE4/L
	TvUisu4JireI4ChQRe20+gB9Wv0DVGmVpB9QF8dlyahpfLHHwCb6ZOLLzCwVsyEo
	pD9l8/sXgpMXuvOYyyXukZEXxBxe2KzphBvqvChzJ5M5ngPrX1J/g42ml6A8HCPn
	giHMbKW94NyeC5JTyxA8+fpeU=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wCXb24yLztqsdWDFQ--.18691S5;
	Wed, 24 Jun 2026 09:13:30 +0800 (CST)
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
Subject: [PATCH v2 3/3] ksmbd: fix n.data memory leak in ksmbd_vfs_set_dos_attrib_xattr
Date: Wed, 24 Jun 2026 09:13:20 +0800
Message-ID: <20260624011320.9146-4-liuqiangneo@163.com>
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
X-CM-TRANSID:_____wCXb24yLztqsdWDFQ--.18691S5
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF18WF1rtry8ZF1kWw4xXrb_yoWfAwb_G3
	4kX3WkAryrJFy5Ww4UWrZayr1Svw4UWrWrWrnxtFy7Gw4UKas8XFsFqws5Ars0qrWYqr98
	C342gFs7tFy8CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUn-4SUUUUUU==
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC+xpDpGo7LzqChQAA3F

From: Qiang Liu <liuqiang@kylinos.cn>

Free ndr buffer data when ndr_encode_dos_attr() returns error
to avoid memory leak.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/vfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 7ccc9eb87692..49b6b58fa5a6 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1567,14 +1567,15 @@ int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
 
 	err = ndr_encode_dos_attr(&n, da);
 	if (err)
-		return err;
+		goto out;
 
 	err = ksmbd_vfs_setxattr(idmap, path, XATTR_NAME_DOS_ATTRIBUTE,
 				 (void *)n.data, n.offset, 0, get_write);
 	if (err)
 		ksmbd_debug(SMB, "failed to store dos attribute in xattr\n");
-	kfree(n.data);
 
+out:
+	kfree(n.data);
 	return err;
 }
 
-- 
2.43.0

