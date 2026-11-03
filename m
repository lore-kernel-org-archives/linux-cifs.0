Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.150
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717674;
	b=jNzWBAMlPvnFFDHJ/kVbz9ThLWBRFPTTReQUBMwZtmiiu5b3UFN8pYgg3xKpkyLIBYKR
	 VuVyHYYkSDFLWXS6vs/94YQm75h8lVAp6jkBOlgOs2Kh/pd+DaXt/K8oh0xIO0NDfyIsQ
	 +oatN4/DOg+1pLMwkkG0bVHVCHcBCqvQvRQnkJFMTcOWoUWLrCjHaHB3dAcxAeZRzR8Ac
	 lYAvgbbBxauLzusvxM/QhX7HtW6Ib/RW2iQ/R7boZ2PYnBxPOeoOrfbpFs9K6f5TITpp4
	 av14vloeQNcPnr86YaFb+ZDt5w55WlCsNIPdUZjfJ7aF3bBZW5/bAVWnVz/PjZBXMXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717674;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=SSy0GYW9yR4/et/pRegjtStKlFfpGxw/e/vW5MJQH1g=;
	b=XcXBFl+zCPOmOfgbQHYDCYv6zW8CUDtfWx09VdAWkcbxF/IH98SZIqQT4pbw40YSQzmA
	 dlnhW2XcL7VUBRxlP4cglRNOJlsYbVnBohUjm3g2S3ti4i+Ea3xOhIQ2ddAHBsW2TZSn1
	 P5xRJysdacmtwyAWiaKPjy3F9pAoRiUNYRMgan7++98YQi3gTpyAJmFtS9Gr30g/r9G9h
	 aH+yLH15C4sI3VflOB3OOYWPa0KXAOSZTmcv0moRvqROSPS7GoRvC837EEnXrc8KJKOrf
	 UqD7BTfxvC6hYekK4h6sm0icyqGmeuulK/ouB3HoZEoHrRM2b3M0McrFNgrGZr98FSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=SVdLAeud;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=0lJqVcia;
	arc=none smtp.remote-ip=202.12.124.150
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEED606A326
	for <linux-cifs@vger.kernel.org>; Tue,  3 Nov 2026 14:54:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FEED606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=SVdLAeud;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=0lJqVcia
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id B37BA1D00236
	for <linux-cifs@vger.kernel.org>; Tue,  3 Nov 2026 09:54:28 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 03 Nov 2026 09:54:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1793717667; x=
	1793804067; bh=SSy0GYW9yR4/et/pRegjtStKlFfpGxw/e/vW5MJQH1g=; b=S
	VdLAeud+q/wInsQDqqsUAcWLzXyBiSNh5a7e92keQ44lw5NLJ7wUkFjTEE9BMkSZ
	Yf8D41EFJWwKDFln5xHCPH8TrFN135d2ipSP8e8vB1an9tffaoqYQQTuJZYp0kRD
	6bWsxrcyJ6TFpNzOwOWYeNAGO7q3LSlazVCxr06VQp2eyu4bVpz4aAAOYFvClZzS
	aGhoko7+N4iuVkdZsMI3kRNRRpKPmdATNlHEt+dgEabQ5By7ozi+8JM0UKte+vOB
	3ZjjlnBYaj6ZuF/2ekrwxCjHO83NPlV1UEs7RXATrq6mfCnHNXKx7/vw0qjGbBsl
	DvCnlzkOZk2ywrseMig8A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1793717667; x=1793804067; bh=S
	Sy0GYW9yR4/et/pRegjtStKlFfpGxw/e/vW5MJQH1g=; b=0lJqVciaBelVs7ke0
	6+v6J9dz4F89dFPPZZdPpjRWjF3IybbvsfgrJGUkA/fLHjjeRnFPnP7ni/ThHnBY
	8c/U4yDyt6Q4UU8pisKsUmwD2EOK/HApw267UvC0e7CPFEIqNYwp64gHh7Dvn5Fm
	s2IpXFjKREzmE7OO4FX9RkyXJGKhrmMZkJ+QBVzv9lF0y00cDdZjBrw8gcME8iBl
	a80OowZ3bvBaRsfQGM/5oWRQq2zHfYvaeBeZuCQ7VejnliX0MXNV69D8etJoZpHE
	1myfDklidEsgibXZs6iLpkk0wf5zY8bio8AosG/P8bDIxAeSGDSaHx5V2iSxZ6/J
	EHFJA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793717667; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:V4hVVKsy0foWQ2s2pqXn2m+QoCI+UmZAGLQvvbVL/mzIgRy
	HRQkvKH8boSykw3VCQxMEXMCTOZab8TLg2z2bDJiO9RV0yZEPDVoixeqGkw4XFIo
	VStTpSIEwSIW2CBq+K6El9VztfvxgNoayc43wCwhYxAKP2fYhzs9Nk4iiIfy6fsu
	bhN15Wj0+hzxxGp2cLwf8QB5/9FrveaTPVT5CeNTyhm7aINRiz6gbeXnC6y4OOnX
	tMgwAiyvraE7Kem9Y68+S2TePN9K71lwGn04xVj/W+NOWpoZxccYPVT2ugW7Lsqi
	6XWFF2Cu1iyZP04NVuD7Ix5P1GBYbbLu2NoWRQw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:nrSmHOa7lzwzvlWV06WJub79sz1mZ8uA5wp6BHlMjkE=:SSy0GYW9yR4/et/pRegjtStKlFfpGxw/e/vW5MJQH1g=;
X-ME-Sender: <xms:o_XpaqdOfVyoLXOnfElKaFgLUsoQXWsSzJcwqm93JTpB-otlk_kOyw>
    <xme:o_Xpav6_nr3RZj7wTvjoHdFb1sJ_QVYQJASJ1Em-AcTOO0EI-au0SQx7GSerkAkvJ
    cMoABsvjafbFX_EMK3MsM23qwRyhTlX-pMlK9zVJp5nHQMBMUyn_Q>
X-ME-Received: <xmr:o_Xpan_0ss_kovDi0BvUuiOaqv3jxrluIReCu3xVTwhYVgn4Z2k3SkhMpOw-BImS>
X-ME-Proxy-Cause: dmFkZTGjXhpuZ3h++4iNHGnZA4O5fFr/0uT7x86idCLG/85j2p6KL36wtfebS2Xc5ySmMb
    19LyPhGS6OyebFzppJp2KmpbHGC8rDleAGkASg7sqAe3aN9+mXEF/RANIiDiGeZiiz5vSg
    QaQQxkmNYPyqhE7t/dRGK1DIZJnPTA5+DTFcEy3voNmv7J3vrQKHJ4X1njDSf3VeGI8Kvi
    WrcSw+sAfhXlnaaRm0rwp98DRNapQREmuriDR8a07ThQzH16K95qZ7HXZOE+pmsovyYEXZ
    KFd8sgybNTIaqJljeRBDW85nJFvQZBI6ImoZg+ZPslYLvF59KYNzawhueTcsYkfkE6n8Fo
    KyZO/FVyQ16YpnEspjeLs9n/2f1Khd0VwuDKW0i5Kn8un7EhJpkCA8XYazhMptGvQCA3MT
    0gOlwgK6rXjB1zgAubM32ttv8Wmxsumy1aaU/j+sxJ/MLIM7JihRzmL9AQ7Iw0S/BemfQs
    dqk0znlxQ1FFRugC1laY9pxnrGjNUy+jZttceg9MyNHuX7F+LW5bkN9maRGOxgIF1s7yEU
    zwevLB7jWBLqZZOzltzZWf7QS75GQCjyvKzKtR29ULEmkYFdON2jxbjr1xjsvWCVdGEEnv
    GVUrJcYhqVKuwQNIMc1jawlQgO2He2Ja0jjvp60lWSR5CJuL6cPmTtV01etg
X-ME-Proxy: <xmx:o_XpahEMDholwENdSP6RCIg2FO5YNVciORN4cCVogcfR1g5I60k4UA>
    <xmx:o_XpasXggG1M37XzX6W2Le0eKb3lXbT3o0-4tX1qiZm11PrWEbSrbQ>
    <xmx:o_Xpat8aLQk2zNq-BMFlfyk9Grq6oasJPxKTxJsPMsyN3yilUO05OQ>
    <xmx:o_Xpap7bXlhqA2wjoSbQtOq4JUTWRXH8C4OkyMTo4KgCBk8QMpHxkQ>
    <xmx:o_XpavuJUMxy97ufdDwFQokWaPUxjQEk7nQSRozQFqzlMfzb0IjKWyo4>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Nov 2026 09:54:26 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	stable@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [PATCH v2] ksmbd: grant a caller what its groups and OWNER RIGHTS ACEs allow
Date: Tue,  3 Nov 2026 08:54:19 -0600
Message-ID: <20261103145419.10809-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAKYAXd-s-g2V4LNY8e5SsH=+0r3qLY+AeOa5Lp9K0T5p_tnA8A@mail.gmail.com>
References: <20261102200353.884509-1-icb@fastmail.org> <CAKYAXd-s-g2V4LNY8e5SsH=+0r3qLY+AeOa5Lp9K0T5p_tnA8A@mail.gmail.com>
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

You're right. For MAXIMUM_ALLOWED, v2 skips deny ACEs for the caller's
groups along with their allow ACEs. An owner named only by an OWNER
RIGHTS ACE then gets the rights of that ACE, write included, even when
a deny ACE for one of its groups comes first. A probe confirms your
example.

I'll send a v3 that processes those deny ACEs when this patch decides
the MAXIMUM_ALLOWED answer. Where the existing lookup decides, group
ACEs stay ignored for every request, as before this patch.

Thanks,
Ian
