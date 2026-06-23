Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EE530D3E0;
	Tue, 23 Jun 2026 02:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782180811; cv=none; b=SdEZSsWWx99ummTEs+MwfOIJKMb94JiPo4yM8svHY0VuqDL8lGcH7gEpRlnKvsgs/eATngpLrBG4llz3ddN7zREb5E1h9nuxZrG11oHaN/ghsBSGmYbdJhHAA628qQOS2j0PeV8/IPJPkhmpl7Fyye8h7c9Pbi2TRStd+r6R+RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782180811; c=relaxed/simple;
	bh=2OpBdLSon7FfE/PEEPLoVqrwWBeOL1k6G0sgXIiVKn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxWrWdlL1kn327mCT4scWo9Y3S/qK5X6u4kiHq9jgm9lx4KHYqoteLThiGG0lbUOevIm+IMsptIn7eHfHpHxE0sXKoHmzzQrtvx+BVJL1X3Og/qaCz+mhYwTYdD5JrHHt2ZCCdgsILiy29k8XdNN0FC0jdQg8tF08D+QOlGYpGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=e+Lmghfe; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="e+Lmghfe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=T4
	P2nWQrKGVr8gKI8T5Ub3SuDpLwelHLLJ9WdsUUtRY=; b=e+LmghfeMWzmQL+3fL
	ecVOeK3Jno5rdfUZUMbSIPP3cjOd2t6AQG7chVvTxRk8+bIpe3Wl0L5KTvY9qsoi
	t6UaS42pTiBYjMT1hG58fpTEWfjACpbqujhm5PAoxTdt1/R5TI2aWIrj9WWHMKA0
	bAeUVd0xvDAQmZ4fVIfpNd6BE=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wBHoRic6zlqtQaHEg--.49611S3;
	Tue, 23 Jun 2026 10:13:02 +0800 (CST)
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
Subject: [PATCH 1/3] ksmbd: fix sd_ndr.data memory leak in ksmbd_vfs_set_sd_xattr
Date: Tue, 23 Jun 2026 10:12:36 +0800
Message-ID: <20260623021240.34722-2-liuqiangneo@163.com>
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
X-CM-TRANSID:_____wBHoRic6zlqtQaHEg--.49611S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr1UAw13WrWxurW5tr1fZwb_yoWxZwb_Gw
	1UXw48urySqFW5Ww4UWFW0qr109w10g3yrWa9rGF43G3yUKr43Jws7tws7tFZ3WrWaqFnx
	C3y3KrsayF9Y9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREDGYPUUUUU==
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC4A8PcGo566+3UwAA3j

From: Qiang Liu <liuqiang@kylinos.cn>

Move kfree(sd_ndr.data) into the out cleanup path to avoid memory
leak on error.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
---
 fs/smb/server/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 74b0307cb100..febe9f7b54c3 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1479,8 +1479,8 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 	if (rc < 0)
 		pr_err("Failed to store XATTR ntacl :%d\n", rc);
 
-	kfree(sd_ndr.data);
 out:
+	kfree(sd_ndr.data);
 	kfree(acl_ndr.data);
 	kfree(smb_acl);
 	kfree(def_smb_acl);
-- 
2.43.0

