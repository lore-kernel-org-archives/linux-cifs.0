Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A825914A;
	Mon,  1 Jul 2024 06:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719816571; cv=none; b=DNcbwkUPzoX1U0MUdhhzIm+fxm+9n2tuCzgxmxGCq9QOPPRuvdo1t599d6sUHbXeImGyM7V7j2mCkArk004UC/Hk45qFojwQ5Es6I66p8oQMacCoOqvC+5dFA1ZU9KSocRaQdOU8S6fppYgnyupf0d6pbQrBJH2Wn6R6L+hyYNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719816571; c=relaxed/simple;
	bh=MnfTPdggTUod1+ie5XpcE+FuMfpcCH0I785k9A9P1Wk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dvznuQEB2JwT5vI3B95ONpxCxWTA0fYHoJ17N4go0xt+gvcBuoUNTtv/t+MuX2M7zkI8z9iB/uNY0JKAqccjQRQjoMpHRrsKkgMRDqlhH83gZeZQb1nIniI/Wl/rdIi4BfbUFjUN5aJ1ul3gPsUSDT1b8zpKxStoG6f9Ck+YEnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [36.112.3.229])
	by APP-03 (Coremail) with SMTP id rQCowAD3_1tRUYJmB2FyEw--.30484S2;
	Mon, 01 Jul 2024 14:49:04 +0800 (CST)
From: Haoxiang Li <make24@iscas.ac.cn>
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <make24@iscas.ac.cn>
Subject: [PATCH] fs: smb: client: Add missing check for kstrdup()
Date: Mon,  1 Jul 2024 14:48:47 +0800
Message-Id: <20240701064847.84726-1-make24@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAD3_1tRUYJmB2FyEw--.30484S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xw1UJr1DGrWxtFW7ZrW7XFb_yoWfWFg_AF
	W7JrWrCrW8JFW29w10yryFvry29w4UArs7Xr4rtr4DtrWak34IqwsxG3s7ZF45W3y5Jr43
	C39Yk3Z8C3Z2vjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwACI402YVCY1x02628vn2kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JU6yx_UUUUU=
X-CM-SenderInfo: ppdnvj2u6l2u1dvotugofq/

Add check for kstrdup() in smb3_reconfigure in order to guarantee
the success of allocation.

Fixes: c1eb537bf456 ("cifs: allow changing password during remount")
Signed-off-by: Haoxiang Li <make24@iscas.ac.cn>
---
 fs/smb/client/fs_context.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 3bbac925d076..8253b615b8ce 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -920,6 +920,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 		ses->password = kstrdup(ctx->password, GFP_KERNEL);
 		kfree_sensitive(ses->password2);
 		ses->password2 = kstrdup(ctx->password2, GFP_KERNEL);
+		if (!ses->password || !ses->password2)
+			return ERR_PTR(rc);
 	}
 	STEAL_STRING(cifs_sb, ctx, domainname);
 	STEAL_STRING(cifs_sb, ctx, nodename);
-- 
2.25.1

