Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795651538;
	b=PkZFkjIel6AbDjKywDvRasx05t5iKrt/2gjz4EB28dYCImINzlO5I2jQ+bKN+zAOdagX
	 kP/HZ6xA/0KAJB+FlFZCJ8tfRGPYZQV/zfMwwvqNof0HCqBWZT7ZvOqX3HcF2CdJBPbl1
	 x4H/0Ja8D52GNrLr8RfAZ6L4PdZz2k3x7jR5I9cmUPetqX/N3Pr0wOuoTaKf/qW25qc7L
	 hMZ3guPbeb38IK7jSr9WSj66lg2mZz9OQUZodUrdKAruvkWuVNojpaKe4/uXeC+kcFYx/
	 zxTUQZo52j2NdSxudopOMTDfOoub6kxqNzV3eUIlXt+EIZPfWGJhwq/QrnFrqwwILPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795651538;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=aAWW3kt4VVMK2yZI42s/hpvzIy1ac51i/CGJaz4VmR4=;
	b=jOdmxLRqKSApPm4Vl1ps13CChfD77C0TsWG7eI5AIu/KthA+hrAz/KqpyBZVRUbLaNKU
	 cstheUFp6+Gc9djC498zOrFQgCi6af+gAwYH6uzxJ0gPso6z/jXViGq4IpU3SqjfqjYUb
	 M47pSQNhb4raXZOi8mhL4mhIoIkRtAJtUcLrJew5xmVCzWopbxMOVaBBe1+omZgId5Bo8
	 g+8xdqqnKu1l/+R/m+ND58MYuSi7Tqn7377w6PEAzd95WagGAEcx8CBq2jv3HCO1cPDKs
	 CKYrtQ6/voXA6Tmg6tOs6sEJjE7rSWF1f+loBpYD5e2QcswkDsTaKrzUmjl+rpvvHXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=axbtGqWh;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=qD4++WX8;
	arc=none smtp.remote-ip=202.12.124.159
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2949B606A31E
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 00:05:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2949B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=axbtGqWh;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=qD4++WX8
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 7ACAC7A0556
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 19:05:37 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 25 Nov 2026 19:05:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1795651536; x=
	1795737936; bh=aAWW3kt4VVMK2yZI42s/hpvzIy1ac51i/CGJaz4VmR4=; b=a
	xbtGqWhCDotydDIF2+wB1YlHshBLv4m/dauRy1MmVC9kT3mOuZaO1RgmWy8dJD8+
	xo4hPzqLJUFXlGs+5k8E8KGlicUcutZjL63XD3eifmbpoOPjkWXGwiQcvtl8Vn34
	uAtmWgSGleadbnEt4Q4OaMaWiikqkgwqCA2PebSvW6bis6eD3SfgWRAbdzwtvLGW
	hU1EYJ8lNfg3dHVMyQy3xbTTbFqlg5f42h0ETV4E1EobNzsMGHklED/CtMq0gGFt
	0fuU3Xq78Fen8NexASXhgo1aajzxlzUbAl3kqiVTxsVS6aaCSFbQu8J3rY2gWlRb
	E+oOEmoN22BObuDOQW1QA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1795651536; x=1795737936; bh=a
	AWW3kt4VVMK2yZI42s/hpvzIy1ac51i/CGJaz4VmR4=; b=qD4++WX8PXMTLqFZ5
	CxCb5qSvXv5mOQnIYfBlVdn/qgfpAq0RU7muzr8ET76eGj9L73KScdJsHvwTiEYQ
	W+rbtsLbzZiH6ISJJoKXV30AEqLs/Jb84TRX/73zQX5ekZcgaPdeQbmq2aK2oDeZ
	ZkfnobsQ5wnq4pkzqgyrC1DFTB3ufatbnVUCJjM9gJwAPdgVwSHLvaqkxoglb0Gl
	1R3N/GztLd0AbiIQP39KnNsMJlzCbkOQwfO4CHaDgv5fKRx1sYwTO/8Iv4+nGlkp
	WhU/pJxtQj6fhXxJsJic9g94T0i5O9Tf3i24dJoVjq1baUne/i01WjZsLNxIOShA
	P2Y+w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795651536; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:sTsNdHkKxml4nGyiYxipU1m60aDR3U9I4y2guQMhEnt9Fqv
	TitxLUM19XOrvpGFmGZeg2RVB+AVoiaesamWKf7OF0t1/HElsozDAtKWlvaxQGve
	V+PRr96IYddXnb88jskjz2g/zLO055pehL4+RywO/PXXa+oLTFRvhCV4FrMBxEM8
	p6TDcrc6Ks2d5ktazveMqJ5asGA50BJ2T6S87CIDQWyC/30m1L6NYArYQMYdt6Rj
	TpraukB1O4WQNYY3Dmtznb9QyCM8omny3kZc+7JI8jE76GB2KZx9WPp99DHCioMe
	6xqfcsmuktsZ4DIgghS8k76jfVpHmLTWUzKY0uw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:I1vLDGkj5v6camTMZ41s/5gkm1h1R+khwIcgsO7QNN8=:4jQp9JnKV6Hm+W2nJe1SU5ehu/HRE7qFQVIkRCrAhbM=;
X-ME-Sender: <xms:0HcHa_QuPcQzI73lissTvTQPlpKYcDmz1PCd38T05E2ddBRAvAjfJw>
    <xme:0HcHa0d3nV6LKEEJCztu8iZjAdg74RF30oO_Kw9jFj1EDspLJRSlkxtm6KphYpbkt
    60IGLz5e9LA7excVKqx9Y4aTNG1aNlXEL2pDTapU4zbTENx50LXbLy6>
X-ME-Received: <xmr:0HcHa-rtbJL_ga5ptkmNcnMSRFUPE9EOss3sSeZCFnrBmjtbyc5qE51pRGQOBOkb>
X-ME-Proxy-Cause: dmFkZTEx0G9z4yOsroN1iT/9V0ivk5kC9v576gDgC2lOpkali9wIE8/ZVsapkMqoEdsK6Y
    MVZmAtTmfnhN2Gt1FBKYcI09SJ0I9Ggd9uVOdDT07VW1RqWTsJG/aXW0TV3vkVMQIWi5E4
    8K92yrD9dZQa3GeaUNveFDzfdgiZAueCHhx9A1uyGM5i004D+Yv6CiCn6ny9ZJIX/Lpet5
    CeQiTQZnHmEoDg2/cXPenzEi6u1s75nSH6aKzW78X15YLuYxiA3buV5Ja1SlZyGXDNJvy7
    Spn5F+8VrC+V1TEXjVtcc/loFVDEXgpSeWV1acVnszdByjXgmZViq1A5vJcpiUPRXpESIR
    wtsx5HMZRkDAukWQk/S4JDHEf8syc1Dth6iOU4gJO3ZfM0aCqDLj9Kd8NiJtIDxVUXl6W+
    EqPhJgYNZUUgtHD7nRGYlR3XkQsfVuBLq6K1yCtvFrtNu7VETB7dKjqeaE9oeaQDDVagrs
    3BHTX5GH5yhea+VN8hRGgEih8U6sTtboIP+1yct2GDri4xLq9cPHlxWcZOAxKYk8H/f9Ow
    kf0hjJ8eYzyNvZULcG5SQBt5n7DZjBgURt0zbxfPndwXKg3g0GO6YxTmyAKNB9XD147JwX
    1vLwrpeuv73Qto3owvkEfx00ibIw6prh5tBdPqiWSIP4qpRz3sWzBJ9yqzNQ
X-ME-Proxy: <xmx:0HcHa1_4xlnlPswb6LQ345xAM-v9ifeL3TvVL4Pw94zGWY3WnfGjwQ>
    <xmx:0HcHa6fp5rwrXd6JinzYAAYbs6fPAswPA0iiY1VurEiN0TVcb2Mt1A>
    <xmx:0HcHa_KkYas2EzGeez4kUmqliNR5ALNiXlgkEKW7RWtjG5_0myNdug>
    <xmx:0HcHa6gd5au4PONBdk-x-GbGfmEzIrDiqD8cXyHAJXVQaGjWoP4gGg>
    <xmx:0HcHa_vgWVo7ecHckoLlcjaE_W6tVKUxb7z3t8ZzYU-O5ySK43YmD8LE>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 19:05:36 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH 4/4] ksmbd: build the SD from the inode if an inherited SD is not stored
Date: Wed, 25 Nov 2026 18:05:00 -0600
Message-ID: <20261126000500.1375459-5-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126000500.1375459-1-icb@fastmail.org>
References: <20261126000500.1375459-1-icb@fastmail.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb_inherit_dacl() ignores what ksmbd_vfs_set_sd_xattr() returns and
reports success. smb2_open() then takes the inheritance as done. A new
file whose inherited SD could not be stored is left with no stored SD.
The store fails, for example, with -ENOSPC when the filesystem has no
room for an xattr of that size.

Return the error of the store. smb2_open() then runs its fallback, as
it does when the parent has no stored SD.

Signed-off-by: Ian Bridges <icb@fastmail.org>
---
 fs/smb/server/smbacl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 20e4117cd323..8128e8756d95 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1047,7 +1047,11 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 		if (rc)
 			goto free_aces_base;
 
-		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, pntsd_size);
+		/*
+		 * If the filesystem refuses this SD, the caller tries the SD
+		 * built from the inode, which may fit.
+		 */
+		rc = ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, pntsd_size);
 		kvfree(pntsd);
 	}
 free_aces_base:
-- 
2.47.3

