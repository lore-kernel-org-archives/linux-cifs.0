Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795651518;
	b=pl7/OvpA5QVVDrT6zpd0jVyLUHp4V7raIoPO6f+TSY3GDjIP3DvF5p5NCnGuumSnN3nr
	 Pjsh0qaXKw9YvKUThR6lDz3gGeGjiY7Ik81FzX4jxNh9mGOkghSuXL6QkPwBbAdmDy8JF
	 d1f2h7X1Ymn3Ee5oD3ipNobIgBUqglk7w7ZSbuQ0LOuYHocNRGdiAqAzcYtOfPYp4wa8n
	 4/O6Yyipnc1biMH78n9bneSYvKbVe6bwGkOQ2yA+2X+3OIdrNzHHMk28DfGKz1MF7MzYX
	 0IfhL4HWFIBspBmxFSY4xmJy5eYTZJYaH3SJPNIbSUNDgzocU+Fc0xlV90LdgqSWeaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795651518;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6dhS1C97wJPmFNMcMemO8W9SGMhjNNlY9EpAgqb8dfQ=;
	b=u3DBAQrfsVM1XCIX8Fbq1bP27QptzZimi/WrKPyEzt4C6cskWkDsTEvb0wx87sdy+Fxs
	 y/MovGmfWrNrL4/1fyS7IiMdeRoSedsXVWtR6PLyPoL+Ad5SwsOwyuCusgXwW/5X7UL6k
	 UDnDjynreC8BP9pd2F0Out9qVj+miJXHB2vQ75jBD/oNY47Md0qkZ4j0ujoHyI/h8C+dN
	 5oBhBi65e3rczvFLSB9dtCgpz4n4gQTcl41CzEEIteGjaWSJJQrYHW8kHRic8+fXZsDwn
	 S+QPpKA0LSSgoKjj3pjr/TiEMHjyd7M964ztmRSlU2DNBDxcG8yjT3PpS7qdwx2QPuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Xi+vE80A;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=O11pfYYO;
	arc=none smtp.remote-ip=202.12.124.159
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DBF606A31E
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 00:05:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88DBF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Xi+vE80A;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=O11pfYYO
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D701E7A0527
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 19:05:16 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 25 Nov 2026 19:05:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795651516; x=1795737916; bh=6dhS1C97wJPmFNMcMemO8
	W9SGMhjNNlY9EpAgqb8dfQ=; b=Xi+vE80ADf7bFJmvtzMN7/kRbcGIVVJdjZRrk
	hVof4eC9FAKS8rrUJ4vJ7tnnU8JXSnQdV3nieAX7z4sjtQOvY6bQbUiHFy/q57rN
	28tss8wn1IKd7zfiy9tHbyxjfxH/LsrtYCZegNmfsKFL376xagZPFq2DWAaA3I8C
	YdfaSWkNHYeJsl/dobAoX1WWtx/yv3wmQ9SjD0a4Q3UN1H8N1keX6pUJBP1542nX
	aFOKBJ3sFafBzPNrForJV3YdLkfm4ERU/4cWW8S6irtPoYQ017jpNBlD1V6lZ2CS
	nmAhxCdBMGp2u2XdKdAQ+BWHmArBYF5fu/YTLLCtFgs1H0Wmw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795651516; x=1795737916; bh=6dhS1C97wJPmFNMcMemO8W9SGMhjNNlY9Ep
	Agqb8dfQ=; b=O11pfYYOj7DksQtgaGyeAPi3pD1ftx8lhyAwuDbWBLE4DafK2Dm
	u+aNXMCHKFz5FFMyYER/oJrs6Rs2s+yb3lDesqafA9xVTofw6Wk/AX2jlxvr3t3S
	VH1jkjSfo6Qu3MVUuZIIJUOfIvMn4liM9ospi9V23SZ66gG1RtrDJxeLyBn4sKm5
	beJOYIWzUPPU9sJiXPtY5YaVJ3SKP6Txjz+pY5LdK7pM0AQLR91SpWuZ3pHzTfdQ
	IoD8335qaIXBIPnTb1k/6f992hj0hgUtOhGsyIVoJmAib86bp2KR7sJEuYIsXb24
	psI45rcOf8al0OQN/Uku0HH6FdfzrXDoIMA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795651516; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:lqU/o2t3/looK8nMJAdc+FIXMyeVCeQryjX9GaE8anC39fX
	Qtw6HuFUwrKqyVmJXNLBG8u/TX3gcZh8cosVMJpfc6+88vLSYZp9jFBAT4gstpme
	ZRpIIyL9wGg70YzMk6BrJ2j1H5rSjZihoupUKOpF4ZCP+ilHp3u/fsKkLzzJhTXn
	pgZmGcRUaJXBYdBh9Q3i7m3dqkt4eXRCkCwxijjbjyCIIUbVZM/TcKC8ULeVoQj6
	3+xevBmgq22ERS6hsJ5XKA0x6IF+rF8gw5r4wF1KSCYzGOxYEmdsoMhEa5dn4jIL
	LXIBFmoaxuJYhD/F/GlRXbi9TioXVInWonh14tg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:5cjs0moPXAMprqESYbh56EBBvCy3mrIuErPI/7Qy8sY=:P7HQHsCEmqto0S4YRjVrQ0906VexPQ8azCMcA9uT7nI=;
X-ME-Sender: <xms:u3cHa8UoQr482KDcBCsDfuKw-kPu8Tbx-0HDm0eEOELhk27MX4pCAQ>
    <xme:u3cHa5C0KyeB71S-taLHV_3LIa8gWyRfaDUQTvAAXAJVDpJfun1NrMj7OMzZsVEdz
    qVzWi7pfcxSJieL6OVx-70sRjDH1kVtG3DpHKsn0Yv95avB-RRZQnqd>
X-ME-Received: <xmr:u3cHaw2xgiq4m3J56Fib9sKnPWnKi6ImvBG2jpmsXnPKBQ7SlmsqNUJMdaKLHXiW>
X-ME-Proxy-Cause: dmFkZTFcxgQ355DLGoDyUAQbbj7Hk1fyOWlpqJXAI2ZGged38X0c8bCfYVuC6AnY/5UKJ+
    D2avW2pfzvq24LzUd29Yr6KbNy1ejHSI1mRc5yaNIU7PVRGkj2YCximPel++i5C6LYebJ7
    ewqGguwxwQAj4y78RgwvHCdzr3u9//df8OsOrGJz94nP9rY1YEigactW+LH8QaOWzaQUc2
    zCcAmzZ0tGmzVTTab6Z/IDgijpqu0RBGap1LzsnfRU2Dqjn6LVxzFP6NxNeSJzX5mP/liP
    fODTdngeH2sMsazkeGci4fyPYezdTHdSZi1tEeBaFToa33aJYQ8AUmFXd58zsXZ8I+gVo3
    uLZgEEu4zp8X+iP56ceEtaWBRqHPuyEqALM/75WppcBh5jltzV9w3ekNyFBas2m0CmEjx9
    kwvzG0FjntH9fnJDhetwfawDjljlxB8RFrzJFp4AMuQg/c0UeDijQzJZlQczanpXclbfKO
    cp0fYRsb5rjJ7qzxHsk6bByRmJYXvmJwQAA5npFMhsaYgFsBI4Uw+9bkNPQKebSOdoRcEl
    93TFw2nj9v7Yk9nrIdrNy5jAyEBSfUafd4Brnd3hO+EJJryo0R89Xw1u15kaxmreXFHE28
    EKJf22oavK3lKannI3+UJu32nBO/lSjJuVKXiGydgqv1PX1LZPOsva8ir9GA
X-ME-Proxy: <xmx:u3cHa73fKGkM5lND99jEQU-yZd0yGkiK4gVKHTQCKWCWX8njag7hpQ>
    <xmx:u3cHa1Aw1zZMqcW0YRWeIvjeVWRl2A2yJPHuN3jqrjMmt9JaN2lPmg>
    <xmx:u3cHa67oz6ZLUL-TNYstIYTdrJ3E3FTZYZFomyg3A1a13SSQyWGqgw>
    <xmx:u3cHa2JqyDQ1151csrV9Rnb_iV37wVhZ9bkhXn-_q0cEu1fLjaGLtA>
    <xmx:vHcHawEW100HfCGc5MQRotcvWh7wEEk0JQZJjAsFMYT--vZH8l05iY9t>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 19:05:14 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH 0/4] ksmbd: follow-ups to the security descriptor codec
Date: Wed, 25 Nov 2026 18:04:56 -0600
Message-ID: <20261126000500.1375459-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
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

The codec series [1] added a decoder and an encoder for security
descriptors (SDs) and replaced ksmbd's walks of raw SD bytes with them.
It changed as few of the callers' decisions as it could.

The issues in this series were found during the work on the codec.
They were held out of that series to reduce its changes in behavior.
Now that the codec is merged, they are submitted here as four hardening
changes. Each patch touches only smbacl.c, and its message describes
the change.

Tests
=====

Tested on ksmbd-for-next f9208b7a4919, on x86_64 only.

- Each patch builds with W=1 and no warnings (GCC 14, with KASAN), and
  sparse reports nothing in fs/smb/server.
- KUnit under UML passes at each patch with GCC 14, and on the base
  and at the last patch with clang 22. The series adds no KUnit case.
- checkpatch --strict reports nothing.
- A script with a test for each patch was run over SMB under five
  modules, the base and each patch, on a KASAN kernel booted with
  kasan_multi_shot. Each test changed its result at its own patch and
  at no other. The test of patch 3 writes the stored SD into the xattr,
  since SET_INFO refuses the ACE that it needs.
- smbtorture smb2.acls, smb2.setinfo, smb2.getinfo, smb2.create,
  smb2.sdread, smb2.maximum_allowed, smb2.winattr,
  smb2.delete-on-close-perms, smb2.dosmode, and smb2.rename give the
  same results on the base and with the series. There is no KASAN
  report or warning, the kernel stays untainted, and kmemleak reports
  nothing.
- Out of tree, the functions that patches 1 and 2 change were run in
  userspace under ASan and UBSan against upstream's functions from
  before the codec series, compiled verbatim. That was about 1.2
  million comparisons over generated and hand-written SDs for the
  QUERY_INFO reply, SET_INFO, and inheritance. Every difference is one
  that this series or the codec series lists. The comparison does not
  run the access check, and its store never fails, so patches 3 and 4
  rest on the tests over SMB.

This series was developed with LLM assistance.

[1] https://lore.kernel.org/linux-cifs/20261125133430.1177754-1-icb@fastmail.org/

Ian Bridges (4):
  ksmbd: match SIDs exactly when a DACL is mapped to POSIX
  ksmbd: replace only the CREATOR SIDs in inheritance
  ksmbd: skip SIDs with no sub-authority in the access check
  ksmbd: build the SD from the inode if an inherited SD is not stored

 fs/smb/server/smbacl.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)


base-commit: f9208b7a49196e36c0434637ab83e001f5800a1d
-- 
2.47.3

