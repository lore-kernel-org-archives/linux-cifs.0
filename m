Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793325942;
	b=Yg2lrm5XChXSr45kMgBiXuJfRE2luyfV8TPDAo48RypUsjc6JenAf4SIcTIRqtkl3dB9
	 5HVOlWg4IVrzWc13O2ASv13jtvZkuOb1IBV9PO0izX51FWiaQotAIQ0ozOZquRXKMaYLd
	 9L7hFkDiXAIwYO1aqleeIkrMiyjQ2My2OV+Gfb9JGfsRmL4u560v3H9HWTtAgA95B9oo2
	 ktdzZuZxhkGgNRPa2XH+T+AsZ9zupaJsLz7naggJUh3Jg7xt+Rd3AkeVa6U9a/YLkuRsC
	 Dws7VJBCNfn1pPblKiHsl7wGpAdslW/tRwNPK2G/2eNBoVYt1YN5UlnCvSeX1xZYYbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793325942;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FaBdhe+BilZDrddoVF/yPe3H5iKhhYZT0hc6y5Pow0o=;
	b=Iu1V6e9dPbWBzvxSGyrTh1zkMVRfYZzK9tVz1w3xNPErM2lkSPT7C4TH7sP1Xiu4fWiS
	 NUgjVXcVfI3k9Xi4KqwMP6R0jA+seUR3T5mv3mY1EmrU+Z4CtfqAUORtqOCqMYQwJy5u/
	 ZwUTDAFREKAKevhMncPSfA6pco5WiQN/xpSxEK/sqGSxwiVZiy+Q4IXdpAgfrAE3zxz4V
	 OEGjf+sQUuZRHEYbrf+uv/sDt+NxbYnxbG0lPu+1VPZTt+YnT23h7a2L1Y0qJtWkTKosv
	 xqW/TMUkKRVDAJCyMEnT7ci45SITgBBCbDw6vZ4s8jggPpsfwI6XcQ4mJR5zNhgFRGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=fHPDKoo8;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=s6rDGbCO;
	arc=none smtp.remote-ip=202.12.124.148
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEF1606A31D
	for <linux-cifs@vger.kernel.org>; Fri, 30 Oct 2026 02:05:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BEF1606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=fHPDKoo8;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=s6rDGbCO
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id F046E1D000E0
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 22:05:40 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 29 Oct 2026 22:05:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1793325940; x=1793412340; bh=FaBdhe+BilZDrddoVF/yP
	e3H5iKhhYZT0hc6y5Pow0o=; b=fHPDKoo8utiL93Q5xcoAYH11TXGj6qadP2pnw
	uV5kbmR3xSN8MkT1Sf/bkFJPt1/Og30cyIB1AKXtnHTHrQBMW6JcIzBUgmm5pFm8
	b8AS+2VXb9CbOcWJMxvnN/77k8I6vOyVl0Xrcgyp0rywsP3VD6e9SwzsHxYE16q0
	M3muG+viWNk2ZLgA7o9ueMr0OyavxXdIIcBe45lbnPUO9prhJR6RwdYEKHFroP9A
	qlew3PcYNJX+OxNslzfkFhV04BBxWtDND7ZUGkgXq3VjUEq1BC7x6+VNtI0lKUos
	YIFI0TjSDoNxRsiftgCt3ieIs0V1uWwCpi9AskQc+tFsgx7Kw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793325940; x=1793412340; bh=FaBdhe+BilZDrddoVF/yPe3H5iKhhYZT0hc
	6y5Pow0o=; b=s6rDGbCOD8Kvq7RAlxiea8tzdHMGFGwmorujyn5lo6Ke47BeadQ
	V/2vCjsZQXefMuaVg9uJYc3Wg+B12Ux2PCHrqmKElxJdPq/Z7NDOypLst/oyZtjW
	+yrNRkBkPkZurZkQSqFagEynWr0/PtfAE5HWrZEXfU4ICoHkMjupbJXORKHKZNR4
	UV59jlXyWsnwvw8OTUjK02TXgcuXP8AfhsGMeq8OQR5bcTBDHRoZL7nAV4UJcthD
	Ok9/ZRWjmTp+2v+6Gv0+KTX+ly26GnU+3YHpcmiKEFpcaWSMzmPsM6ftHhIEwMnM
	9e9reTn6imBCHgROl8hWkhl5/31CSIbsihA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793325940; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:CRSet4vhAIGKAXsLlyO0TJBEEXWXzh1py2PSWKq8bFhlpjk
	MIN8cVzne6H6i/YRqA0Sn2fW+wnOnAcLLo9157MxRrTCa9NPIhKKFbxm0ZbyeGi3
	rNijaKSBNMap2mXF00jdX1cYn03ecn7lO2+EGKsN5b0SltEptPQxsrpN9xE7Tuxr
	pfFcPSpH444WGNpja6wtyR5Va0clITrWGRnJlwB3GcvFf9rtdyI6NA+J+kF8Jytt
	VnSwxd1qatHjXGqB9UFDjY3ta2wDSJGLnrg1l7Vwx+wGE7TbkMimrU6ofSFc3pXu
	TrVA9EMK1RTcHkjijxUZHvVU2e0VhGVy1xepx0Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:+aMMOfRIwJXoJpN2rY6QcICx8fT0C7uYC286o+L8fNw=:/wP4vCjzLDwPCJDTrFdbpQj6RhesBSCyqe/LqXw9w3c=;
X-ME-Sender: <xms:c_vjalsvn5sUxkh1taHE3zpY3H8HnCKIDn9hR-MZhS4zkC9MH_Dzjg>
    <xme:c_vjavJZ5mc_6kdGS3Az8QRsaXsuOrvEZbk-rHg72EvvuU40PrwmdnwvaROX_VRBi
    YUqMigQexLnAB2OwPKITtGhqtT5F1Toac13gP6_XL4DTGcOgr5tslo>
X-ME-Received: <xmr:c_vjam-MsECOZfrNMeGRU1oP6v4_nkouWnxpVNgINRUiGktpqXvYKrHdCSA0FI1r>
X-ME-Proxy-Cause: dmFkZTFaipjI6C9gtG9z8NrfEedlKvdaZbESlsh9dddB1e5Ur0R2NoRyH2lC89j2rrX5WC
    mWmwvvrt/hKsPc76Eqt3NE8U6vVSGozyzeuHq5w94SNBIx6j3IfRfE8dwT6q9m7sMHogr9
    8ruGY+N4LnJ9eBdxgfwZV4HWM8tJfycmjXkx98zxPVYGHsFhYQzpPTx+cp6z+jnkbFbdH6
    +58yvsrAKy2eBG9lgryWABrMduyO1e1fUeHAsudGHUT8C0FP6gdqdWYKLhP/SDlOdc38hD
    H/yPIbxFiy8yZPtEm4B3LJekJpTgz991hYBYBGGHynnb2G0WdXT/7yQ0AjSBHHJfcLFwRK
    LSQIBRCRNfNR6lypInrIH/YUsC5HEfzBW6+1GMIjz2qmekRUPKJPN8ewgoEsEWm4jVNf7k
    Dw1kXbjKrl8kJ4SrYpf+l2PUgn0BAgaDLxPDyncAzVScQ1/+mgxpmdZyKEcZxnKt5qX1bQ
    nJApTpJQwv4FbAeE7ZXNgxNmJMX3MSZJ/NUXqY5A6h5G22MDnCfxrGQ6zaygY+nmQ2vsQv
    HbcvOaPu9WgsYdhpgPSm8LSsgBE6O1jHTOzJXNAS0j6MOhnU+xr8ekAMO8WHeBThaqnB5C
    9kjwYLPVU5ttwa3ZRzq9CPPntvdHqrU8RUbI+jX0bELdKdfCdRzAEMu8KCCw
X-ME-Proxy: <xmx:c_vjagzl-DNpEypLxdQgzlU046HSTKBDnEMklJ-RUI21waqGsL7o9Q>
    <xmx:c_vjar6prMEydeuaIcJqsMsUVNvtR-tFCw8hROWCq5gf-kwQ3xB14g>
    <xmx:c_vjav_0lWTezLdowRoJI9PIiHz1Y5SbclBKyr4R6Cm2IbkwinKkCg>
    <xmx:c_vjaooolx6yMLzz47g-_Q93CRX9j0eV48taM5vSlM57SRXZxAqs4A>
    <xmx:dPvjapDfTA8Wi0Wf7wTUYQl_MQqvf5_WlsgJX4ObF6LsUdlEPaMp5zpX>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Oct 2026 22:05:38 -0400 (EDT)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH 0/2] ksmbd: fix DACL evaluation for denies and guest sessions
Date: Thu, 29 Oct 2026 21:05:21 -0500
Message-ID: <20261030020523.302085-1-icb@fastmail.org>
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

On an acl_xattr share, smb_check_perm_dacl() has two evaluation errors.
Patch 1 makes every open evaluate the DACL in order. Today a deny ACE
that is the first one matching the caller grants every right it does not
name. Patch 2 stops guest and anonymous sessions from matching
Authenticated Users ACEs.

The two patches belong together. Each one alone moves some guest results
the wrong way through the other error. Patch 1 alone lets a guest gather
rights from Authenticated Users ACEs as it walks the DACL. Patch 2 alone
can leave an Everyone deny as the first ACE a guest matches, and that
deny then grants every right it does not name.

With both applied, every combination of one or two allow or deny ACEs
for the caller, Everyone and Authenticated Users was tested, with
READ_DATA, WRITE_DATA, WRITE_EA, APPEND_DATA or full access as the mask
(930 DACLs). Each DACL also ended with an allow ACE giving the owner
full access. The tests ran as an authenticated user, a guest and an
anonymous session. Compared with the base, every result that changes
agrees with ordered evaluation (MS-DTYP 2.5.3.2) and the definition of
Authenticated Users (MS-DTYP 2.4.2.4), and no result that agreed
changes.

Both patches carry Cc stable and need to be backported in this order.

Ian Bridges (2):
  ksmbd: evaluate the DACL in order for requested access
  ksmbd: exclude guest and anonymous sessions from Authenticated Users
    ACEs

 fs/smb/server/mgmt/user_config.h   |  5 +++++
 fs/smb/server/smb2pdu.c            | 11 +++++++---
 fs/smb/server/smbacl.c             | 34 +++++++++++++-----------------
 fs/smb/server/smbacl.h             |  2 +-
 fs/smb/server/tests/smbacl_kunit.c |  4 ++--
 5 files changed, 31 insertions(+), 25 deletions(-)


base-commit: af8c72f6550744fe948ef2dbc7ab8739c149aab2
-- 
2.47.3

