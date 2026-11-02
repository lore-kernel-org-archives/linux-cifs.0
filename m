Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.156
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793600154;
	b=j6hfi/AV802TEIcpspIzYyBSwRzpLGKMRHRFeiy1yCcGT3Zx+bGHK1YgglSOJjyArncp
	 A50830uls8bGK7GklSFcAVYJgxKPLZE54B8AnPCna23uKENRJGVrkJOHU4JqoKORJD1Nt
	 +2XoZKzG+aFC2hECBRQ3fyrRqDEObQ22TnRa1KrRLkrRIfiwE1I/JFf9s8qPFW4cm5P+T
	 8gIC7s2A000WdIg8I7gUz+kIAajK3onAN8oBUHqxF6qokEBTrmBYQmVqSnk/SHjXsP6Zr
	 72U2vHO/jJzl0xebs5Zvi5Idrs7CvB4eCJeq+l6zdEbg3tseY2I9h9tjoyffcWg7dTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793600154;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7NkVt8QGa33jMbek2+v2eXQvaCj/DMbpEr2KtshvwX8=;
	b=5MZEXtnk+ZyQsWQyP8F0XCzgqX9Zsbh6WjgAJLHJpLfl7V718WaN7ahBvJui9pD+OCKw
	 fw0LFiLGpabGdywvNQNXQPyAsG6KdF5QQbvXOzQE4v2YQkjkv09g4mLwwyvgAgJtOT+/n
	 A7uE+M5fChfmgtj7ThfRJTJ7hTHv+EzcJOY+eutdydqrvLjmqzlTt0fZza+S94l982Vq8
	 tnfmWZDr5/QSZiyauF0E/TZXy1YpVRzD7FStObJl2YfBqQKlpsXd1vXPFzzUMm4DACDsG
	 FWRiV/K50qlgGUx3WIxj6IEq1Dv803pz6OxM9v07s0HA41Dtx3rNUFwNNNVrCMpJI3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=K0laAKlu;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=OzBz4daf;
	arc=none smtp.remote-ip=202.12.124.156
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F46606A326
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 06:15:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0F46606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=K0laAKlu;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=OzBz4daf
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 222CA7A00E1
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 01:15:52 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 02 Nov 2026 01:15:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1793600151; x=1793686551; bh=7NkVt8QGa33jMbek2+v2e
	XQvaCj/DMbpEr2KtshvwX8=; b=K0laAKlupxJpi0+aDcj29cI5hqIJu2Xv22Mbf
	slnG2fqdShqSGc0DjHG2wAiPQjRFlmxAR42JGEm0Wty3xAIQEDx0i5zdufJ0OgmY
	8ZL7ZKjZMONTXpTwFUbH0LFr3W5+5oy2Y4yHO5Xy7toer+sgC56Gde8g9Pm901sZ
	CA0thony2v76G2tHEp3CG8LOkY66/nQMzPUW/4BvKTdHDcuQvTLIjPq6LWoWm10C
	3d5kvbVPcYH31pNVFZcyye7anKxUzvNdaxSIHOoFdRN7NjVmRdSy2yee1qBncMRf
	YCkvhKaLc1oYVLkC6lN21WWGz06BfgOjTPRFyDibtlAeq2H9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793600151; x=1793686551; bh=7NkVt8QGa33jMbek2+v2eXQvaCj/DMbpEr2
	KtshvwX8=; b=OzBz4dafBni4pFGNbprnYWLWd5bmRPID9QxecVUOH16uA9KGcxn
	nzB5NxJA1nUgbDdf1Ku0qJko7jpOGpZNUqP5xvDOyyMiABam69vCIn8FuQ0fJPY1
	/s4pZf0P/5PRKwaCsacY8+dtIn6zlh5nvagQ4vf06BFm+2L0yZSbbITRCsC6rSpR
	yTYcozYCoaxqQ2ERjcxgRQXuImoO21U0DHf/rrz+WceeaVsTdS8NzwyOI0w2tHWG
	qbLOOItrKs4cLHmJyJgL5oguJXmGXQ0L6ONH7ZN/bv3f0vDQ4nUC+b7sXqs7d2xx
	Y4Y+5M2zCRs0bvqu45RSVRnv0Cgur17REwA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793600151; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:d9FtzTShWy8eN0gsSy7iOSsqXYfx+1p0Pk3lSmzkcf1hKbV
	ECEIvNqGNTUEYvGC0ky7Y8JuXqpr8QLhlk4f2sQQZ9oOS3gvZNeRIxgn+ERLms1o
	Pula1zRGFJ6RWqwiDms0CsLjOhtuNLppIhsG8GUmm0kuylnlOxQoVtU8IH6TXe24
	fLe+oiSQ5J0WnfylJ88IddSHlVdyK9NgM5u0ezaa8JwHIIAqR7ptpTIStEnu/R69
	/V3GfonNLpq4lSs/TqQcBjeUJRVT195Wd/27BAv8BbfJO5LXv09Q2OwhW7KabNgH
	HxYselaLlDduMihTQoolSp9PMPAwZvuIDTeR2pg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:v/9I4Tz0EfUsLCxybDHabIBcxGyU1j7JVBp8604Jlh4=:mK5/evQ2KJVpCOq0c9xOywFjQP5DxoWdC4fF8g5uj2w=;
X-ME-Sender: <xms:liroahngcaaPzMsnOPhHum0NOB6OJV266Rv4zcJkWY6zIgAeET5ySQ>
    <xme:liroao3ellMeC3WDr1ije7WKDi2QoRp7frflkp54rWhbTMJk05H_n0v3E1jddrdPn
    cezFjlYlNRA-Oy9rLedjxh4CJQC7QLh8YMO_YrJPDiL2CKP1Bx90fU>
X-ME-Received: <xmr:liroap3A7hX7WrjFMT99Rhz4BqnkpxhYxkaOG1QinmHo6J5T4uYon5Mp5TapvTBM>
X-ME-Proxy-Cause: dmFkZTFZCcPyj5cEmn76eolnkSyjDcRqXy0tDqCQfv4AfSKGu37k8M2BAaf/AfFQgCO0Jd
    qw2kbnOBz6nGQl+wehixx9yx2zR+WNQEmzGt7n+mOFMeCt7C+6a0v9HnK6fO6uHLNv7I6x
    7kbo15PUWfmo8pX0YxgmGb+af1a5SSmdj+T1GDf7yQv9LKzKDAvPyu8qMuuI3earyXintV
    XfWWYKB4fyQoPZHmPZ31hXUlknaTYKH7kiGNFziU7eWvIClJvsnVCHWjV8LrIDqTmZpFWk
    QvrwYIYHBupeMBiaogiWppYwSI2LnoqEGba35WA/3LgDSql9V9f8jCK11uAn5Yi8lKPdin
    ZyA1/LlA47q7PNftkfGYb1ZQwcDFVGdy2OpIABtR1BDVmwtPlDGSco5uXDALRTajFjP+hO
    IJyRigW5SIm+oD3EdwdFnfmI39wazjuwqOqipjNlQzwCm77i/M3BseepgDaRmZzVLfc10V
    Du4xjkjncJkRel0JW3Jy1j6wE4407uEK593DSpnuq2LWWHb/jhJxedrHXZ5X0rvKhCEzAP
    IkHCRWI1agWEG9xgROWCjDuvTzTLH9R3KbyprJsQNsIzQ+/zkrHWR+nULGRHmnkrGQ877L
    8wycKv+DFtoF8oyKw1WnUoAyza7cBAYRMv1bQrmpBE3PbC754ivuB76C+A1g
X-ME-Proxy: <xmx:liroairxJME06dSGMfnFZcBUkDPPz1iGyMiGyfKT2LnYcM5pr_p53w>
    <xmx:liroatg_PLOSnr-D2ItOGuYy8WU9ezAFaP5yfQwxRyZeQofNG-CmoQ>
    <xmx:liroam_0r6p-DqN1aL6LamDNGASwjVAvqG9zMh7VD360Sd7KEvkTiw>
    <xmx:liroahX9Wtx2qqCFL-eG0Sp3XPklWQSdHOE8ldWJ0Rd910FJZmcNwA>
    <xmx:lyroalvKcDtsD7j48NvNmoKCU4Ywd3b9bYdpr7eZtOsHLECKbiMop96Z>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Nov 2026 01:15:50 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH 0/2] ksmbd: fix DACL checks for owners and groups
Date: Mon,  2 Nov 2026 00:15:35 -0600
Message-ID: <20261102061537.830714-1-icb@fastmail.org>
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

These patches fix two access failures in smb_check_perm_dacl() on
acl_xattr shares.

Patch 1 grants the owner's implicit READ_CONTROL and WRITE_DAC when
neither the DACL lookup nor the POSIX ACL fallback matches. It also
handles the owner's MAXIMUM_ALLOWED request on an empty DACL.

Patch 2 grants access through Unix group and OWNER RIGHTS ACEs when
the existing lookup would otherwise refuse the caller. It extends
the check added by patch 1, so the patches must be applied in order.
Both are intended for stable.

Runtime tests used ksmbd-for-next d13da43938d1 with KASAN. Tests
covered empty DACLs and generated one- and two-ACE DACLs on files and
directories, across owner, nonowner, group-member, guest and anonymous
sessions. The observed access changes matched MS-DTYP 2.5.3.2.
smbtorture found no new regressions.

The series builds on that base with W=1 and no warnings.

Ian Bridges (2):
  ksmbd: let the owner read and change the DACL when no ACE names it
  ksmbd: grant a caller what its groups and OWNER RIGHTS ACEs allow

 fs/smb/server/smbacl.c | 83 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 73 insertions(+), 10 deletions(-)


base-commit: d13da43938d15b0b719827d8f2b32df8eaec5def
-- 
2.47.3

