Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.71.155.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793673936;
	b=WGrQT9NeE81kDRnduAObMm8avfUieVLkQNEH0aNXg0nlib8umZiOik4THG5p71gRPeZ3
	 Uqw6wyUhOWVwN3TY5A/wbQGUamHsqFWplT8SBSsKQx7A6SQwd7qqOHHM8QGjxxOMFHECf
	 bOQzoZpKUDxqsZMcvJQqtu+RhrRi/pinAvmPw8KMmRpLmju6VIqlEi7Scw3Fylxe6mp8w
	 wZO6wnotiv3aH17orhmKfmeNh0qcD2lh5vl93H3+atKmNffKg/ADH/InVKTp81fpS9MKw
	 stYOP0mClY7m2qLwe2+rVaxl63qZxJ6ep8LH+J9bG05Gu+7xkB+44MsIUaV8Q1m2DWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793673936;
	h=DMARC-Filter:Received:From:To:Cc:Date:Message-ID:Subject:
	 Content-Type:Content-Transfer-Encoding:MIME-Version:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=60sIn705N//4nJlSER2bDtx2BvMPrluJneFVG1+nFIg=;
	b=ZmmfQ/X3F0Tn3IwEt7kBmm97VyGYlA2wwmY72/t4tXNP+AtbYVcsXHJPPdTylyI0aZfG
	 zm50fqd/nfM6wYXR0G3RhB4kl/HIyD51Yp9t750LdYjNYwR94mYQvHyyLe1P2DVzKtMj0
	 XmIJ/Lknt0v0s5bdvRtDHwnaeFRmcjd90yi4TNsPiEMglfMA5bBPPB9h7urRV61UQruXD
	 joCD08aq+iZ85px3XtDUNugQ88vxp7NR0yx64m7pokfaT8jTNh1G8/Qa4JeMWVkKmNv/p
	 pObckqOaN0pPS0tUJKr7V/PVX0ELUJcDDrI49ZMYSj9bY3PPY6k4vHThKRuKgnszS5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=stu.pku.edu.cn;
	spf=pass smtp.mailfrom=stu.pku.edu.cn;
	dkim=pass header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.a=rsa-sha256 header.s=default header.b=IjnWpgcu;
	arc=none smtp.remote-ip=101.71.155.101
Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E583C606D802;
	Tue,  3 Nov 2026 02:45:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E583C606D802
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.a=rsa-sha256 header.s=default header.b=IjnWpgcu
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa (unknown [IPV6:2409:8a00:3c11:dbc0:2581:8e:ca0f:59ab])
	by smtp.qiye.163.com (Hmail) with ESMTP id 534316a43;
	Tue, 3 Nov 2026 10:45:26 +0800 (GMT+08:00)
From: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
To: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, Steve French <sfrench@us.ibm.com>,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Nov 2026 10:45:19 +0800
Message-ID: <179367391951.8187.8527449085887136856@stu.pku.edu.cn>
Subject: [PATCH RESEND] cifs: bound invalid NTLMSSP signature diagnostic
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-HM-Tid: 0aa19f4c15e803a2kunm153cdd6b10a86d
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQksfVk1KTh8YTx5OSUwfS1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaS0tBSBhKSkEfGRhLQUlOQ0pBQx5BGBpLHUFOQh
	oZWVdZFhoPEhUdFFlBWU9LSFVKS0hKTE1DVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=IjnWpgcuabcnngov4hk4t6QNYu2DdHrh2LiVh/N8+92WBwbfI0Gcsa+9/htYlC3YXvIym1cAAN9xtdL8K/UpJ9V4Ysfa2qJZpswm/+uqbdH86ODJf0rtQG/J+vfT/JgUSAIB/4VZDgm0llsawQn2dpbgId6fI1JBrH7LaFM9HZU=; s=default; c=relaxed/relaxed; d=stu.pku.edu.cn; v=1;
	bh=60sIn705N//4nJlSER2bDtx2BvMPrluJneFVG1+nFIg=;
	h=date:mime-version:subject:message-id:from;

The NTLMSSP Signature field is an eight-byte binary value and need not be
NUL-terminated. decode_ntlmssp_challenge() prints it with %s on the
signature-mismatch path, so the diagnostic can continue beyond the received
blob until it encounters a zero byte.

KASAN reports:

  BUG: KASAN: slab-out-of-bounds in string
  Read of size 1
  string
  vsnprintf
  _printk
  decode_ntlmssp_challenge

Print the fixed-width field with the bounded hexadecimal format.

The patched kernel reaches the invalid-signature path and returns -EINVAL
without a KASAN report.

Fixes: 0b3cc858003b ("[CIFS] NTLMSSP reenabled after move from connect.c to sess.c")
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
---
 fs/smb/client/sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index c1fc90726e2d1..00c9c99c6701a 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -666,7 +666,7 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	}
 
 	if (memcmp(pblob->Signature, "NTLMSSP", 8)) {
-		cifs_dbg(VFS, "blob signature incorrect %s\n",
+		cifs_dbg(VFS, "blob signature incorrect %8phN\n",
 			 pblob->Signature);
 		return -EINVAL;
 	}
-- 
2.39.5 (Apple Git-154)
