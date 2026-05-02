Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 246AA2D2486
	for <linux-cifs@vger.kernel.org>; Sat,  2 May 2026 08:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.164.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777711253; cv=none; b=s/uEiRVCPj7rLNy7866bpEtmkSh4BpjOwZfZvKRapQvEhcBzLRJkZFF53HA2IujfP8R219+4y2LvvGPIGuHD8vAoPvKVG3QDarb5JZ6aPX2SXeTHc75Ti+2dHfqtaebSIuA0kIFYjNCapTBiSdB64I6IdFNIkJTVY7J7S3Xlj80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777711253; c=relaxed/simple;
	bh=7H8y9A1nbISR9+ATnWwo2ISNaaVufWYm0zgy4Yj/r8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmTL91lTR+ZftHrNc9x8HsO/CGF1+kIHsC5hMNU/YAZOqB5Dz0N2LED/QCwHanxXoPmtLIjd4y57rN22pLWEYvu6riETq5O5MnujupoPODJy8l8//dZ81KSY/RE5LeGvAvmaXAdz099yNMGkRTrtH3n6YmbzXV4g0/4JowzYUV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn; spf=pass smtp.mailfrom=stu.xidian.edu.cn; dkim=fail (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b=ebu46EIZ reason="key not found in DNS"; arc=none smtp.client-ip=162.243.164.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b="ebu46EIZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
	Message-ID:In-Reply-To:References:MIME-Version:
	Content-Transfer-Encoding; bh=YXTdTGEyywm3orBUhc8LzdOU/IYL0oItTq
	iixELzVz4=; b=ebu46EIZcM4Hdm4d7UhYKzUJ7nUAhYbvQc/+7PG1YLlqQj3z+O
	Q8OMbtVXJ0jJbha7KCuyOqc7G3FF5OjaH+ipvwb+Z9z0obMZNOXNaDIq5b05NaHK
	sh7lOw7LDKJUC/n2tcLKxgNiVgtwUXqDTvgvXKm1JCpLP8WLdvjucUGXc=
Received: from Jason.localdomain (unknown [113.200.174.116])
	by hzbj-edu-front-3.icoremail.net (Coremail) with SMTP id BbQMCkDG7TcQt_VpG0ziAQ--.40690S4;
	Sat, 02 May 2026 16:40:18 +0800 (CST)
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
Subject: [PATCH 2/2] smb/client: fix out-of-bounds read in symlink_data()
Date: Sat,  2 May 2026 16:34:22 +0800
Message-ID: <20260502083422.2955909-3-zisenye@stu.xidian.edu.cn>
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
X-CM-TRANSID:BbQMCkDG7TcQt_VpG0ziAQ--.40690S4
X-Coremail-Antispam: 1UD129KBjvJXoW7CF4xCryUJrWrArW7Cr1Dtrb_yoW8Gr18pF
	15G3yDGw13t3srAanrCF4UX3Wru3WDCF97CFW3Ka48Ars8ArnY9F1ktrn0ga4Sya4kJ3Wr
	XF1qvFZIva4jkFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
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
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbH5lUUUUUU==
X-CM-SenderInfo: ysvqjiqsrsjkus6v33wo0lvxldqovvfxof0/1tbiAgUBEGn0w2ZVKgAAsR

Since smb2_check_message() returns success without length validation for
the symlink error response, in symlink_data() it is possible for
iov->iov_len to be smaller than sizeof(struct smb2_err_rsp). If the buffer
only contains the base SMB2 header (64 bytes), accessing
err->ErrorContextCount (at offset 66) or err->ByteCount later in
symlink_data() will cause an out-of-bounds read.

Link: https://lore.kernel.org/linux-cifs/297d8d9b-adf7-42fd-a1c2-5b1f230032bc@chenxiaosong.com/
Signed-off-by: Zisen Ye <zisenye@stu.xidian.edu.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2misc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 973fce3c959c..2a7355ce1a07 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -241,7 +241,8 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
 	if (len != calc_len) {
 		/* create failed on symlink */
 		if (command == SMB2_CREATE_HE &&
-		    shdr->Status == STATUS_STOPPED_ON_SYMLINK)
+		    shdr->Status == STATUS_STOPPED_ON_SYMLINK &&
+		    len > calc_len)
 			return 0;
 		/* Windows 7 server returns 24 bytes more */
 		if (calc_len + 24 == len && command == SMB2_OPLOCK_BREAK_HE)
-- 
2.53.0

