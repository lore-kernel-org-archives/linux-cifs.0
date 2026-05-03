Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E7E03CCA19;
	Sun,  3 May 2026 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.164.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777817877; cv=none; b=m1im6iHTzyAAUbsiJHeKwv7ri1jC+acehyFaQvDMH4n+7zystW8AyukcQL6WRBZpORgvB59NqnvzbknsSqRZUfCB9mfs02lP8j0InffnA3Kki6o3LeHD2CGvJzRSWkqHDhn6ksGZY+FBtu9484Tb/BAwciwJZ+i8s6scVHj840Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777817877; c=relaxed/simple;
	bh=G8WhrViqZVp0/f8PtsUG9cP4gPGLdc1zjS0z6BmiEh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tA0NjBGLdHC2hfwMGKMDiDkeZQoydmALOLMXiAEmLrIfd2BNpCN7Niq8koQq/vuJ/1ki+thVAj/df3dMMpOofrfpp3yaHJZfoErS1fQoeblnEoZoE1YdYYndeGbijjXMYOpfiZfFku8y5uq9PaxBkcBtTss1Y3BRGo/Rks+j0Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn; spf=pass smtp.mailfrom=stu.xidian.edu.cn; dkim=fail (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b=ceOFliCP reason="key not found in DNS"; arc=none smtp.client-ip=162.243.164.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b="ceOFliCP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
	Message-ID:In-Reply-To:References:MIME-Version:
	Content-Transfer-Encoding; bh=uFdS4EjUMcBjmFcrFxUqHiVLklajdDY94y
	iVL9A6lig=; b=ceOFliCPZ0TvmFpO4mHmXWJKvsDrCuYTKoUAYP3nPMChJg2R/M
	vMQZG6eI5oNlxff1uCbjvEiGTC+azKXVksXRuEU4DzqHp8hpra9TUpa5A3jVWREc
	N6HVCev1v7FROTschr/uSOj3UVXiB6Wc6jvo5i3eLDhANPsxwRd71xr68=
Received: from Jason.localdomain (unknown [113.200.174.116])
	by hzbj-edu-front-4.icoremail.net (Coremail) with SMTP id BrQMCkBW_rnqWPdp1wnmAQ--.36047S2;
	Sun, 03 May 2026 22:17:18 +0800 (CST)
From: zisenye@stu.xidian.edu.cn
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	gregkh@linuxfoundation.org,
	chenxiaosong@chenxiaosong.com,
	stable@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v3 1/1] smb/client: fix out-of-bounds read in smb2_compound_op()
Date: Sun,  3 May 2026 22:17:13 +0800
Message-ID: <20260503141713.3266571-1-zisenye@stu.xidian.edu.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260503134333.3260640-1-zisenye@stu.xidian.edu.cn>
References: <20260503134333.3260640-1-zisenye@stu.xidian.edu.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:BrQMCkBW_rnqWPdp1wnmAQ--.36047S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KFy3Xr43KrWkGFW3tF1kKrg_yoW8Gw4Dpr
	4qga15Cr13twnrCw4kGw1Du3yFka4UArsxCFWjv3yfCanxAr97Ka4qyr92gr1Fkws5uFyS
	9F4qyay293yUCFDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Gb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV
	C2z280aVCY1x0267AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
	Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
	W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMx
	C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
	wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
	vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v2
	0xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxV
	W8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUnFoGPUUUUU==
X-CM-SenderInfo: ysvqjiqsrsjkus6v33wo0lvxldqovvfxof0/1tbiAgUCEGn2FOdbKgAAsI

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
Cc: stable@vger.kernel.org
Signed-off-by: Zisen Ye <zisenye@stu.xidian.edu.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 286912616c73..28e01d02be03 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -121,6 +121,9 @@ static int check_wsl_eas(struct kvec *rsp_iov)
 	ea = (void *)((u8 *)rsp_iov->iov_base +
 		      le16_to_cpu(rsp->OutputBufferOffset));
 	end = (u8 *)rsp_iov->iov_base + rsp_iov->iov_len;
+	if ((u8 *)ea + outlen > end)
+		return -EINVAL;
+
 	for (;;) {
 		if ((u8 *)ea > end - sizeof(*ea))
 			return -EINVAL;
-- 
2.53.0

