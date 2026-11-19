Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795109368;
	b=hrZc/7MGXivJ7biO+g12yGWexe56ynIFBbm4zyqxxIisq4ddpOx5B7fBH0fZPjMf64Hn
	 UmS67gFxt88ORKuL385QTQs6i/s7NXjLUmWofy7Z9KhZccR/OQIcsnpsZeEaGL/F0XRf+
	 HdfWvLNxsGQ2Npz7yLaw42ciIkFh840UZRZ8KBY+YH/AglHzR7VKwUb0Liy233uOkHupM
	 i05oVAAOikG6rzyo33zzOwPzQU+Dcsq7mX0KymhZDHbHgLAaVG9B75plrhahwk2PWyoX4
	 n4CTViVIXeP60v5IVrojx4TWR2VEQ5CjhZfsg8uR/cEKAleV1hIF65QNK33PrcLOaRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795109368;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=i8tMEDSVYLVKgGjFTuvMU42m5HTOxZCy4VWNBIQuY7o=;
	b=erYJmNLPEhbFF8XAHSbOfSUvXBBpQu+nUmyE5zx+DEBNr18VyncUs+5pDghQh1ZBLUyD
	 8UKa7sxv8dWuCb/Xo/bnb16w9t0cXCmWWclbcOPkE8kadS8AU/WxH9mbw5ZSdGtx6JiF3
	 qoXbfDJwXRKURW0sHGe7kXXTFrhJNXsgCCKtJ7PaDVTNxNnj6ToeVpj2dEzJ9W52BDM7r
	 Uf21rn7QlrabcQ0ZhBLZiIGKZoAsMx2WVoCVIkHqeR/1zrPUFjU2NrFFLRcmJhFjUxQO9
	 g5YPK0DRH4Wp3ZKbF1BnxEkoSQPPeyWHGv2kuqC/IjiACHWpR574C4wJLTyvHZnfbRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=qlEtbqQx;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=n2dXfaai;
	arc=none smtp.remote-ip=202.12.124.153
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639D4606A324
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 17:29:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 639D4606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=qlEtbqQx;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=n2dXfaai
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id AC0C97A031F
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 12:29:27 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Thu, 19 Nov 2026 12:29:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1795109366; x=
	1795195766; bh=i8tMEDSVYLVKgGjFTuvMU42m5HTOxZCy4VWNBIQuY7o=; b=q
	lEtbqQxJEjeyuiUCrN5UuBiI2kp+CZSZKgzp8jzCyxKQgw/h3qkOxtWQEI8xdIkc
	foNpsoydrsnjp8BQVE3Hi045a9GyEg4n9cD1j+c6+etqYUbKNDDrS5LjAa/k9v/s
	kpOoQtYErKH0tWidxrbDiSsf0fVIzMt8W5hhHjumPvGPvhsu8Qnw6TJUcb3ns848
	SypNatsCEqzvHOgIHsLPc5alnqzREs1SuhqFs6PEwnWsa8KuU0tMW0NjrBYKrhFE
	iG2FHrjXe6nnhm1+bfWrBgXKMPfI6PDvZXqqFPNRk5fbbDLv7T+eeGAQ0AwTBLMR
	WtWNTTSXwdLuGyBrpLSEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1795109366; x=1795195766; bh=i
	8tMEDSVYLVKgGjFTuvMU42m5HTOxZCy4VWNBIQuY7o=; b=n2dXfaaicIQLo/dPE
	fWf7jn5pZNG52oI3rnRW8MTxZKQ+Qbac4viUxBfm5ceYCdoRhs03PGX4vgVwYgBt
	sqR2SKeRhlHhLmLYUfbEVi/Rn420rbJOFIP57rCYqIkqdWshqP/Ee+E6szKqALNs
	7Ra4ml6zXs/sfOPhYus8D8A1dY2R89l6nTMT4uRqggnxcKV2tfHY+GxSXri5iNhN
	z54DQXmUigUz4d2g8ABFsgfFCROkLVIEmTFKfY2y5hdQbDCMdOx7ib49iFhu/0NE
	9o+JjGRn2zshdjIwqRsi5qWIaECJOWwolK+7MpIyFsw4X8Uwxze0+AwOHreqMvKX
	ap71w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795109366; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:1ztqCYMedTPn+QzRJVu2f1KQcPj6RvleUfLVzqsY6Da5J5Z
	OD8II7lBr28XynpuiR9jc2uW6tgcRb/fe3R54y3f4+6FE9Yyv7BLKq6iL5/dDG3D
	WDDtbh8LcKn/p3mgoYdb8/H8BfhHJz71BoVc6TnX1XBk0bZoSJaEYZO4pWwOaFB4
	Ty7Fxv6lxrpGSvGJlScAnPWk5kLLA7ebqn8twB8nn70wr1X156ORLIYK5Duf/NA0
	CYAYnMR84qMRuWB6h7/NQU+J4N2Fa0ETcIl6DYhaSNF+5o85l3gs3d456beeEqWj
	YTQ+oXS+apnfve4vx694QL6TcddL82OGvsMDzRA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:SC1MlWhSOBuW1qvffNjwhRyeMekwHgRXl4hg3mljQUQ=:bo7WvcDcHlIhQrrUMAf26cpEmdBaS88CNPtnpHts9SU=;
X-ME-Sender: <xms:9TH_ahHqh_M5u5jcxStq6niQgwK3nkoQ9gaYD6QA30RTU3DiVCXtQw>
    <xme:9TH_albqPuGHu0KVElfbf3-_eskuKLxyqbJ3p_Q9uNviNwMBodF0wFeZPnJAqu10D
    QqLGCMyrTIviiDDrCe5DI-9LnLPX4RrgmHxpmnbARFpkPTcYrDLL58S>
X-ME-Received: <xmr:9TH_apXIJ5042cU0fmW9z9RwOUI-ZGLh6UDht95BY9_J9a9Kh4NYaYSCiXJCuXjr>
X-ME-Proxy-Cause: dmFkZTGSFyIZR6YpkpmoXeA8l5V9uhlH5/peAp/yDdK8XVxH0uVvbAPv9Pr6oa7e7+bF3M
    YQU3f4IERiBELJhHa4gpR47NR8kgXVMkFgJQFKL0H/BaamC6CadqljiaY6NJqNAMwS6OFt
    w04AgpE/KBXIHkcMyXHQJk4kjK3c01dC/z8KufQa3+YdDwVXkwFBoHAT/JM1aFb38L0BgM
    kBBNT2fxGsJFDKaG796alEsjFaxfImdeDskiBVCDsPsS9pbUaZRroCaBnGiRAMBlj4Si1P
    86MvUyM9o9LG4uqLmGjPYqqcWG7RK96W7RilrSaWyOrMtb5/5rR8vPxSW0JRVZXkdrN6oc
    mihmVLkAat+ufQrBW3wJ+vOqiQgIT0na3EVs2SrXJq8FcWzCfAQ82zf3TWPvzBR25ibXN0
    FAFYUIH34nAGmXNr2p8HhWpCVUAro1bVzQXJ7vBU2noql4UY+y8/PBeX6cjumhbflQO19G
    /mbXzLRMSD/ldkNd+MzMmCmQ0PgXOkvRpAcyhw6TLXHvcqZc2ExOwAwG2IPSkoO+HXNWTh
    neyw3NH8s18ZZCIWAl50xeVG4Xd/A2MVpeNWGTQedScVWTE/UfoL/ST6dbSvZzjO8kZInG
    XEBkwX373tGfMChPG0y8OZlfehA7pDrOX9T3+OHDfCk16B9WYQaUKmM9XDAA
X-ME-Proxy: <xmx:9TH_ajljazxd0iXEsjwpcvXrc0vUrO5c1PEFt540bCLCw1MUAnyeuw>
    <xmx:9TH_asADqUPRe7z7gYq7DOHI5n-Rxaae6Y0LIjgYFEOe8pNK_XhYQQ>
    <xmx:9TH_aqgWDX4dpDL24d2y1ru8r3gTe3hfFSHwHqpHQj8UUmsPYMJWbQ>
    <xmx:9TH_ahzmkIMztuFqamR4DkFouC1sPvprGWefOLhWtTilXqKsEZ52yw>
    <xmx:9jH_avN4pqyMcOPf9DYpz5rHIIdG-E_l4otWuW8NoFxReJCUG9HM4gMB>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 12:29:24 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: team@rootsys.at
Cc: linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	mike.michalo@gmail.com,
	linux-cifs@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [PATCH 0/4] ksmbd: enforce mandatory signing and encryption on requests
Date: Thu, 19 Nov 2026 11:29:15 -0600
Message-ID: <20261119172915.190740-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119103805.29514-1-research@rootsys.at>
References: <20261119103805.29514-1-research@rootsys.at>
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

I tested the series on ksmbd-for-next 4616bbc5389a with KASAN. I used my
own probes, smbclient, smbtorture, the Linux cifs client and a Windows
11 client. I compared the series with the unpatched head under four
server configurations. The first kept the default settings. The second
made signing mandatory. The third made encryption mandatory. The fourth
made both mandatory.

My probes negotiated SMB 2.1, 3.0, 3.0.2 and 3.1.1, with and without
encryption support. They sent TREE_CONNECT in plaintext, signed and
encrypted. NTLM sessions ran in all four configurations. Kerberos
sessions on 3.0 and 3.1.1 ran in the two configurations with mandatory
encryption. With the series, ksmbd refuses unsigned plaintext requests
on sessions that require signing and negotiated a cipher. It refuses
plaintext requests on sessions told to encrypt, and tree connects
without a cipher when encryption is mandatory. A 3.0 or 3.0.2 client no
longer sees an encryption capability that only an earlier client
offered. Encrypted requests get the same results as without the series,
and so do signed requests on sessions that are not told to encrypt.

Linux client file operations matched those without the series in all
four configurations. The mounts used SMB 2.1, 3.0, 3.0.2 and 3.1.1, each
without sign or seal, with the sign option and with the seal option. The
only difference was the expected SMB 2.1 refusal when encryption is
mandatory. With encryption mandatory, I also tested SMB 3.1.1
multichannel and Kerberos mounts on SMB 3.0 and 3.1.1. One Kerberos
mount was still in use after its ticket expired. Windows 11 mapped a
share and copied, listed and deleted files in all four configurations.
The smbtorture subset I ran gave the same results with and without the
series in each configuration, including one test that times out in both
cases. smbclient also gave the same results, apart from the same SMB 2.1
refusal. No KASAN reports were recorded.

This review leaves out the issues that Sashiko and Michail have already
raised. Apart from those, I found one response-handling issue in the
new rejection path in patch 2. Only a client that sends plaintext on a
session that must encrypt reaches it.

> +	/* MS-SMB2 3.3.5.2.9: a session that must encrypt takes no plaintext */
> +	if (work->sess && work->sess->enc_required && !work->encrypted) {
> +		conn->ops->set_rsp_status(work, STATUS_ACCESS_DENIED);
> +		return SERVER_HANDLER_ABORT;
> +	}

An unsigned plaintext SMB2 CANCEL for a request that is not pending now
gets a STATUS_ACCESS_DENIED response. Without the series it gets no
response, as MS-SMB2 3.3.5.16 requires. That section verifies the
session only for a signed CANCEL.

Thanks,
Ian
