Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35203175A92;
	Sat,  2 May 2026 10:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777719034; cv=none; b=YIZWEoC7Y6s0hm72SX7Uzrcgt5M+B0u9ugvIleJscnJjkHfrwg4Hd5EK+R29rHQfNcnw2f4cibsvs8OY4rfGfi++noDIryaazbSbRrwX8MCZr8TTjqEe7oVfLwaMmfaAMKegKfm2a/LEcRIk9F6n8rdgzobjEHVsF9phP/lvXsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777719034; c=relaxed/simple;
	bh=mhYYZ9vTva19NiK8asZeIKwDHv16ORSkJPKHND2LXHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGGA+RVglSPDxoXOm1UmUPY31Vr3IZN4E2VcLXN0D0xkSYLuJqF2RHWGA7qNmqKlsBY4ccVI4xq/ppzHzuQALqf9GbQNswDGOlMNxl+W8Oe5bJ4BrSzuHp8tGiNxTAbOBMELccq6OV6HZRwo3xFDkEF5+el8MkcmvkBM/iLzpmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=OvyxFG2b; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="OvyxFG2b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=+4
	KvS+6DzJ02CM67wXgXY+9spj1hGV5Zo99C3l9HjJI=; b=OvyxFG2b0D0ut8oqdO
	Vw//tf4RvNeTF29oXYyehjyOK8AL1vro8GuRF0xjKJc7m1p/6aWcTokNQumu7sJY
	XkU9/yFyFoqFIXRyQbAsXywIRlHyUKcbxJtORO1MtpBJmWwRS2sV/GxQvDU+kl+S
	cTh9pr4iWZc8WR6tvLHMayWag=
Received: from Jason.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgAnCdCG1vVpdIkgCA--.1S2;
	Sat, 02 May 2026 18:48:42 +0800 (CST)
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
Subject: [PATCH v2 2/2] smb/client: fix out-of-bounds read in symlink_data()
Date: Sat,  2 May 2026 18:48:36 +0800
Message-ID: <20260502104836.2980415-1-jasonye247@163.com>
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
X-CM-TRANSID:PigvCgAnCdCG1vVpdIkgCA--.1S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF4xCryUJrWrArW7Cr1Dtrb_yoW8Xry5pF
	15GrZ8C3y3t3srAanrCF4jq3W8ua1DCr9rGFW7Ka48Ars8ArsY9FWktrn0ga4Sy340g3Wr
	XF1vvF9FvryjkFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j53ktUUUUU=
X-CM-SenderInfo: pmdv00t1hskli6rwjhhfrp/xtbCzwuvPWn11osXmQAA3Z

From: Zisen Ye <zisenye@stu.xidian.edu.cn>

Since smb2_check_message() returns success without length validation for
the symlink error response, in symlink_data() it is possible for
iov->iov_len to be smaller than sizeof(struct smb2_err_rsp). If the buffer
only contains the base SMB2 header (64 bytes), accessing
err->ErrorContextCount (at offset 66) or err->ByteCount later in
symlink_data() will cause an out-of-bounds read.

Link: https://lore.kernel.org/linux-cifs/297d8d9b-adf7-42fd-a1c2-5b1f230032bc@chenxiaosong.com/
Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Cc: Stable@vger.kernel.org
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

