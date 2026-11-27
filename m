Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.156
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795812595;
	b=aULMgBo3SxabN++GCjRsm5eF/+0SdXER600c8taOktH6uqQU/R3W5R0ks/sYhdt+k0QT
	 UQ9oT71bcSaE+jOnGE3qvzGjB6yRaRipNc6ZI/Xh3u4E+mYK7Y//dh9h0d2OT1/wzfcnw
	 vYXOinYYYNBnp3HLkeQTrH4esBqKZXbo1i3OiA42MoHbPPv6DwZyC/laihPwFPV2uUjAA
	 MK0pHZmGWhKaUmgY59w7y2H2aLcVGdRjiCOO6kaTkTNuZLuNTmG4yGyCLypcwxF9C9gBg
	 Mj85WD7WVWxOlJdeoY4AU3sipRRVE1BKC8LSWWeIfj4FkMpBj46wa4cxq6enXTM+HrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795812595;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=4ES/kCXUDcoFqNB7JDmXTc6h3gRHJrDhlQgxDxJ9IV8=;
	b=KnCGNr+l698DWS5Pe3tEy6FcaN5cup8VdgcisMMDhVvjW0ZyMd4wTIiW+7tc11SE0PAK
	 7pZFn/KYOL5lwmNjBs/hK1dbYeQ2M3XL+OI0j8Po2mdoqX9uycDO7cxirPdMHQvpUqAOr
	 QMgEnxSlWM9+I+S2eW8p3NUDRC8gMCIW6o+t67PQvGFnhluruewkBDYROxJhQgc1MdWJH
	 2lIM47IakJfZY0GUcPouoxxcVH0o14txDAgvCN3Rrk2qGITSKbp+HEKi6+8aPX66tHgow
	 QG6zyryWTz/ioApTDDHi45MeepDYxZ7kldt3TT5jv/eonxp41e6c91KdkkAeU5ZlIyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=0xuc4Js8;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=RDHh5nCc;
	arc=none smtp.remote-ip=202.12.124.156
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03C3606A31C
	for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 20:49:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C03C3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=0xuc4Js8;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=RDHh5nCc
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 256257A035C
	for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 15:49:54 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 27 Nov 2026 15:49:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1795812593; x=
	1795898993; bh=4ES/kCXUDcoFqNB7JDmXTc6h3gRHJrDhlQgxDxJ9IV8=; b=0
	xuc4Js8mtRODy38DqcB1PViDfpwHQ9lbNXVI3iGFVwInrAUQr57rv7rrS+YYt878
	r1ztDJDsxPxhZirpNgIHpzcZUzogaFkO0ts2dxK8iJhn/toIIiiqdT1bkeAVkyYq
	sKAG86foBWDyc4e+4qDF4kky4A7TihytIdcDvByzyikQUBdOEsTZjJfa35P/vpoU
	d9U0i5fz0yGJJEy4jcZkz2IQxKW1vKAc9xopUrEG8cGW5f0LKM8LgIP9vftpHNfX
	cjr33lr+gfTCozNnNOiHSzu/gdlavX15vaEwnGqpfdbDIgRQbYl0/AnmXgYlghfK
	CA3XxMqIu5/a4cDBTVGWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1795812593; x=1795898993; bh=4
	ES/kCXUDcoFqNB7JDmXTc6h3gRHJrDhlQgxDxJ9IV8=; b=RDHh5nCcSA2d5qFrU
	mVLXrqGuyQhuU1MD9kgJ/kq/QD97K43q2pPTyzTQ56ImPqHE2xMeZkpqNFW7uwEZ
	To2aTCL97/gQUuXyCQBUZaXAUKMSPWYcTAGCBZDQyRICFXYLAZyWakIaGDPz91sW
	VCb+nk1QtEM8iaZDxlPn/hg83YFp+26mi3oI2vqs4E1qCFDLuTl2qqMzdA8CU48U
	PhQgc8xMIo+WCJ/jX5X607O4Slm+0nXdzHTwGBhdjBbxP3npOO71W2WLUUJF3+zD
	lw2wUKhwZkf/xkUad8+0HYN/VIlz2Qeg/eJegw+bcQXwAbotnb3S7YTaGRT3koiT
	oKJ8Q==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795812593; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:HN9wNNut/akr26oII06l0JPRkCCzwCqHrmI47uApvg3nTrT
	3RdsOSiRLmG33Q70DDqUawCSes3qtb4RwJlxOYB29IUigBL8VqGkZnl14OmYoyGR
	ltevBaUAy9VBZ2iDZWcbDTgpho1a5HH1VxlvaI/z1zT8AtXOju5IK7BzmD3Nt9Er
	SNONz3P0QHPcL2+HTv5L9r9YwWOmhq2KqeeLXp8R1rJXsALSFByfcrHUKmZR11D4
	JDpkxBd1FpD7lL49f5V0VrZVFRq62SMM7NfBVtJGnYnikIeDjPT0NcqpwqL8PESP
	RgSPh7xTUyxBuPNxqCnMZPVLLpXt0IUrYxAVcmQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:R4aeRE9ELHRQ16OjjeltUwcnYeISWOQKmqZx+Rvh6uE=:4ES/kCXUDcoFqNB7JDmXTc6h3gRHJrDhlQgxDxJ9IV8=;
X-ME-Sender: <xms:8OwJa1Oe1qRjniwv4UZklENgTl1KKTDhrghy1mSdZE6enleeuaCE2A>
    <xme:8OwJa4axxQG46HjEJE3Z0tMn5j9VB0fXcUvxYhBgssMFPx4zu1lJkj6qKP1dsSAMv
    mSKhCseHkkKFdK6jmY0IFVUGkWuWtYPSwAiidfsBcqiq2h_nezsghoj>
X-ME-Received: <xmr:8OwJa0_2OQN2ElgcvZwMSNtGx5bRtCa98yVw7WZdUPSdSM4WfHsPtKbQ_bkHhOFA>
X-ME-Proxy-Cause: dmFkZTG1Iy+qbUXSh44khR3NSIn6qa8D2E9QegCcrg7sn8eNpHvztzohVSB6sG++kXcbRQ
    RtJ4Kj2ZH6NAJIFRqlmEVQCVv9/GEhinLMW9NxsvDMwCkSErEYnSBlOJ5Gqzn4BXU8CkRr
    LV2Lz1Oum6Dqyis2Rig86RNcW141d7MX5PyqQYqTa44wFP6+g7qXr/LT4nKiY08aHUKJDj
    dwoWYWyYvWOGGXZkOB03T90xQiQZSS4QfHQArzQ6fcfS1mpZMgEd60Qhj4J9QblJ7PQmox
    Fy38gOZxciXkrIQfNNouC6JfmyBNbVVkCdfiZiQA9MQ9v6Z1QLe7/Mgz7obluH2sWttCN5
    APH3eU1dADZ/8r8b5/SMzi0ZXfzalcRDC4k1vnCbrk60r8LQLIHkDeyR1b0yvo7diEwYhf
    cdEJotgMCcL8tF5hdlpPQTF059RChVx3iWSyczYuRphRxlZMgAGcD6Arbp7cE2Saq/tNuW
    EezzPKZjTrujyzl49/1zmPERKu0oZgtbvW39wHEXMh0I7ACbrPeP/RypgzCxW+LIkBZ8Kc
    2KibzI1Q2vivzp1o2NO5fCUBhoJlX0d/bgZVwZU0q5uN4rC5FFlhjbuYnDV0ANK8ULUtjf
    ywG40S3el+/OlILgTT4Wb87xtUwi4GDvcKH0ByQaBN5cDvxxbqUVyanw949A
X-ME-Proxy: <xmx:8OwJa5TAmH3_3BabMBu2itFGBVxNG1NnbckNGNH7hAvIWKG_HHUY5g>
    <xmx:8OwJa-cvJQvFg0rFTJJJPG3BfvIY94kD_KL5B-EnSsI4sEU9LCjX3g>
    <xmx:8OwJa7TwR9NFHdLbgvl6V_X-0hpEiwmVtUAQsNdiz2UyzFSx58zFqQ>
    <xmx:8OwJa6IM8fH3vcObnCZ5YA-43wWUX6_m9NKZJYd3XbxlfitbqEMgJQ>
    <xmx:8ewJa9pCCkRNe08AIR0P51TjeyP1-Sl4jdd4hcoUXb_Qo_9w3Q_4Jl7G>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Nov 2026 15:49:52 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	stable@vger.kernel.org,
	linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [PATCH 1/2] smb: server: use a counter for the nonce of encrypted responses
Date: Fri, 27 Nov 2026 14:49:45 -0600
Message-ID: <20261127204945.1646186-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <f8e60e33c424c1efe397e94bee170a45823e3d95.1795797772.git.metze@samba.org>
References: <cover.1795797772.git.metze@samba.org> <f8e60e33c424c1efe397e94bee170a45823e3d95.1795797772.git.metze@samba.org>
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

I tested this patch on ksmbd-for-next 3dcffd93d4da over TCP, with
KASAN. A raw client used SMB 3.1.1 with AES-128-CCM, AES-128-GCM,
AES-256-CCM and AES-256-GCM, and SMB 3.0 and 3.0.2. It ran two sessions
on one connection and one on another, including interim responses.
Every encrypted response decrypted. In each session the counter started
at 1 and the random bytes stayed the same. The random bytes differed
between sessions, and no nonce repeated. Sealed Linux client mounts
over SMB 3.0, 3.0.2 and 3.1.1, one of them multichannel, read and wrote
data correctly. A capture of that traffic showed no repeated nonce.
Encrypted smbtorture runs gave the same results as without the patch,
and KASAN reported nothing. A Linux client mount over SMB Direct with
soft-RoCE also read and wrote data correctly. That client does not
negotiate the RDMA encryption transform, so I only reviewed the
encrypted RDMA read part.

The counter also shows a pre-existing waste, which this patch does not
cause. ksmbd encrypts some responses that it never sends.
__handle_ksmbd_work() encrypts the response at its send label without
checking work->send_no_response, and __ksmbd_conn_write() then drops
it. An encrypted CANCEL takes this path. So does a cancelled
CHANGE_NOTIFY. smb2_notify() sends its STATUS_CANCELLED reply through
smb2_send_interim_resp() and then sets send_no_response, so the send
label encrypts its response once more. In my test each cancelled
notify used two counter values that never reached the client. The
nonces stay unique, so the only cost is an encryption for each unsent
response.

Reviewed-by: Ian Bridges <icb@fastmail.org>
Tested-by: Ian Bridges <icb@fastmail.org>
