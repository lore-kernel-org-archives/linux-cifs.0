Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net (zg8tmja5ljk3lje4mi4ymjia.icoremail.net [209.97.182.222])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23580411694
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 10:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.182.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782901517; cv=none; b=fmmD0R2L50i+0Qi/expHEVy4AFGkL54b2yjAzPgwNZL9DyfRbzTgU6rdYd/MVsV/BWTzX86iML9xneXM4WjYOmOsuDeBX2MIJGogVRXskX+nSP4UKa92ZpNxvt62aM0KfNLAHlFaVjHnkK1s0nW0xpn4NAtdd18ixJPyKRdZ3V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782901517; c=relaxed/simple;
	bh=AuUICdguS2PP2u9SUstJcSfdridFb8ycSNFb2m0PjP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pi9QtZ8QIL8O3IiByrRLkmjJ5c21d9NEA327NjCcCRC63bdhc+PO7TDiJho2NEbNHUsH0srOQxFtwvhTJbnj3VN6J684QMjESe0jycwpHMop+fCTkaU/Fefx3U7Ppn/CwQLReRQmbODl6TSvJMxWiNfo1in9zB8swkXUdNoLOME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=209.97.182.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [123.114.53.210])
	by app1 (Coremail) with SMTP id ygmowABnicOq6kRqaUnOAA--.38360S3;
	Wed, 01 Jul 2026 18:23:44 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	aaptel@suse.com,
	xizh2024@lzu.edu.cn,
	n05ec@lzu.edu.cn
Subject: [PATCH 1/3] smb: client: use unaligned reads in parse_posix_ctxt()
Date: Wed,  1 Jul 2026 18:23:21 +0800
Message-ID: <445eeebb819eafe44bc15e9007f35d23570ea739.1782898568.git.xizh2024@lzu.edu.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782898568.git.xizh2024@lzu.edu.cn>
References: <cover.1782898568.git.xizh2024@lzu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowABnicOq6kRqaUnOAA--.38360S3
X-Coremail-Antispam: 1UD129KBjvJXoW7XFW3Aw4UXw15Cw1fKr17Jrb_yoW8JF15pr
	17CFWrur98Jr4Sva1jq3Wqq3ZxZa4UG3WkWrZrtwnakFn5JF1xZa4DGr9Iga4xurWkXFWU
	Krn0yFy2qF43taDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxkIecxEwVAFwVW8twCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7
	Cv6cx26r4rMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2Iq
	xVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42
	IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY
	6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aV
	CY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbJPEDUUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEPCWpEzdUDSAAAs7

From: Zihan Xi <xizh2024@lzu.edu.cn>

The server controls create-context DataOffset, so the POSIX context data
pointer may be misaligned on strict-alignment architectures. Use
get_unaligned_le32() when reading nlink, reparse_tag, and mode.

Fixes: 69dda3059e7a ("cifs: add SMB2_open() arg to return POSIX data")
Cc: stable@vger.kernel.org
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 fs/smb/client/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 3c7691b39377..ed782d219d55 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2396,9 +2396,9 @@ parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info,
 
 	memset(posix, 0, sizeof(*posix));
 
-	posix->nlink = le32_to_cpu(*(__le32 *)(beg + 0));
-	posix->reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
-	posix->mode = le32_to_cpu(*(__le32 *)(beg + 8));
+	posix->nlink = get_unaligned_le32(beg);
+	posix->reparse_tag = get_unaligned_le32(beg + 4);
+	posix->mode = get_unaligned_le32(beg + 8);
 
 	sid = beg + 12;
 	sid_len = posix_info_sid_size(sid, end);
-- 
2.43.0

