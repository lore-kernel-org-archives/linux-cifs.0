Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794508072;
	b=XoMzbhwLOS6lnLQ0jDcV+pvVXyxrbj4lNGwXf4VqLQcw7l5mhb1HftX/pG4zucaLKn2+
	 sqGKufBB/Ap/8H3qoxbnuMe7dze6JAt10kiA+MszyNNSYSsL34Pwp/msAMlTc92mYbvnn
	 J2DleuX7BUGYcbeLRSAwMYI1dS8L9r7K+UsFwzcO/dmCXXlU9KmmHowQOSu+zLPDup2C7
	 Y2/QD9Uk19WaRJKypbLxyWGVbjPoSe7dBNbM7wBJ5uKAR/VJN4cTLNc3OmlUHQU2kdaVI
	 NAoRoFT+pEUbXiTZtkAPtlsmZ5sb2J6JKvUL0TOjVfQTP3/yt1DKs1zXUqc8ZUvnqWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794508072;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=hyOe1qIYSAlaopLsmdJoSIHlKwSSKycDo2uGB7z/DWk=;
	b=4ZN4jevwvQaNijXwnfY6de58SSnpU4yJH4+uH7y65CtgTqX3zI9v9IpIrhdvF39thdNs
	 ex5BrpZ3xRoGRY8Q67rraIVSGZCIfqovy2T6zXPiYUEiW6bS2IDxRhjNsAla8znjdYCV9
	 YYj/A/4WURg6VRFQFDm9CnL7OoU9sGQiqfcowr6FTAaSRjopq9bzcGnN4QaixN4/fRVlh
	 y7U8MiuJNw99ztJZu7QyvJPpa4/OcmOXwEsg/OqugZk2pZjz/vgMVHI5AetJ3/B77FxFQ
	 AAcPj2MEqf3tf8s/mq3V3iAtKtysGhtAQO11FQh05Ri3Bm8Ryj2NPuv1VVTNcV8kSdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=SUraC97l;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=L92YtupR;
	arc=none smtp.remote-ip=103.168.172.138
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC902606A321
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 18:27:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC902606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=SUraC97l;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=L92YtupR
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id CA34B1381C25
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 13:27:49 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 12 Nov 2026 13:27:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794508069; x=
	1794515269; bh=hyOe1qIYSAlaopLsmdJoSIHlKwSSKycDo2uGB7z/DWk=; b=S
	UraC97ld/ZWGqluUoVKkoM3M5onanyZf5ksQs8TMhnm4DBBIghTFTQWx50XHAaex
	l4gOygNfIK8VXbSVbP4KPpcdqgbWPhLqnWTHmcQ5x7981TNMuB6ryirg505VL1Ju
	t7Joc3EvuGjUPj8+RcNZIKlJLqLYOMXypiPFuJAUXRRiski+I7iKuhb3DzYWypnS
	+Qjia1IFPXoNhJKelG0Q1yPOz1GnwM4xSvJBBqVIIpznWhQJqRQE1pKnajxeB18/
	qPjsi3WoV+A81x3f+W64veyRqidx7TrObN46vON5QAAEOxXxTodVyW1cfYeMNYLN
	ixUXK81NqZmSKo0Ypo7+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794508069; x=1794515269; bh=h
	yOe1qIYSAlaopLsmdJoSIHlKwSSKycDo2uGB7z/DWk=; b=L92YtupR47aqC5gzt
	Jh70DCaWAgFAReuhdjlXkE5E2fdP0jnse5+Wg6fOqIV6BpCzftFKnNh0uPbrDacu
	XrjUIoQhPQM+r0XeCPZ27OEbfu3UgDISt4AiwvHDHPHpMB2f8k78za8pqUgyRfyW
	QoLqw6g4N5Xvl/mvSZ1sEwyzVNG6cNFSxg21D4Mkc8240+SFG5T/GpBg2prRidni
	dqZGuIpZMizj39PDWXVH+nZUBAGYVO8ixh7qovn2pgcAVPYhyPdQ5m5BVaV2Dyua
	3ZiXfAygtNrUtCuFAvreA94zH97tK+6vhOFSS5u3vb4psirKXxIwkpukdbhQ3qKP
	6tbzg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794508069; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:BI0yQLfkBpIwM69DqHAIzXiyY5TVo8akIW7neq0GLF2LpKP
	0vOuU8c5ebnG6GEpTPJdea2KwAnSXHxX5ybzDfNAWIow2mjRb/UIJOcMGiWSGCeD
	Me8ZMOIrQEQnvmHQ4XNr1MRoDcWdqGSoqlXg2EXFRRCdEEN6Bkj0TSNzxfGrEgl0
	nZDhIdDnoKI+qBY0IkN8iuLfjEBtrqcLHQYgx8VVBj/AxBBgMOjHXXMpJC/aI514
	ZZM8d5IabInoGuo8XVk9bOYkIKAOGlhpOSpDPbrjPyYhkDEJkPlInAz0wqut3nnm
	2+5XRunNJ+57ouw8D06E4e7M7ofECifecAKi0rA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:+BExkCelfBm5VPLFvEeTIWT30V6rV0q+4Zo/RGtKJ/0=:hyOe1qIYSAlaopLsmdJoSIHlKwSSKycDo2uGB7z/DWk=;
X-ME-Sender: <xms:JAX2anjnB3N85qav4ej7nTHwEnZudiWxeq0XNheg8odpw5D6lPPEVg>
    <xme:JAX2akfRnboLAFQP66Y6JMR7sqENjTejYrR6xF-m2_zsMfwfbghgX1AdzyFc1UEFw
    pXdkhTub3fOliqNkpdBFP5W92UjAjbBsNfT4_oaP48nst74JhN2EA>
X-ME-Received: <xmr:JAX2am1Vjx-Az5YjQ3FAohPyGPC5yMpHyX5W4q-e2WigXMtePvVaZEzZ8KPzWmVb>
X-ME-Proxy-Cause: dmFkZTFmlfyrKBOLV9UX274YD8pS/pTy/qCUAlkh87MPZQO3Hk1dnsDnFDzIM6ZPo8fUN0
    yFrUad9pEaMOFZADkLNTes/olIPi4QhVXYp7r0F9+70zStg1RYJY/V+NcvMVzzv5Xj12/L
    LAy/Lib/KhnsrDJ5mBE0huqcGiprrQpv9RPWQEKIql+2CpwQCQP38RV1m9+12NqeAI3BVw
    4drmwq4Fm71RwuTVe+j3ilhAER4Vuf7ltdaqmBYQF0vBX/Uu1eCQLwG2P0nSRYAsqX2e+v
    UVbMWKx/FYZUfWF7ZL9f1zPVSBDXuC1Mlvx5K86P9v+fLeiTT59ZiLAd43NC0WlKXtbLKh
    Rx0siicelKCSswIowMUpXORqGWg18gDwoBvrSeNpwPZI6O/UJSAsM7AZgnjfQfMhT3snFD
    5gyJYx315+soHXuxxWOx6PEXc3s3/80QD4ouC4arUMUCT+aQD4hyNDXMMGPryq850Lb6Ei
    L+CDYIb/sINHjD2bu/+EQkVFNfyf7bLOcnStazV2oIO4FRdZIaoSopH9wFrLXwSMmhP6ew
    Q5ZvIRKPN62HfkQ+OE5fQhRM/k0rlPMjJ/KMc8jFDyI43EQlvwXTJhmY51pBUBQnV+sSDr
    1Pptd3/Tyae1x3T0Bd2DOAJViDQQiKEvlTyiXixqrNjPKYervZ3ukFrRWOwQ
X-ME-Proxy: <xmx:JAX2agod1dOdMkWVfBs7bh8mYobtGzLGOXJONA0ljg3g5Q_W0Z3jpA>
    <xmx:JAX2auhjtzUACeLY4H2NBUSkwTAMifIuGtpX6dCP04-12-p6ZaPgnw>
    <xmx:JAX2aklZa6DoztU-EE1zCTkEfCQovIS1mTJtUMrmb7DoYPnHC74nRA>
    <xmx:JAX2avohinEwBKLAr5OTq4XxYP9_Rz7d0dMSA3C2WIRfhJipJZBYTw>
    <xmx:JQX2arMUyG3aF-4KdYea0ltecY1YYvJn2qLD1w77EwTiPhUzjfH-dnBw>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Nov 2026 13:27:47 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: koray.fra@gmail.com
Cc: linkinjeon@kernel.org,
	pc@manguebit.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	hyc.lee@gmail.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [PATCH 1/2] ksmbd: fix negative timestamps being saved to disk
Date: Thu, 12 Nov 2026 12:27:37 -0600
Message-ID: <20261112182737.1659245-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112111637.184045-1-koray.fra@gmail.com>
References: <20261112111637.184045-1-koray.fra@gmail.com>
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

Hi,

On Thu, Nov 12, 2026 at 12:16:36PM +0100, koraynilay wrote:
> When setting a timestamp before epoch 0, ksmbd converts it from NT
> format to Unix format without normalizing it, leading to the nanoseconds
> field to be saved (on-disk too) as a negative number, which leads to a
> garbled stat command output and a reported +4 seconds in the timestamp.

I tested this with the ksmbd code from ksmbd-for-next. Before the
patch, setting an access or write time before 1970 with a fraction of
a second stored the wrong time on disk. The stored time was about four
seconds late, stat showed garbage for the fraction, and a query over
SMB returned the wrong time too. With the patch, the time on disk and
the time returned over SMB match the time that was set. Times after
1970, and whole seconds before it, behave as before. smbtorture gives
the same results as without the patch, and KASAN reports nothing.

Reviewed-by: Ian Bridges <icb@fastmail.org>
Tested-by: Ian Bridges <icb@fastmail.org>
