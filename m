Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269912D0C92;
	Sat,  2 May 2026 10:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777718858; cv=none; b=grXLq4J6cb7Mlqa1XSrcxGajndnV2sFUYqQd+saUD/zqb0jXZZlUHZzaFPBn8aBen9IfKmvfXueaPpohlZBwE7MqgUr6U3bI1a4CbVjAT2QB+iycFB7jvo65jw1DBHXVZceNSYvdqSkh/OymWTxU4EzZsLwrGNd0pa+Bs3vTAU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777718858; c=relaxed/simple;
	bh=DF/TXG0J6XXdsdTS5W508/dt/hT//EpEwhci+VvBfoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vD0UU/jXH2rvVMDZU5wGqLkHGfnmcAKykz+RCvSwoG9WCyEBRj4XebdZcmlR4qp7hyBiff3il8ZqdPaqA2SJsASZFoaS5So45wau6U0xKKdaXraUstYGMo0lmRJM9JVpMfa45ZIGSmZM+83LfFMFvEu1jXpj5EAU6FEe+nLLJfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=iIe7drEe; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="iIe7drEe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Cq
	rbO8Qzd6k4KLJI4gpLjZ4/WrLiuK/VHUMcWS/jUwc=; b=iIe7drEeTcsys2DZPF
	nhXozXLmYRrZR0yqW2aD1i0bwvjlKGRBzGUrEf/LzKk7/f+rZYrFmk+pWQKSbvJb
	H8Kk3LrU38P7kND2CdRq5RvmwO+WM5qWG2pajx/X6tMe9rtBvafkDAaJw5PAb1AV
	VmRm73YvrVnBHQX0ExPl3jpB4=
Received: from Jason.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgD330bA1fVpAEogCA--.63S2;
	Sat, 02 May 2026 18:45:24 +0800 (CST)
From: jasonye247@163.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@chenxiaosong.com,
	gregkh@linuxfoundation.org
Cc: linux-cifs@vger.kernel.org,
	Zisen Ye <zisenye@stu.xidian.edu.cn>,
	Stable@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 1/2] smb/client: fix out-of-bounds read in smb2_compound_op()
Date: Sat,  2 May 2026 18:44:36 +0800
Message-ID: <20260502104436.2978678-1-jasonye247@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260502095435.2969835-1-zisenye@stu.xidian.edu.cn>
References: <20260502095435.2969835-1-zisenye@stu.xidian.edu.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgD330bA1fVpAEogCA--.63S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFy3Xr43KrWkGFW3tF1kKrg_yoW8Gw4rpr
	4qga15Cr13trnFkw4kG3WDu34Fka4UArZxCayjy3yfCanxAr97Ka4qyr92gr1Fk395CFyS
	gF1qyay293yUCFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j5EfOUUUUU=
X-CM-SenderInfo: pmdv00t1hskli6rwjhhfrp/xtbC8QZ+DGn11cbHrAAA3h

From: Zisen Ye <zisenye@stu.xidian.edu.cn>

If a server sends a truncated response but a large OutputBufferLength, and
terminates the EA list early, check_wsl_eas() returns success without
validating that the entire OutputBufferLength fits within iov_len.

Then smb2_compound_op() does:
    memcpy(idata->wsl.eas, data[0], size[0]);

Where size[0] is OutputBufferLength. If iov_len is smaller than size[0],
memcpy can read beyond the end of the rsp_iov allocation and leak adjacent
kernel heap memory.

Link: https://lore.kernel.org/linux-cifs/d998240c-aca9-420d-9dbd-f5ba24af19e0@chenxiaosong.com/
Fixes: ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")
Cc: Stable@vger.kernel.org
Signed-off-by: Zisen Ye <zisenye@stu.xidian.edu.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 286912616c73..a192d70cd29e 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -121,6 +121,9 @@ static int check_wsl_eas(struct kvec *rsp_iov)
 	ea = (void *)((u8 *)rsp_iov->iov_base +
 		      le16_to_cpu(rsp->OutputBufferOffset));
 	end = (u8 *)rsp_iov->iov_base + rsp_iov->iov_len;
+	if (ea + outlen > end)
+		return -EINVAL;
+
 	for (;;) {
 		if ((u8 *)ea > end - sizeof(*ea))
 			return -EINVAL;
-- 
2.53.0

