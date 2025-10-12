Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BB92ECD15;
	Sun, 12 Oct 2025 16:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760285941; cv=none; b=M6wGewa1wLKA7oFODuW0j9Y+DiN794sYhtudqL4Dtj0EkHwPgfFFRxCBs2F3tciCxzEbWHeuxgalEHvHtWsP79SkHG1TPrPx+BVe9IP2Vj0Ou+L6fthgWjU33lycDNn2p/hn5Q7RD4Sz8AjkLfC0FM/evRE3mnHTW/yInG61Ym4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760285941; c=relaxed/simple;
	bh=+Y1i4ZX5YAVz0aE+JKDU1tjQg9Po8/DgENzqiLN/5r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+3ODj/kbKKqwXeqVMIUbVYlJezoIZG9Aot0Fa4oSaWrQPXh8x0uDkL7i39fuAK4E+yj4syGrTJuUX3NITNFzk++EGYLdBg1kqRCeW3OUxi+xtfvx7r+sv/xpVzHoYV/lC6BQI+/8yGwc0eTULUOEuCbUmkV9nW6ZF4g+Xj87QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285894tdd4e7eec
X-QQ-Originating-IP: IR5Fu0QYzlgEnuwjCn8U1ToBqQMMKRJTpkrlVI0xims=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:13 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 8599701500783114678
From: chenxiaosong@chenxiaosong.com
To: stfrench@microsoft.com,
	metze@samba.org,
	pali@kernel.org,
	linkinjeon@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 01/22] smb/server: fix possible memory leak in smb2_read()
Date: Mon, 13 Oct 2025 00:17:28 +0800
Message-ID: <47508024F79AE36C+20251012161749.2994033-2-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
References: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: Ngwq0BL9nhqbFGFP9UQ2N/VgIHp/4j6dtQhP9AgVrJIGCbmPQVe5ij7L
	HXnB5LKWcxK2oFQ8xUXHrQfx4ju4eXR2LyHlUpBffkLbCUO/QBGBtA5iBW/xhydF0yGIEKg
	tTfpOxk+a9CbrgpBacu+Lp8ga7KCu0YVqRT8Z7XR7INoDCophOvhk+/pbwGrgVnOheSgweo
	DH/Hpuk06bF5KYz0PixWBJZEfWOFwqMBa3osGqgV6js2G5iUdv/G6wkiOF6V9q+x1OWGZ/A
	XK9VbI9lNP387D49d5aD/0qT7lv32Odr0fSUN30JBLdnOpgHM3rSOZJUc1p9RRDhcq8v5SP
	+vcZsgu+TSJCc5A9vHONProXuMMs5P9r0AnKitDTyF7P0WJRbLh9vLhmpb0x6FIrVWR+XqO
	fOiVGnPic63IVXR4MAivxokKKJX0J1AFlyRm7SJdL5FboaodX2yNj3uH6wj9JBe80jp9p5b
	CxfEzqUZTJD4nSnJvJjg7bkpl0Y8QkuZ5LCtAd3CN3wncXLt7qq7UVVQNp01P6nnR9Fo7ih
	UB16+3QTnlyySmuB4xUXk3TBFQt0tb3Z7Z8bVzeEFVVDX0MZF29a6VGlwGii/VESirMQGpX
	Ihwgj4S8l6Ex6Bh0VpxdfWkMuZ7dsHLLNvp3y52iaqthEMP8n9DjPNNoDqsRsWvpKMp+8h4
	EKKWSA1/D9Yjtv2P9JL9NnBQUfb2n8s8O3Sn6+rPP39eDaRPVtm97RA7tvmsGux7BTe5Vxp
	Vofwop8tS8C8+UUoCmS/meLE5r8ByluqvZtX+CrGaYyOlaG9kPNQRrE74AkwpoJDswPNwRn
	iUQwjQG9uoT51pAJ2qmNEkVsmKVE37tqLVtv4CSOwI/PUW9+HRQswSC/JWfyiBqNwwqAiHZ
	bT/a9J40WAKs37zvL2k71IdPnbYjbHNGlCKdanGy1rSHEyljQuF+/5NfnI9zo1a7l0tCzgD
	bmFcnf5gzGN1twYF3uSS3JxCdrCfuvF1FM+AQBzvsKth/urblP0v6iOTgEnTFc8QrP0idU/
	tloPhRnek4N3T/l5t+xmkB/Ak0wc+XLVjZ4UQnQQ==
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
X-QQ-RECHKSPAM: 0

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Memory leak occurs when ksmbd_vfs_read() fails.
Fix this by adding the missing kvfree().

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ab1d45fcebde..e81e615f322a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6824,6 +6824,7 @@ int smb2_read(struct ksmbd_work *work)
 
 	nbytes = ksmbd_vfs_read(work, fp, length, &offset, aux_payload_buf);
 	if (nbytes < 0) {
+		kvfree(aux_payload_buf);
 		err = nbytes;
 		goto out;
 	}
-- 
2.43.0

