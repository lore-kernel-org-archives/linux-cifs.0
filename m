Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793937237;
	b=psUrqA1h8K+hQ4ca7rzrjOMOoBBM8Tg4YJwJenXNPAm1/LJnjZvAXz9V0aHrUh0wo0C0
	 yokgLIFzo2roxgQJCaqNwD3fW7rHIbRwd2za/RsVjCYs2MfIrqseRYA1hgabwmgtdGS0K
	 DOJCT89VTM2NkE5nPcuo3QiKnJ+mFoDK2vRlcMR9va3kz32CLSJLKQvjr8BhFceJnr+US
	 DbDNzgwFDGjtWrS8ZapWseOlHHrIjdlgYUih8UDqrO5ZtCvEmwrBmrglna8Cu321r3yHz
	 yH+aut3JZkDv4bEpfaKC3y+zkkGjcc94tb/vwTusuwbOp9kfklKwtnhNtvXZwfBSfWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793937237;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=oqmDrOo6CSWs4CP+/hS0yMdv/dJhQgy+wrfGOSgAwrc=;
	b=M31d5BlY6sgOMQaDd+6/E9HaGZTM+vF+cCu9ySbXD8tvbl4CYUERPNkkv096Q45HllGK
	 xj7K3es6lY9VoQz6g3GH4W70eT6ro1F4vBOWOy/mg9C9rDkfjMAhnPrgzlC9nxj6/KIeu
	 qkugAXt+8J1caZ2mYQfiSVCVoq6Ya6MWC+5KlUGxUivCtM2OcYMHbkpQ6b3bb+TJNSKcn
	 mV5/HoHKAGFNZHT1iAP6Tu1OXYGyT8PGqbBcD29JfZBBj4aMFpE1qvGPXLDQPJLXe7K5v
	 JsJ3eZs9m19DWmaSHxtBwlDLNaG2rN2yuWFz2uwQJo5JuEGYYrZ2NnKhCwbelVoI+Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=g1xIj0Lt;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=bADTeO0T;
	arc=none smtp.remote-ip=103.168.172.157
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D07F606A32E
	for <linux-cifs@vger.kernel.org>; Fri,  6 Nov 2026 03:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D07F606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=g1xIj0Lt;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=bADTeO0T
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B15D11400133
	for <linux-cifs@vger.kernel.org>; Thu,  5 Nov 2026 22:53:55 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 05 Nov 2026 22:53:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1793937235; x=
	1794023635; bh=oqmDrOo6CSWs4CP+/hS0yMdv/dJhQgy+wrfGOSgAwrc=; b=g
	1xIj0LtZr77iKO2Ht0DMkqJIsenrRo5P7tbbtQKKY8SbU+RvPaLi4XFb+iW2Dnhw
	TbqcKcoG1fKYRIZnebg2SOj0h//0YfrwKhmGHYBaLdSk/wR6ao+T92JCYvQh+6ue
	G6kq9zyYfpEclQb9Chk+Uc0GQqRJl2lbJI1FkrdxjZLAyblkvda/IBcLvVaJHz8F
	jMbynjcDKCUoDnR9aYWhnxie7uV69Xs/gQmcSdas/ATj9nHmSE167KgBKNCm4nKk
	J2RgWsaPa+VanrsGkib4d0E+Nx8aqTbHviP4LXi1yisIQ8t8KqtwfrrWgrgXtDht
	0Xs+f3GIKIKmVe6lN1k6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1793937235; x=1794023635; bh=o
	qmDrOo6CSWs4CP+/hS0yMdv/dJhQgy+wrfGOSgAwrc=; b=bADTeO0TXnfNVaq23
	uIVxX5FXHpk+ydSMC2tlbYzhM3wvH5LJm34O4aJCWIyoTjYuBF1JWnm6ulxki/Yf
	LSy4wo+WkHvDoZVuxh15xUCejTAEqL1WkvxHlnPU9hhQO5ze6EghapGla4ANuxKT
	e4TgBI/gnFDMqBOR//YtbtLMTrnSo9Ttt9eYplBGc3ATn42uDcmMxkW3fCQLmMIo
	PY7roqOkrX9PbY/5MqYJdZbX3z5IwYVP2zd1QKydBr1bz8NBKHNdeGCqul3hy35y
	Zb+CSnOhMKWvmat+lH3IjCdVScf6BpUtuSAnPO5X9Dz9L2+2QVwLygN/2ns9yyrq
	1uFYQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793937235; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:aAQm8D0lhkH9jk95rHMfRRWNCoaFpdVkGNoM7NB9AGxnBPd
	pxnvz+pnx6G6IfsOoeocPVozTsByxoWhjXQj90pLb2J7agmtAi0jU9DfmGpkEwZH
	AV52HqO7wutmH4yrwqM3TZdNC+SvfhZJOnDHfXGGlS+h/5oZKuYrqhs3/+0svh7I
	a+cnwH1I/fz1GUkrKoKREBKYMqzBpPTzAQLg5d3dk8q7Kq2izGvd94E8ybrWPZoY
	rAiS1JzyQOMoEz0CEixlZq8UyMcfeACRU5D+Vy2A19vJZsUmTyiApZE/QpY2dJ5I
	AFRKMewkyAGN9z+flcT+XJ2yI0oDbHmxZQThsFw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:W96i8d2/nelZ2cQ42rB4X0s2uVOjBiE+neRGlPjXCEE=:xXMnsnlzzYg1l1m14B/hIdJJDa9HvNRFBi4Vo8N89Dc=;
X-ME-Sender: <xms:U0_taq-dNRs24JFftJ6pGaE4PNhpCtUmQbiXHymyCjpGIJEtbZtuMw>
    <xme:U0_tamtbi8HF_xQD6f21VVSEwcd1xORvtzilehBV1bwxT8H51M3hN6bO6f1FpiQkR
    vS_d-sgEwmfwRP4ScYBD6f_Ytn-xp645_lCjy8hyp9vTuOeNORWo3oP>
X-ME-Received: <xmr:U0_taiNf3y8Wj53wt2TmZBDhZU3P4GPVcrM-bmKhTOA2ft5RjzR7N4DT6sudJA1u>
X-ME-Proxy-Cause: dmFkZTFIjkh/VkrFtaLZ47zpZzzrVb1j87A4M4dFjd8r9QlZeldkq2H9HL9mTFPhexGiWy
    I0wK29+khresqZAE5vlBKDqddYRQaNjPdsGWL/77YszKh7M0swfOmPyXXm3mqQLXMNsU7l
    //jsYHqPtoa4/gNJNhb6ERabdIBEzztwM4Pjx+fleEmj3dQUhDne/H180wHsjwOiCzxwP5
    Y4appzIa6Ek2olO9Rp8Qx/8tY+lq2cKslHR6GV7KjHGBskFIUOVZb9C9RonqmAd8qm8yqA
    m2DSX62OvTbYVYiBEh7k+5I6i7vhrLQb93jchtUugUltCpS6UMDdqLZgU+qjomZXzVHRt8
    5PkH5jSk/LknxjUDgtYEsJguRZOXqF909zWLHdaqerf4ANT6Fq5+p4q4CJ1L6nSGkPe9/C
    /zCfOQojXyEVdTaCflzdm6CO9O669RaAWAxysbr9y+KZu9zPPR09y5beYieRnnZ22eqN0U
    sQ7gMoVdpHU646q5Xc/a1tpsTKanEVp0Ys71h+tVhJGwXBeZtYu2QC7Z9MavUEJ3/qRGHD
    T/1rd+r7cQPJmJgroqWdESPDQvOfeYVWzlo4PrSusEXRKWUIf348IHayW+U+ABsS/p5zgz
    LtQa9VpV9I4ci0IXeDGAWCOk7icknwQ5xjtgshNkKH/wQgGljZG6aUtrMxBA
X-ME-Proxy: <xmx:U0_tajjUjFJh98NIqAbkm3jLX78jAnPjRQ0s_6Lh_NsdrWYNsPU2mQ>
    <xmx:U0_tas6AXmcfGXwa-tNfy14HBs8OL_9trvrXJu3bDqXjwuw2RVFaxg>
    <xmx:U0_tai2halpGc2eOVZd7ParpGqOav1JtNULxl79TZZZdnW9JNRj6wQ>
    <xmx:U0_tavs9MWmSQCehjDEX00aRu3j6fVMgI5SbvdhZxAdwFRsizlgQ4w>
    <xmx:U0_tamG1DsbY6sF5_JtN6Zrp3qbz2yMNvErYE7gpcEwsRgri6oSLacuk>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 22:53:54 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] ksmbd: skip metadata-only stream opens in the delete check
Date: Thu,  5 Nov 2026 21:53:45 -0600
Message-ID: <20261106035345.728454-3-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106035345.728454-1-icb@fastmail.org>
References: <20261106035345.728454-1-icb@fastmail.org>
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

A metadata-only named-stream open without FILE_SHARE_DELETE blocks a
later DELETE open of the file. It also blocks setting the file delete
pending.

Ignore a stream open unless its effective access includes data, execute
or delete access. Reuse the sharing-access helper so overwriting a
stream, or creating one on an existing file, still counts as
FILE_WRITE_DATA. The Time Machine AFP_AfpInfo synthesis keeps only its
requested access.

Fixes: 19043971c947 ("ksmbd: honor stream delete sharing for base file")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    This affects shares that use "vfs objects = streams_xattr".
    
    Tested on ksmbd-for-next 957772008502 with KASAN. Targeted stream tests
    and a KUnit matrix covered metadata-only, create and overwrite cases.
    smbtorture matched the base. There were no KASAN reports or warnings.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance.

 fs/smb/server/vfs_cache.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index f9079c529d07..c846023e5ada 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -420,7 +420,12 @@ bool ksmbd_has_stream_without_delete_share(struct ksmbd_file *fp)
 		if (file_inode(fp->filp) != file_inode(prev_fp->filp))
 			continue;
 
-		if (!(prev_fp->saccess & FILE_SHARE_DELETE_LE)) {
+		/*
+		 * A stream open with no right in FILE_SHARE_CHECKED_ACCESS_LE,
+		 * implied writes included, never conflicts.
+		 */
+		if (!(prev_fp->saccess & FILE_SHARE_DELETE_LE) &&
+		    ksmbd_sharing_daccess(prev_fp) & FILE_SHARE_CHECKED_ACCESS_LE) {
 			ret = true;
 			break;
 		}
-- 
2.47.3

