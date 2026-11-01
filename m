Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793569658;
	b=041mSsfyZdkPOsdtkNSh9ODI3xz+7kFOF/bz1pLXGji4N5bQhLjJFAJZBcNLjQ7jrQq7
	 oJOKWqFoIP/EbmF/TWYySQBUYE+0NC4s1o3rLndtZp6o75cY/eStP360X5GNpbYVmXOl6
	 272JmedXUu7aVZQ7Fp4PVOXmUZw7ke2Qy7K6AXT7aJbmcxxQcZxQfpjX8T0qA8KgAsoIH
	 DwN4SRF6ShQYAcpmv5qtQ4hYvuXtbVWwMctsM2pUXCULYfAn+5syo5ZSSF2fkod2cvQee
	 38DSzWOs0fp9NQH0cjIuFLAe834ZgGtk2PdmkwyQDvbvbo7rCVWBwC8f9SPO3B0o2qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793569658;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=TfQ2I+R1RGUPFEWLUKI19YZg1UU3i8pVJ5KkC7O7TAI=;
	b=EiLT1T9SZoHMFoXswDTjufSnfaBOao/pZh7jdPYjpmzU0ckeLOkjlr36c1thkNzH0MSY
	 OfkhKmrzgJNWNfUGMkBgiwzDpkHxQR3GaMDhSjAlx8S9V2Ea8/0tERwbFtcTY2GgcgZPs
	 RbdR20UbsclBx8oXKDWPuYHxlYyuFskYv6yOhG6yIa5i/VZhrRP9TYtGOVANE1rfvE9Go
	 JfkEVEZpgKsvachvzfw/oxQU1CdzdljCKVDxKkxFTq9IRqOh0P4kj+2hjdID4EYin5L6J
	 kVTKwUQEqKPCJTKh8pleSzBx1yx8PgZM1rLJCqkboPyJ/oCywY2WHn4/pzbAbr6j8ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b="OAgnY/1L";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=NFjlWA8Q;
	arc=none smtp.remote-ip=202.12.124.144
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850F7606A324
	for <linux-cifs@vger.kernel.org>; Sun,  1 Nov 2026 21:47:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 850F7606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=OAgnY/1L;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=NFjlWA8Q
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 0FA5E1D001C2
	for <linux-cifs@vger.kernel.org>; Sun,  1 Nov 2026 16:47:37 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Sun, 01 Nov 2026 16:47:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1793569656; x=
	1793656056; bh=TfQ2I+R1RGUPFEWLUKI19YZg1UU3i8pVJ5KkC7O7TAI=; b=O
	AgnY/1LXV2bgTsNbzOulc6cfzZFWwN/yAb0gpnYH/RVgsPjYNOayHJLjOGSUV923
	y/e3e2xwlTnNZW3rTYXu5F0b+UDTr+1vqY4QgGR2sMlhrliyVE6MFaXh/l69a0/H
	rK/9W5qr1SlAP1zlRINdc9v4490Pi5c+1UUhwRZQp6kVGjEg/sFImlhgbO19uHDX
	QiQCpkqdcoI5rk2+6A9w4nK+ajlOY/DVs07qB3P9+a4S/m3xfRd90zEtosTpQKAM
	8l9X7vDUEO7RLJOEbl8C3a0MlovhhLa/7HHZAKH99FNYf3zFvpEWn0NNWr/XQDGk
	KaZKUnjNuP/ZO1cyeOj0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1793569656; x=1793656056; bh=T
	fQ2I+R1RGUPFEWLUKI19YZg1UU3i8pVJ5KkC7O7TAI=; b=NFjlWA8QRwwHP2TOp
	chRteRFIsiiRVV0GBUzNQmy9UeUzIxGJ71VOul4WSakbZlpf0/ovy4I8JuRiwYzt
	uIzwjAJuSpnT8CAP2bbCHek+VcPQfW0XhWhCLJfemzEtLrAaWw1w9OaNva3nx/lU
	sK3PzglpcksS3eOUvnOOkSSGRs5+ZnjFJHhpWZJkhXjTR2CeAKwyz6Rx8wcKz/xO
	/yQKY44DM9UzveT8Fex6dZa/qWmJmvAgiuQ7iOPW111Fm5Aopm0k6CxBhUNtFWu3
	/NMQ9r/U1/X7oly7EEne/1BHEgymxS/wabdcIlk1GyvMb12bTlNQGFLS6SaQQrqj
	UivfA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793569656; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:UyAxOc7+Aet5nY92YElV++mDVTWBK7W5NR/WX4L5+tJGYyD
	kYtk9E0b39hWXWDMHLS0CFEMbKJGUX8HpW//P4iBcMCNvC0gRnbWWOHVdzOKccx1
	jhXxBxoIu2E2eq0pn5vsAlyRyAV7+eMXVisaoQGsJmTS3iUdlYY92p0rgStaGUy7
	DyHfChGVs+QzVVTTHrTG3R+2CwrzO74R0o99yu4paRISFMhkLrc5Dy8+TbKf7m6H
	kBflaUcUHHr9YXSqTEircJ8jMuLtx5iEMrZxYaqPAj6zWxhHypCUppOPBTpEMc0v
	+7/iD4C3u4xiawmmA+qTiK4xZXVM02nh8Wa+dYg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:p/o4aGb9mNGCizzP1jh+fyrKnTQL0euSFdWfqc2dNEo=:TfQ2I+R1RGUPFEWLUKI19YZg1UU3i8pVJ5KkC7O7TAI=;
X-ME-Sender: <xms:eLPnam4QIAbRp4ohE-gwHvTeVsaHMfihbfDs5rvsGOs5imhQjJcLxA>
    <xme:eLPnapNCv9cUEU8-Tj9Pj4lu70itkDCFt6HDM8qTpLmqMpCOJNqDRJAZqbtm5qsj8
    DgRCSsLHMwoVaR6tadB7Pshc0ubrxGWa6X1GkyN8XAGAaz4_TY1zg>
X-ME-Received: <xmr:eLPnass5OfJo43pgatwwnrwxXL13p4kfyoGz70_-1yrAMPxh-ZJSXuwC0FUwy4G8>
X-ME-Proxy-Cause: dmFkZTGn2xXB2HLZ4YG+2m4cCu3T+TF8EMbT2RfZDXxvr8XeapbMGc2tt2OmjZApSH7Bs5
    6STFEuwR4yMzUkRBosK2ckc1pIkAVcyDj01QKJ8lHtpexEdF+jfqTD61/Dm3HQFJGPwRd+
    2BBqeeFvlhNGTAAZsK24h+tqccnSZHyidJb+fOoCkpMcZc//joLmaOK2V8Yis+pllG9TtR
    fuOCK/BrhK+CtNBdut/bqICydSt6NWd38Tr0W0Fq6EAawrB66Nw6MMeUnEBsSK0z/NVlDb
    ieZodpSyaYccqAUNi0tKlPo4aZJ9aB/EVoOSzRW+ztLK9HsCZpxEbRj6bbSMYTNq2OhmNW
    2J3RapX7ljOcb4TpqsegIrHbflCvSsP6ffJh9ErghEcSB1A0Og2H+3Nez7QPjqEncx0NIC
    /yqadKg6YzFelYwPT5HBDsYBulBjPSFEbr5e8GdEJNM6g+FexhEFI+x7NojRFXyed15c94
    OTmdwRF6JF3ew/HO34j194xMeNEINc6qpQcS6UJqcctJ2/WmVjhuNnytCJ0pkd6Uos6RvD
    EVUZ0vMjOxFzWRc7JQGTGUns69IhE1t+nhdtgjYNp6MQbStyTfdV+x73u1vWpkulhEHs/0
    ycg2qNlPjbWhfwZlzBePSriuaCwwK5fwCfm7J5OJd5nDkIdAOq51wbRdpuEA
X-ME-Proxy: <xmx:eLPnakYcnmz5_M9Q0HCYEd4IQv5CUkYLvGy3N4rfjTe_h6iOro2u2A>
    <xmx:eLPnamxkSR-d3qBA_M42aMaoIsf_wnHh9H8ai7cSpVgsX7RxlabYTQ>
    <xmx:eLPnakjO1nzBd9FKpBE-B6PtBs6e8Z12Zxkp1swB_XRaAK7TnN8KiQ>
    <xmx:eLPnaqlgbqpusqygZAidgkLTYteHgveJhkjy4-oooaO4rpkjFGqWUA>
    <xmx:eLPnanUHYjEmpDekA7MhOdZ6XT0JA3ztCCq1ld9hQLA5Hh4Ecp8DTQFF>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 1 Nov 2026 16:47:35 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ksmbd: fix DACL evaluation for denies and guest sessions
Date: Sun,  1 Nov 2026 15:47:19 -0600
Message-ID: <20261101214719.732224-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAKYAXd_S5aDNPXTjmkfHG55SvzgCGuYn0ZGfgOesoSB0moMHRA@mail.gmail.com>
References: <20261030020523.302085-1-icb@fastmail.org> <CAKYAXd_S5aDNPXTjmkfHG55SvzgCGuYn0ZGfgOesoSB0moMHRA@mail.gmail.com>
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

Hi Namjae,

Please drop this series.

Your point on 2/2 was right. Working through it and Sashiko's comments
showed that the series depends on other issues that need to be fixed
first.

I will send patches for those issues, then resend fixes for these bugs
once those patches are merged.

Thanks for the review,
Ian
