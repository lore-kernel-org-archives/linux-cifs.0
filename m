Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793620731;
	b=NnlqqMeQwZCPHczZyVTOXBcQkjjB6NYHNCAGWdyeOUP1kkWF3nGNPkpq67LWYdAWWJsT
	 IC9mjv3roGz/cCi1CUZaEALtM4IItOa10vf5Z3Pokp7hLMJ+kX8+2mS7UJnoCAMuXTrVF
	 hwe0sVZt7ltQhJs1NPXEb0ea6y1/8GVCi/kSHYATIPHHLL6OmYFneM/q9MG05wup0BIYg
	 mg0zjCQdBtkjCf8HrMIzq2U5Ft6lvhxCW5zhxWm+F/wGduZu3MDLHkdBlh9o7hv3GplXN
	 Q8BDx9KKgCuA5LuyDeePnlftWSsHC31bF6R2jJ6iveyWBOVWu/kCqEgvVbQ2QX1ZAMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793620731;
	h=DMARC-Filter:Received:From:To:Cc:Date:Message-ID:Subject:
	 Content-Type:Content-Transfer-Encoding:MIME-Version:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=p6eNGHHw/+6fMWcInjDn4BIL7DSUdahbc0oOo3aUe9M=;
	b=DHh6KUfbYmaL0ViSf4tTxKWReshwQprYfF13baoO7+kb8PMzChRy1ebhnqdQoarvVm75
	 2WUlQvxSGUSW6VevibexsML9aaSRyN7QqVNCysY0tMCYbrseBtfFPICdP4YNsyizAEx8B
	 wRsv2QdD6Y37yGvYj9yv/P0sEZvh1T1UM1HkT4M+2AuPa9810opaGwHfoVc6M5mpmf5+K
	 6y+KbK+/iJx2jFmo6KTR/vYFRcK6GqdpYecUlfmlqhPBDsGDuuc4dRvNh4h2K8eoR8lus
	 BFhA+7Pf9UYRle1/FWA4H4z0sJNqWIdVhtrbrnhrEVIv39+jS9GDs0yWPOr7tcnnsaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=stu.pku.edu.cn;
	spf=pass smtp.mailfrom=stu.pku.edu.cn;
	dkim=pass header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.a=rsa-sha256 header.s=default header.b=AMyrWqbw;
	arc=none smtp.remote-ip=45.254.49.198
Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9BF60A2630;
	Mon,  2 Nov 2026 11:58:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC9BF60A2630
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.a=rsa-sha256 header.s=default header.b=AMyrWqbw
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa (unknown [1.202.162.49])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5330b2352;
	Mon, 2 Nov 2026 19:58:46 +0800 (GMT+08:00)
From: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
To: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, Steve French <sfrench@us.ibm.com>,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Date: Mon, 02 Nov 2026 19:58:37 +0800
Message-ID: <179362071771.29269.6848836845989806334@stu.pku.edu.cn>
Subject: [PATCH] cifs: bound invalid NTLMSSP signature diagnostic
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-HM-Tid: 0aa19c2052a703a2kunmab045f0fe84ee
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaTBhDVkhNHU0eGBpLH0pKH1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKVUlLSVVKTUlVT0JZV1kWGg8SFR0UWUFZT0tIVUpLSEpMTU
	NVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=AMyrWqbwrojTMYc++3qW7NWq+E62szyAMU1xf8TwFRgOMX/3x+0JHOazdvVM4Iqn4i7/Sq4GmMI4mJFtWjVfxaLz5If+66DIgoBNdA+lP1I7uywtr4kcw6mDwtSAux0CFedQ7v4cM6fafALA+ts307FnDf36bkQsTl4B1Eb6N5o=; s=default; c=relaxed/relaxed; d=stu.pku.edu.cn; v=1;
	bh=p6eNGHHw/+6fMWcInjDn4BIL7DSUdahbc0oOo3aUe9M=;
	h=date:mime-version:subject:message-id:from;

The NTLMSSP Signature field is an eight-byte binary value and need not be
NUL-terminated.  decode_ntlmssp_challenge() prints it with %s on the
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

Fixes: 0b3cc858003b ("[CIFS] NTLMSSP reenabled after move from connect.c to s=
ess.c")
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
=20
 	if (memcmp(pblob->Signature, "NTLMSSP", 8)) {
-		cifs_dbg(VFS, "blob signature incorrect %s\n",
+		cifs_dbg(VFS, "blob signature incorrect %8phN\n",
 			 pblob->Signature);
 		return -EINVAL;
 	}
--=20
2.39.5 (Apple Git-154)
