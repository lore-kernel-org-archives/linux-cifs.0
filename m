Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817442;
	b=zIPa9+O2APIhIwvA93mvIVUwxLnaquRUGI4q9f63tkz/YR2VkNofsyW3xtLQcpnDvirz
	 rPKy8hpnadZGajJizABaUfyMgg/Ky712yxh7pCkNsGg7Q6L3sLVQbqeOru5G/nx6EWHMk
	 TdLqLne58IDzQ2ctTWxZTZVFZZWLyD6B07be09H6WoGeECR28kGaAnFHl36DFh/giHwt6
	 vKeY1nwJfF2E5hjIEfMWZP2zASVNaHubpXbjpCqPpkY+VzolVXAgj4yTYLVKMoZde3CAh
	 mWycfCgdT5QNFUjnunYnCRvb+OPYxP/w21DgHFL10Eo+KOAcEzKMR6lwLyAFJfIzh3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817442;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=J9RSXne5mLK1TsmXaxxPwH99U6Wphh2WvdDqDFwp/+A=;
	b=zbz43Rv+RgTjvb7Q/U5OpZOA8EDN3RuBTHITC6JNUY7cFmxjZOaiTRMMYYGetD+rETXo
	 WiQNAOu0+83PSBqEjy0U1OQKkzV55hkoi0seFu+QVWcYhw16xtMVwRmr50t+H5OQKEFGQ
	 APZLwChxRbLnwIwmy+SwTGpdPkQVuCJKN4xcrJvuIX4edKyPLGZSqSOmUjvwRFvQ9wUbr
	 nxMYWxiAgppYwyBKN/VrbLlgeS8dfwLrp4YMpmZ3vvgQr3blYNfPacLnXIwG1JPyM/3Q+
	 wd8ue/MzSv5uV2UOCYUYMIdr2hSQODqVOzV9Kb6wHR36ZKyI+EE4CD7QbB2Unk4BQ3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Z1E7dbGH;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=t+dM3ONG;
	arc=none smtp.remote-ip=103.168.172.159
Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8EF606D80B
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 18:37:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B8EF606D80B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Z1E7dbGH;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=t+dM3ONG
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 835EE140016F
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 13:37:21 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Wed, 04 Nov 2026 13:37:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1793817441; x=
	1793903841; bh=J9RSXne5mLK1TsmXaxxPwH99U6Wphh2WvdDqDFwp/+A=; b=Z
	1E7dbGHEkJKjjTe2uywmmc5sXNbyz5Ni7LmjFP8T2ZZc77eD9rKR/v/xRlx/yD0D
	PurQHgEQsVjOKHoeVQXCtODAJIEFnUJyueO1xD82EUCa3cl8t/fNvjjrXvvsAT6a
	y+6kmBr936ENImxmJ+MObXixe+MnCzQDbxt72nDba3ChvJmHj8KZPR4SJjaz8DO4
	u6Ah3YFNpfnsZzNca8wL+ZHql5PUZUzGd4WWOUCvovrU7mIHLwlrS6HyAj7J5N0A
	48Brdbc4NBSvT/eSXANWm0ItnnLeyHX31o0jNLXneCDZzMl1nmC03hhZTWmDFVrs
	MQ3YM31cndx0qY/NJ/6Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1793817441; x=1793903841; bh=J
	9RSXne5mLK1TsmXaxxPwH99U6Wphh2WvdDqDFwp/+A=; b=t+dM3ONGhd14lWLFc
	KTxh8B9cLrz95Q7rTiUwkaN00Sy3oQ9aMQgNo1FsyIN5MyU93Nh2SK3SOXYDFmJy
	BEuwtoAKq0ruTm5JdLovXDKAAmr6x7LogA8laHevQCF+uErdU/33YKgWLL7iZe8h
	hMQGhicxOG6j/vD+dYmHAqAvdHNyiKEaZmOphJyRINa9cMtzgTCxwzlpQ6ypeP3r
	IzSQhF6iI4twKarrDkArYvwjkpEmRNOcPd36gG/VWt+Q9iv26mn8VVa4b8I+otgP
	wht1zaHVKlANEhgEleP+s5zhQc+Jdq4HpSkypGZXg/5X7y5eqCCvF1qe4LTba/tT
	uXpuQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793817441; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:Zgx08CZxtOAo4osN7gH4u6RWpD4OpBbhzC3jVbm+5xPR2rj
	qrC70rR/3NyYgepLAu9W05Q3Z+sNUHP3jNp1mHUpylWRMtMTa2CNehNUykX1MUQr
	GrWCJJ22DQKgOFhhAnOXgUMiU9QwptcS5fb3rAemV//dNlW+KPtn4DOGQtG6jrUl
	PmcA2IRSL59kvKbzewuT3cI0V0CpAOaLxwt6gQe6MMpRBA1RecefucqBAJ5MfcSP
	jWDASYs+Pd5sWjYPo8QYDmPfBCH7LDx1lKk1CGkEb1Xr1U5eWtmp/h6yIb9FpxVL
	cbWcYjp0UIv9Ys3k2iutmnaz+ukiJ49t6/D3agQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:F+6qjIEd6VQ/JrTiN5yG1kQt/KiBbigczAc75l3FW1A=:aUKlz7v0EWMN5zj3K3EOmXyHVqbh4eHhIKm69NLQ6e4=;
X-ME-Sender: <xms:YXvrammCeGRcEidaAddy9DQWiXcxIRMRsqWysn9WuIaTxs7K29Ec4Q>
    <xme:YXvrap3a_TPjDXU355vJuZO6buwMeqdV2rtG_bwSy7uEIjstNr2dEr7-q_MBWNKV_
    3M_JCS0ms08QblzZbaqk8NLSuPHtsI0k5VPOJFOBTi6vnicugMzYWM>
X-ME-Received: <xmr:YXvram1z_mYZw7_dRWtLw3S21xP3RI6MkWAlnnWIUyx5g7R5yrRAHg5LgoSMye4T>
X-ME-Proxy-Cause: dmFkZTEblcHx/HDxFYlMFcbymSWqyds+9SvV1QaPrW0QEo3CjxLejIUk7IoZMnIcIcK09t
    Sf2DPWxDNGVGfZTEvJSbeR6vwwpsAEP6dBoZF+eYZB/kBLgv+8+qbCiKM2Nje78vp3KEHx
    wF6XnfC0SMLcn/gNeYt8cZ1zXEu/47jXRWfqT7uBEZOGVFQ9t3lywBMwd8cUYUPfmVOucN
    pQJBumNoS4lDaYUyss/ZCJHxCr55seI2WewamYMIvpaIRnjWBWAiUYQ3QsSpYCsWmmQ4Pf
    YC9iNbxaAMc9qav/iJNwWsZnOcuojuf1PmKSHkIfmC9QentwYhBT71RjRhruw5g9bsfdjy
    9dlm0GVELcIoZ75ZAAf76OzkdELKfHNDGY1ZxUibWkjXOuf++4owZXDkAAkFuBxeoZX4Z/
    0EdhPdI5rF29+Y/PQk5AzOfb6nEJEsFaXLX9iDfL5BHosuINkCWkOIQnXakn/R0LCiJK/P
    /JuwTuEzVIogQBCf4R9YhoE/WhPBMxS4yra49FjvOw15Pw65Ktz/jgXmPWtFYLKLyoAfHR
    xRorRugjQwOzbO1IcPpl75Rzuptks28hcLy/daWkI1qYw2bOyWo4uwgjFj/eEnlBwxXK4x
    aeOWlZsjnIgeon8jZVeChdL9XxYCDFa9ETsxSmemFul849q94gep9B0cTGaw
X-ME-Proxy: <xmx:YXvrarrzOpcdpnO59r61ITRZjD5BqL15hYvCYKQjm2M4p4CAxEuEVw>
    <xmx:YXvraii3qN3HPoy9EfU-UVRzwNtGrg6ntNeO04nuERo8_WoFQR0pGg>
    <xmx:YXvran-h0IucBhPoIVbrWRoBqo2IC4xvljApoSTmQo4lUfoH_07Zzg>
    <xmx:YXvrauUMgX0rDjgfgzXlZ5FFk8FDpF1qjHxDkRZ8IS1_EFSkyGqsSg>
    <xmx:YXvraqt9lMOvpMg9jzKM2UmOu5LTsIip99rs9MpD-hAf60dkW915nVOa>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 13:37:20 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] ksmbd: skip metadata-only stream opens in the delete check
Date: Wed,  4 Nov 2026 12:37:02 -0600
Message-ID: <20261104183702.192452-3-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104183702.192452-1-icb@fastmail.org>
References: <20261104183702.192452-1-icb@fastmail.org>
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

A READ_CONTROL open of a named stream without FILE_SHARE_DELETE makes a
DELETE open of the file fail with STATUS_SHARING_VIOLATION. Setting the
file delete pending fails the same way.

ksmbd_has_stream_without_delete_share() counts every stream open without
FILE_SHARE_DELETE, whatever access it holds.

Count a stream open only when it holds FILE_EXECUTE, FILE_READ_DATA,
FILE_WRITE_DATA, FILE_APPEND_DATA or DELETE.

Fixes: 19043971c947 ("ksmbd: honor stream delete sharing for base file")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Any share with "vfs objects = streams_xattr" is affected. A READ_CONTROL
    stream open without FILE_SHARE_DELETE blocks every DELETE open of the
    file and setting it delete pending.
    
    Tested on ksmbd-for-next e49296d51ccb with KASAN, with no reports or
    warnings. In targeted stream tests and a KUnit matrix every changed
    result removes a sharing violation that MS-FSA does not make.
    smbtorture gives the same results as on the base.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance.

 fs/smb/server/vfs_cache.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index f9079c529d07..6675c6652c13 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -420,7 +420,12 @@ bool ksmbd_has_stream_without_delete_share(struct ksmbd_file *fp)
 		if (file_inode(fp->filp) != file_inode(prev_fp->filp))
 			continue;
 
-		if (!(prev_fp->saccess & FILE_SHARE_DELETE_LE)) {
+		/*
+		 * A stream open with no right in FILE_SHARE_CHECKED_ACCESS_LE
+		 * never conflicts
+		 */
+		if (!(prev_fp->saccess & FILE_SHARE_DELETE_LE) &&
+		    prev_fp->daccess & FILE_SHARE_CHECKED_ACCESS_LE) {
 			ret = true;
 			break;
 		}
-- 
2.47.3

