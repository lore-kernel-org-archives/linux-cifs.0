Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F07511CBA
	for <linux-cifs@vger.kernel.org>; Sat,  2 May 2026 08:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.164.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777711254; cv=none; b=rHouq4hUUUouWHZFqo+wSoxwRmbT3oL3v0ZbaKYnCrjHG6ImYrXsXxKjUn2FFkrPSPMkeHXLLLc/YP5B31qnXzavbBGqKAoS1e6CkgG8ZgvVfbG6N3YCXV6+UfSaHza6EugaT3g2FliqLY8VmEh9+TrTd3opTucAQJGTGIPOaUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777711254; c=relaxed/simple;
	bh=4zJzuWkWZUlEfF6j9DXUAAkxoa0QR6tLWS4/v+aEEc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6cjFRWAvZUbNgODnVemlcG2zAaFjZVxwMsqOEtUaRTSC8muk0snjQy0ySi1zhamQoSvGWltAY3lMOoLhz+4Q+WYj1jFIRfruSNKiVgPVHxUWTq/LCI6OyhpGdVk/5iB/P9E/uRpbbbYi3Vfd4wlRaUPbX2zyu3BMzdjVjdMiFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn; spf=pass smtp.mailfrom=stu.xidian.edu.cn; dkim=fail (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b=3ZVQHhZ5 reason="key not found in DNS"; arc=none smtp.client-ip=162.243.164.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b="3ZVQHhZ5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
	Message-ID:In-Reply-To:References:MIME-Version:
	Content-Transfer-Encoding; bh=3zCkl6GHL8tQauwpxKEjEy52my98rWDHfR
	ZSnJJCSGY=; b=3ZVQHhZ5CAMTRSBx0m1mv56h9W4CvrUFtGhlivxvpyNoU0pn2d
	ZPj4DWt+U8STfi4rc2omgXhmy8q5FyLVzHQ727Fo24Gl0bcgEzCQz3GzIyeyeV7l
	hnttvP/OZj3RYO25kfvc35QrtLwJLuYxu7VaAl6iFFTAkRHxRcmDXhHGA=
Received: from Jason.localdomain (unknown [113.200.174.116])
	by hzbj-edu-front-3.icoremail.net (Coremail) with SMTP id BbQMCkDG7TcQt_VpG0ziAQ--.40690S3;
	Sat, 02 May 2026 16:40:13 +0800 (CST)
From: Zisen Ye <zisenye@stu.xidian.edu.cn>
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
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 1/2] smb/client: fix out-of-bounds read in smb2_compound_op()
Date: Sat,  2 May 2026 16:34:21 +0800
Message-ID: <20260502083422.2955909-2-zisenye@stu.xidian.edu.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260502083422.2955909-1-zisenye@stu.xidian.edu.cn>
References: <20260502083422.2955909-1-zisenye@stu.xidian.edu.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:BbQMCkDG7TcQt_VpG0ziAQ--.40690S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CFWkJrWrXF15Cr18JrWxCrg_yoW8JFyfpr
	4qga1UCr13trnFkw4kG3WDu34rCa48AFZxCFWjyrWfCan8JFyxK3Wqyr92qr1Fkws5CFyF
	9F1qyay29rWUCFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
	ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxAqzxv26xkF7I0En4kS14v2
	6r1q6r43MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjrHUDUUUUU==
X-CM-SenderInfo: ysvqjiqsrsjkus6v33wo0lvxldqovvfxof0/1tbiAQUBEGn0w9pVCAABsN

If a server sends a truncated response but a large OutputBufferLength, and
terminates the EA list early, check_wsl_eas() returns success without
validating that the entire OutputBufferLength fits within iov_len.

Then smb2_compound_op() does:
    memcpy(idata->wsl.eas, data[0], size[0]);

Where size[0] is OutputBufferLength. If iov_len is smaller than size[0],
memcpy can read beyond the end of the rsp_iov allocation and leak adjacent
kernel heap memory.

Link: https://lore.kernel.org/linux-cifs/d998240c-aca9-420d-9dbd-f5ba24af19e0@chenxiaosong.com/
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

