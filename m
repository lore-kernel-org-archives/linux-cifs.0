Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793237330;
	b=I4LaCGxU+n0vXTUU60d7HRlyCYJzXwAb6PJjnNYvc6AMIUOe7fPtUt9V8BfdJBTtso6c
	 hGXp83tZTqZqmjt7+W7uvYmdAUKF+EkfjFwkcfOWnUC2ZBsj/EkZzAiIIDOnhItEoL2Q9
	 8eZF5tsc0veeYweS3jeba7/k5/f1b0slM6F7SXYLdtRQI1drNYfwYIstZ4c53OxQ/xGLc
	 Fdbk+1x/kFxu9Zw9/KCbf2w5PToVWp3sEnsh4jmztjFbM7qdN7YYWcaITztegtgsCDvtt
	 JXtB49WS3Zmr+AlHaYOyGE6xlDg2t/p4H5ue65OG+NIi1cMuUwzNAdQN/zwLXd3w6Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793237330;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/0NO8aBEarmfo6YKVDc+DD/Z8X1yyrLW/Smi80ixpHg=;
	b=ceNr5MKmS6FQBAj6GfpvL9jQsMiyNY1etKuxOmFVzOsszaAGUTAElm7aRQPUhI0SZoN5
	 deHRsRO+sXRSyquSKQAiGjQBvJyY7YkIE3BcCw5+mnZkXJYJ3f1NPFrGxhYLQhCEE8t5/
	 oWVzK/RE0lG/VFUwsGjpapUjFiJ2hcYSih0LtCDdPRugWDUVDKtKBerYXYxnbEi9lvxHh
	 GxkZQ/JWjzhLN3e8JRC8sCh40X8aqAAdqiZMA4SAw5oZn7UEQSaHxpc7xfq6IqExGHhnq
	 U0wEqZY29u3//06Y8HknsyPnC5Ug5FfteuXLtV6p0RKv9Bvo/ryRflKqppMJkGjw2Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=SC3wafVD;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=amyGc4gH;
	arc=none smtp.remote-ip=202.12.124.157
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF59606A31C
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 01:28:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BF59606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=SC3wafVD;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=amyGc4gH
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id EED2B7A00AD
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 21:28:48 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 28 Oct 2026 21:28:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1793237328; x=1793323728; bh=/0NO8aBEarmfo6YKVDc+D
	D/Z8X1yyrLW/Smi80ixpHg=; b=SC3wafVDXxz1ON7vmELrqfzSeZWhzb8WK0sLE
	mI4Da+p6Mu2uMz/eqV3wtE/ACfiHPzopC7AVQ9/rhuSZK4LYKZqNIbjKVk/Ei6RI
	XDNHLh/GPgYV4VTTxi0VvAo/CFdf0IrPkg2zne6ILz9Y3AUikTwzEcFm9SpWwJLk
	Y35Fvcd8s/tZZHbVvH8ZcXXwphEEyAFFw8O1EdCFXTj//zerwCoDjL7H+rY5qNZG
	eRgFpE9i0q6dZaf+LM/T3l6vpy7LkUup7ISCl1733WL3JhXM8Ybh+ZuP0od9ZzoZ
	A+vezepoCfXKiMwXSvxgTkDq6rqSbXBRCb2N2jLZB+WUcyxOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793237328; x=1793323728; bh=/0NO8aBEarmfo6YKVDc+DD/Z8X1yyrLW/Sm
	i80ixpHg=; b=amyGc4gHY34rfVgd+TVzLOQA2vWehbonZ25su7vCc8XyU0rp+9y
	GjRKUJqhq3qzyifH+MTVCz0ujurLOa+P2LG/AHXMBrrwVuc9S/7QqVv62IZsD1BP
	zoL6/r0Qn4KkN+BMelui10BdH/nUX1wWq5uCl8qETUhctyEhJWffPkJEDI2wP7Fo
	qXSpdkHedyTSaotajRTttV3LRq1AYzxrlQ0N+mniNIVJ9tJaUN3Gsl8JVVlgLjzG
	avDjb8DIfgh7nPHJKJleBTbAW6O7zF6k10guETmM5JfPd4ox/6i4jwH+drdJXqlW
	mBwwH9w128S/Hkq6i4LByp0cCOiAcU2dQKQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793237328; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:Wg66bNHl1v9LebuUzYQrXLYoBSmm/Y1TeF9ekjXBWoVDHWa
	Vv3NTJokmO2FjzEIS+DbuQlso0611oMEA8fxUZuWd0Tq5RVV0TWzEFC7k3iYazKm
	1PWkfqNiSDEzLluLe9WH0g66rGwq5rewpZMkmBfUHBLsE4DQ5U+uusKsRW9scqvd
	Z1kuyYL90vrLQrPFuQVkprq5jBe4wKfD/01e5Vsv3u5zh0iZxezqZH4+BBb2s5RI
	SRRsOpXew1W8pmkv/vqatg6+THV5H9dXAMWErnhx5BsHAwNqoCSMcubSNINl+JjB
	B9heYjNsmoIl5EFGvULaNJxTq9BgsOhcgb1keHA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:SX2XU/0Pct/2E7vKSdKGIRy9eTJvWb39Quc6weRqn9c=:2vP9M2cTY6YL8ggJBCOc8L8ZIPPy8ZBGxSu2IQbym78=;
X-ME-Sender: <xms:UKHianUpyjaG2lezwKYj1ew-R403A_IgC_oUEZ5jzcLWDzqnx0WHdA>
    <xme:UKHiarnC5oMFrUXLZvcTHmGVcsF3iXWtrzo-Qvk40p1NtE6kC62XdxlUwse9OTUPA
    RnWS7sSLWBDf5BGVkPcLF8Ghmr1XMnYXOU5Ay1vHdGSbT5hyPbGD7Wi>
X-ME-Received: <xmr:UKHiallvgu9o1ZG0QIWwwcQyJRNmsbgPOmtqSEeByqxrMOjgac1sUVeyXab7yve0>
X-ME-Proxy-Cause: dmFkZTFzWc3qmEIlBasXPa5sMOcSxC7y9KOy7H0gXrq4ENBBx6T9939ohqk8PgiFZbTTuL
    /Cq4fZepR/J87gfk2j9+F9/0EQy000f0lgrN0PtIjVfUK30PhfBBkie4bB4DIeoXuRTpOH
    7yzjBjwYRGVxUYzx40vWiZQIgn0jRydQq0DO1EiI1Lf678uXLm7G8/7nTj+xC0BCwxdlkE
    FyV0UoNOdLEjetXinPPy2uVbiiIKdsuzFMylz32RM0cCnlZvc+mkI6KQlkwBmEWy054IE1
    Uf0dhj+FxIbvMETbktjrQQMuDSNK04NUOJuDJMFNPapk0iLkZOUTGFWav3ZHCdqnfLbfs7
    uH93Qa8do/tCWyOf1ZuNKiQgT5g5Xm6Wb5iY9xHAc9y+rAUZvDsf0kc0nMtNNIt3TKSviM
    TnrAq0fHCVs/IvhqgwsR4hVdDwW7ouK5jrKJtuiPg5/K5hAkJ/I2caHyq4tB69o5zWAD0m
    4p6uT7yuF9UEg+2NiJpNGjhcsiY9n9pP/EFxYOXkgbh1MSrpPQwg1wREbqUpWOpn2gchLJ
    hANvdbQg3dQQwBgfqfRb/7m0X4CdPJYUNBgAw2NfnRKWz07h0HvHwosoZte3l2O/XOz+Iu
    m0YHTVhZWPZwecLmz0gP22Lf2LKfR7hzXcMXFFwEZ2AUwnBwu9ANCYzMACrw
X-ME-Proxy: <xmx:UKHiajY_UzGQY1d9wZvaP8zsbrAqTiY8DK_-qz4XjeT4bf55wQFO2A>
    <xmx:UKHiavRCImz5InWJ8pQVbTnKvSQcpbgheE2Wtw7Hn71BegKneeoOjA>
    <xmx:UKHialtvOjFYW7ZYQHyEGunsVWy3Oxl-uNP7_1lJPXkeXzEcoW2iIQ>
    <xmx:UKHiapFbUYn2X-4WUgSCQiVRPlF1pF-NDflYhnm_AZozi22csxNfBA>
    <xmx:UKHiapcRvNvosLZgElGcoenUTzJNgrnnsKlJSxmp4l3CQ_c7Wk5yGR0N>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Oct 2026 21:28:47 -0400 (EDT)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: revert fsids on durable reconnect and replay failure
Date: Wed, 28 Oct 2026 20:28:03 -0500
Message-ID: <20261029012803.222197-1-icb@fastmail.org>
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

On a durable handle reconnect or a request replay, smb2_open() switches
to the SMB user's fsids before calling ksmbd_vfs_getattr(). If that call
fails, the code jumps to err_out2 and skips ksmbd_revert_fsids() at
err_out1. The user's credentials then stay installed on the shared ksmbd
worker. Later work on that worker, including other users' requests, runs
with the first user's fsuid, fsgid and supplementary groups.
ksmbd_free_work_struct() also warns, because work->saved_cred is still
set.

Jump to err_out1 instead. No path is held at this point, so skipping the
path_put() at err_out is correct.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Fixes: bb8bf7eb13b5 ("ksmbd: add SMB3 request replay support")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Reachable with "durable handles = yes" or through request replay when
    ksmbd_vfs_getattr() fails, for example when an LSM denies it or the
    filesystem returns ESTALE. Later work on that worker runs as the wrong
    user. The leaked credential is ksmbd's own override for that user, so it
    is not a privilege escalation.
    
    Tested on ksmbd-for-next bd24b89645c5 with the getattr failure forced by
    a debug hook on both paths. Before this change, each failure trips the
    WARN_ON() in ksmbd_free_work_struct(). The worker then serves another
    user with the first user's fsuid. With this change there is no warning,
    and each user's requests run with their own credentials. An ordinary
    durable reconnect still works. The natural triggers were not tested.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance.

 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f3cd6ff7eb09..b126eda48318 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4526,7 +4526,7 @@ int smb2_open(struct ksmbd_work *work)
 			file_info = FILE_OPENED;
 			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
 			if (rc)
-				goto err_out2;
+				goto err_out1;
 
 			goto reconnected_fp;
 		}
@@ -4556,7 +4556,7 @@ int smb2_open(struct ksmbd_work *work)
 
 			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
 			if (rc)
-				goto err_out2;
+				goto err_out1;
 
 			goto reconnected_fp;
 		}

base-commit: bd24b89645c5fa8283aceda78dbe53aa234e6bf9
-- 
2.47.3

